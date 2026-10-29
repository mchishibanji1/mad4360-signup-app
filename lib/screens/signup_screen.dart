import 'package:flutter/material.dart';

import 'success_screen.dart'; // 👈 Added to navigate to the Success Screen

// 👈 Renamed from SignupPage to SignupScreen
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState(); // 👈 Renamed State
}

enum TipStatus { idle, loading, success, error }

class _SignupScreenState extends State<SignupScreen> {
  // 👈 Renamed State Class
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🎂 Potion B — Birth-date picker variables
  final TextEditingController _dateController = TextEditingController();
  DateTime? _birthDate;

  // 🧪 Potion A — Password visibility toggle variable
  bool _obscurePassword = true;

  // ⏳ Potion C — Loading state variable
  bool _submitting = false;

  // ---------- Task A: Local AI Signup Coach (preset demo content) ----------
  static const String _tipCategory = 'password_help';

  static const List<String> _presetTips = [
    'Preset tip: Use a passphrase of 4+ random words — easier to remember, harder to guess. Never reuse your email password here.',
    'Preset tip: Mix upper/lowercase, a number, and a symbol — but length matters more. Aim for 12+ characters.',
    'Preset tip: Keep personal info (name, birthday, pet names) out of your password. This app never sends your password anywhere.',
  ];

  TipStatus _tipStatus = TipStatus.idle;
  String? _currentTip;
  int _tipIndex = 0;
  bool _simulateTipFailure = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose(); // 👈 Dispose the new date controller
    super.dispose();
  }

  // ⏳ Potion C — Loading state before navigation
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true); // potion starts brewing

    // Simulated loading delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return; // user may have left the screen

    // pushReplacement destroys the signup screen so Back doesn't resubmit
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(userName: _nameController.text.trim()),
      ),
    );
  }

  Future<void> _loadPresetTip() async {
    setState(() {
      _tipStatus = TipStatus.loading;
      _currentTip = null;
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    if (_simulateTipFailure) {
      setState(() => _tipStatus = TipStatus.error);
      return;
    }

    final tip = _presetTips[_tipIndex % _presetTips.length];
    _tipIndex = (_tipIndex + 1) % _presetTips.length;
    setState(() {
      _currentTip = tip;
      _tipStatus = TipStatus.success;
    });
  }

  Widget _buildTipCard() {
    return Card(
      margin: const EdgeInsets.only(top: 24),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Signup Coach (local demo)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Preset demo content — not live AI output. Tips never approve signup.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 8),

            if (_tipStatus == TipStatus.idle)
              const Text('Tap "Get a signup tip" to see a preset tip.'),

            if (_tipStatus == TipStatus.loading)
              const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Loading preset tip…'),
                ],
              ),

            if (_tipStatus == TipStatus.success && _currentTip != null)
              Text(_currentTip!),

            if (_tipStatus == TipStatus.error)
              const Text(
                'Could not load a preset tip (local demo).',
                style: TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _tipStatus == TipStatus.loading
                      ? null
                      : _loadPresetTip,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: Text(
                    _tipStatus == TipStatus.error
                        ? 'Retry'
                        : 'Get a signup tip',
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _simulateTipFailure,
                      onChanged: (v) =>
                          setState(() => _simulateTipFailure = v ?? false),
                    ),
                    const Text('Simulate failure (testing)'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enchanted Signup Lab',
        ), // Updated title to match theme
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 👤 Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 📧 Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 🎂 Potion B — Birth-date picker
              TextFormField(
                controller: _dateController,
                readOnly: true, // taps open the picker, not the keyboard
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (_) =>
                    _birthDate == null ? 'Pick your birth date' : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2008),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(), // no future birthdays!
                  );
                  if (picked != null) {
                    setState(() {
                      _birthDate = picked;
                      _dateController.text =
                          '${picked.month}/${picked.day}/${picked.year}';
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // 🔒 Password
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword, // 👈 Potion A connected here
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  // 🧪 Potion A — Password visibility toggle
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ⏳ Potion C — Loading state Button
              ElevatedButton(
                onPressed: _submitting ? null : _submit, // null = disabled
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Join the Mansion',
                        style: TextStyle(fontSize: 18),
                      ),
              ),

              // Task A card
              _buildTipCard(),
            ],
          ),
        ),
      ),
    );
  }
}
