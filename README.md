# 🍳 Delicat

> The best way to catalogue your delicacies. Keep track of your cooking repertoire and expand your dish count.

Delicat is a cross-platform mobile application built with Flutter that helps you manage your personal recipe collection. Create custom categories, add detailed recipes with photos, mark your favorites, and build your culinary knowledge base.

## ✨ Features

- 🗂️ **Custom Categories**: Organize recipes with color-coded categories
- 📸 **Photo Integration**: Add photos to your recipes using camera or gallery
- ⭐ **Favorites System**: Mark and easily access your favorite recipes
- 💾 **Local Storage**: All data stored locally using SQLite, no internet access needed
- 🎨 **Beautiful UI**: Intuitive and visually appealing design
- 🔍 **Search & Filter**: Find recipes quickly across categories

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart (SDK ≥2.12.0)
- **Database**: SQLite (sqflite)
- **State Management**: Provider pattern
- **Architecture**: MVVM with Repository pattern
- **Storage**: Local file system with path_provider

### Key Dependencies
```yaml
provider: ^6.1.2          # State management
sqflite: ^2.3.3           # Local database
image_picker: ^1.1.2      # Camera/gallery access
uuid: ^4.5.1              # Unique ID generation
flutter_colorpicker: ^1.1.0  # Color selection
card_swiper: ^3.0.1       # UI components
```

## 🚀 Getting Started (macOS)

### Prerequisites

#### 1. Install Xcode
```bash
# Install from App Store or download from Apple Developer portal
# After installation, accept the license
sudo xcodebuild -license accept

# Install Xcode Command Line Tools
xcode-select --install
```

#### 2. Install Flutter
```bash
# Using Homebrew (recommended)
brew install flutter

# OR download Flutter SDK manually:
# 1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/macos
# 2. Extract to desired location (e.g., ~/development/)
# 3. Add Flutter to PATH in ~/.zshrc or ~/.bash_profile:
export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"
```

#### 3. Install Android Studio (for Android development)
```bash
# Download from https://developer.android.com/studio
# Install Android SDK and create virtual device
```

#### 4. Verify Installation
```bash
flutter doctor
```
Fix any issues shown by `flutter doctor` before proceeding.

### 🔧 Project Setup

#### 1. Clone Repository
```bash
git clone <repository-url>
cd delicat
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Configure API Keys (Optional - for future Unsplash integration)
```bash
# Copy the example file
cp assets/Keys.example.json assets/Keys.json

# Edit assets/Keys.json with your Unsplash API credentials
# Get keys from: https://unsplash.com/developers
```

#### 4. iOS Setup
```bash
# Navigate to iOS directory
cd ios

# Install CocoaPods dependencies
pod install

# Return to project root
cd ..
```

#### 5. Android Setup
```bash
# Accept Android licenses
flutter doctor --android-licenses
```

### ▶️ Running the App

#### iOS Simulator
```bash
# List available simulators
xcrun simctl list devices

# Run on iOS simulator
flutter run -d ios
```

#### Android Emulator
```bash
# List available devices
flutter devices

# Run on Android emulator
flutter run -d android
```

#### Physical Device
```bash
# Enable developer options and USB debugging on Android
# For iOS, ensure device is registered in Xcode

# Run on connected device
flutter run
```

### 🏗️ Build for Release

#### iOS
```bash
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode for App Store submission
```

#### Android
```bash
flutter build apk --release
# APK will be available at build/app/outputs/flutter-apk/app-release.apk
```

## 🧪 Development

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Formatting
```bash
flutter format .
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── providers/                # State management
├── screens/                  # UI screens
├── helpers/                  # Utility functions
└── constants.dart           # App constants

assets/
├── Keys.json               # API keys (gitignored)
├── Keys.example.json       # API keys template
└── photos/                 # Default category images
```

## 📱 Screenshots

<!-- Add screenshots here when available -->

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Happy Cooking! 👨‍🍳👩‍🍳**
