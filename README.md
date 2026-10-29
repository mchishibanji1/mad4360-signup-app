# MAD 4360 — In-Class Activity 10: Signup Form Quest



# Student Information



Student: Marc Chishibanji

Course: MAD 4360

Activity: In-Class Activity 10 — Signup Form Quest

Track: Undergraduate

Work arrangement: Individual 
Github Repo: https://github.com/mchishibanji1/mad4360-signup-app.git


# Project Overview



Signup Form Quest is a Flutter application that demonstrates a basic signup form with local form validation and a simulated local signup coach.



The application includes three signup fields:



 Name

 Email

 Password



It also includes a local tip feature that displays a preset password-related tip. The feature is designed to demonstrate a simulated loading state, local error handling, and retry behavior without connecting to a live AI service or external server.



# Requirements Implemented



# Signup Form



The form uses local validation to check the user's input.



 - Name is required.

 - Email is required and must contain `@`.

 - Password is required and must contain at least six characters.

 - Signup succeeds only when the form passes validation.



The signup process is a demonstration and does not create a real account or authenticate a user.



# Task A — Local Signup Coach Simulation



The local signup coach demonstrates how an application can display helpful guidance without contacting an external AI service.



\- \*\*Fixed category:\*\* `password\_help`

\- \*\*Response:\*\* A hard-coded preset tip.

\- \*\*Loading:\*\* A brief simulated loading state.

\- \*\*Error handling:\*\* A local error state can be used to demonstrate failure handling.

\- \*\*Retry:\*\* The user can retry after a simulated error.

\- \*\*Content limit:\*\* The displayed tip must be plain text and no longer than 240 characters.

\- \*\*Disclosure:\*\* The interface clearly identifies the response as \*\*“Preset demo content – not live AI output.”\*\*



The feature is deterministic: it uses predefined local content rather than generating a live AI response.



\### Privacy and Safety Boundaries



The local tip feature does not read or transmit the user's name, email address, or password. It does not require a network connection, server, API key, or AI credentials.



The tip feature is separate from signup validation. A displayed tip cannot approve signup, bypass a validation rule, or replace the form's validation logic.



# Undergraduate Reflection Questions



# 1. Trace the local tip feature from button tap to displayed text. Which widget/state changes during simulated loading, and how does the app recover from a local error?



When the user taps the tip button, the application enters a simulated loading state and displays a loading indicator while the local operation is processed. The relevant widget rebuilds when its state changes, after which the preset tip is displayed. If a simulated error occurs, the application displays a local error state and provides a retry option so the user can attempt the operation again.



# 2. Why keep form validation local even when the app can provide a tip? Give an example of a bad decision if AI approved signup.



Form validation should remain local and follow explicit rules so that signup decisions are predictable and consistent. If an AI tip were allowed to approve signup, for example, it might approve a password shorter than six characters and bypass the required validation rule. The tip feature should provide guidance only, never determine whether signup is valid.



# Testing



Run the following tests and record the results you actually observe. Do not mark a test as passed unless you have verified it.



| Test case | Expected result | Actual result |

|---|---|---|

| Submit the form with all fields empty | Required-field validation messages appear | Pending |

| Enter an invalid email without `@` | Email validation fails | Pending |

| Enter a password shorter than six characters | Password validation fails | Pending |

| Enter valid form data | Signup demo succeeds after validation | Pending |

| Tap the local tip button | Preset password tip appears after simulated loading | Pending |

| Trigger the local tip error | A local error message appears | Pending |

| Retry after a local error | The user can retry the tip operation | Pending |

| Check the privacy boundary | The tip feature does not use or transmit name, email, or password | Pending |



# Running the Tests



From the project directory, run:



```bash

flutter test

```



If automated tests have not been written yet, perform the relevant manual tests in the running application and record their observed results.



# Build Instructions



Confirm that Flutter is installed and the project dependencies are available.



```bash

flutter doctor

flutter pub get

flutter run

```



To build a release APK for Android:



```bash

flutter build apk --release

```



The release APK is normally generated at:



```text

build/app/outputs/flutter-apk/app-release.apk

```



If the release build fails, review the error output and resolve the issue before submitting. Use a debug build only if permitted by the assignment instructions.



# Limitations



- The application is a classroom demonstration, not a production authentication system.

- Signup does not create a real account or store user credentials.

- The signup coach uses hard-coded preset content.

- No live AI generation or remote server integration is included.

- The simulated loading and error states demonstrate interface behavior rather than real network failures.



# Contribution Statement



This project was completed individually by Marc Chishibanji for MAD 4360 In-Class Activity 10. The implementation and testing results should reflect the work actually completed.



# Environment



Record the environment used for your final submission:



Framework: Flutter

Language: Dart

Editor: Visual Studio Code

Flutter version: 3.47.3

Dart version: 3.13.3

Platform: Android



# Submission Checklist



Signup form and validation work as required.

Local signup coach displays the required disclosure.

Loading, error, and retry behavior have been tested.

Privacy boundaries have been checked.

README testing results have been updated with actual observations.

Project has been pushed to GitHub.

Android APK has been built successfully.

GitHub repository URL and APK are ready for submission.



