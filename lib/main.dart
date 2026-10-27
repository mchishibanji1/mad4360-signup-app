import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 🧓 Great-Grandparent
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

enum TipStatus { idle, loading, success, error }

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ---------- Task A: Local AI Signup Coach (preset demo content) ----------
  // Fixed local category. Form values are NEVER read here.
  static const String _tipCategory = 'password_help';

  // Preset tips stored in the app. Not live AI output. Each <= 240 chars.
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
    super.dispose();
  }

  Future<void> _loadPresetTip() async {
    setState(() {
      _tipStatus = TipStatus.loading;
      _currentTip = null;
    });

    // Simulated local loading delay (no network).
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
        title: const Text('Join Us Today!'),
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

              // 🔒 Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
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

              // 🚀 Sign Up — validators decide, tips never do
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Demo signup complete — your form passed validation!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
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
