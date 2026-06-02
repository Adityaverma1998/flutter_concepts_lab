# flutter_login_signup_app

A Flutter application demonstrating offline authentication using Floor Database, BLoC State Management, Dependency Injection, and Secure Session Management.

## Features

* Splash Screen with Session Validation
* User Registration
* User Login
* Logout Functionality
* Auto Login on App Restart
* Profile Image Selection (Camera & Gallery)
* Local User Data Storage
* Secure Session Management
* Password Hashing using SHA256
* Responsive UI using ScreenUtil

## Architecture

This project follows Clean Architecture principles with:

* MVVM Architecture
* BLoC State Management
* Repository Pattern
* Dependency Injection using GetIt
* Floor Database (SQLite ORM)
* Secure Storage for Session Management

## Packages Used

```yaml
flutter_bloc
equatable
floor
sqflite
get_it
either_dart
flutter_secure_storage
image_picker
crypto
flutter_screenutil
path
path_provider
```

## Project Structure

```text
lib/
│
├── core/
│   ├── services/
│   ├── validators/
│   ├── routes/
│   └── utils/
│
├── data/
│   ├── database/
│   ├── models/
│   └── repositories/
│
├── domain/
│   └── repositories/
│
├── presentation/
│   ├── splash/
│   ├── auth/
│   ├── home/
│   └── widgets/
│
├── injection/
│
└── main.dart
```

## Routing

This project uses Navigator API for navigation.

```dart
Navigator.push()
Navigator.pushReplacement()
Navigator.pushAndRemoveUntil()
```

Navigation Flow:

```text
Splash Screen
      ↓
Login Screen
      ↓
Signup Screen
      ↓
Home Screen
      ↓
Logout
      ↓
Login Screen
```

## Environment

### Flutter SDK

```bash
Flutter 3.35.0
Dart 3.9.0
```

### Java Version

```bash
OpenJDK 17.0.13
```

## Getting Started

Install dependencies:

```bash
flutter pub get
```

Generate Floor database files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run the application:

```bash
flutter run
```

## Author

Aditya Verma

Flutter Developer
