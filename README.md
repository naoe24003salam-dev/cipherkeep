# CypherKeep 🔐

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)](https://www.android.com/)

A privacy-first, offline security vault application built with Flutter. CypherKeep provides military-grade encryption for your sensitive data with a unique decoy mode feature to protect your information under duress.

## 🌟 Features

### 🔒 Dual-Mode Security
- **Real Vault**: Secure access to your actual sensitive data
- **Ghost Mode**: Decoy interface showing innocent todo tasks
- **PIN Authentication**: Separate 4-digit PINs for each mode
- **Biometric Support**: Fingerprint/Face ID authentication (all sensor types)

### 📝 Secure Notes
- End-to-end encrypted note storage
- Search functionality across titles and content
- Grid/List view toggle
- Timestamps for creation and modification
- Tags support for organization

### 🔑 Password Manager
- Secure password storage with encryption
- Built-in password generator (16 characters, special chars)
- Password strength indicator
- One-tap copy to clipboard
- Search by site/username

### 🖼️ Steganography Lab
- Hide secret messages inside images
- LSB (Least Significant Bit) encoding
- Image gallery with thumbnails
- Share encoded images
- Decode messages with one tap

### 🎨 Theming System
- 5 Beautiful themes:
  - Ocean Blue (Default)
  - Crimson Red
  - Forest Green
  - Sunset Orange
  - Purple Dream
- Material 3 Design
- Smooth theme transitions

### 🛡️ Advanced Security Features
- **Panic Wipe**: Auto-delete vault data after max failed attempts
- **Failed Attempt Tracking**: 5-attempt limit with lockout
- **Secure Storage**: Flutter Secure Storage for sensitive data
- **AES-256 Encryption**: Military-grade encryption
- **Offline-First**: No internet required, all data local

### 🎭 Decoy Interface
- Fully functional todo app as cover
- Add/Edit/Delete tasks
- Priority levels (Low/Medium/High)
- Due date management
- Task completion tracking
- Secret vault access via menu

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constants/      # App-wide constants
│   ├── theme/          # Theme definitions
│   └── utils/          # Utility functions
├── data/
│   ├── models/         # Data models (Hive adapters)
│   └── services/       # Services (Storage, Encryption, Biometric)
├── logic/
│   ├── providers/      # Riverpod state management
│   └── state/          # State classes
├── presentation/
│   ├── screens/        # UI screens
│   └── widgets/        # Reusable widgets
└── main.dart           # App entry point
```

### Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod 2.6
- **Navigation**: GoRouter 14.x
- **Local Database**: Hive 2.2
- **Secure Storage**: Flutter Secure Storage
- **Encryption**: AES-256 (encrypt package)
- **Biometric Auth**: local_auth
- **Animations**: flutter_animate, shimmer

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.5.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code
- Android SDK (API 26+)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/naoe24003salam-dev/cipherkeep.git
   cd cipherkeep
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Build release APK**
   ```bash
   flutter build apk --release
   ```

## 📱 Usage

### First Time Setup

1. **Launch App**: See animated splash screen
2. **Setup Wizard**: 
   - Enter Real PIN (4 digits)
   - Confirm Real PIN
   - Enter Ghost PIN (4 digits)
   - Confirm Ghost PIN
   - Select theme preference

3. **Access Modes**:
   - Enter **Real PIN** → Access actual vault
   - Enter **Ghost PIN** → Access decoy todo app
   - Use **Biometric** → Access real vault

### Managing Data

#### Secure Notes
- Tap FAB (+) to create new note
- Enter title and content
- Notes are automatically encrypted
- Search using top search bar
- Toggle grid/list view

#### Password Manager
- Add new password entry
- Use generator for strong passwords
- Copy password with one tap
- View password strength indicator

#### Steganography
- Pick image from gallery
- Enter secret message
- Encode and save
- View encoded images with thumbnails
- Tap to decode message
- Share encoded images

### Settings

- **Change Real PIN**: Update vault access PIN
- **Change Ghost PIN**: Update decoy mode PIN
- **Theme Selection**: Choose from 5 themes
- **Export Vault**: Backup data as JSON
- **Import Vault**: Restore from backup
- **Clear Vault**: Delete all vault data
- **Logout**: Return to PIN screen

## 🔐 Security

### Encryption Details

- **Algorithm**: AES-256 in CBC mode
- **Key Derivation**: PBKDF2 with SHA-256
- **PIN Hashing**: SHA-256
- **Storage**: Flutter Secure Storage (Keychain/Keystore)

### Security Best Practices

✅ All sensitive data encrypted at rest  
✅ PINs hashed before storage  
✅ No plain text credentials  
✅ Secure random number generation  
✅ Memory cleared after use  
✅ No data sent to external servers  

## 📦 Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.5.1      # State management
  hive: ^2.2.3                  # Local database
  flutter_secure_storage: ^9.2.2 # Secure storage
  go_router: ^14.2.0            # Navigation
  encrypt: ^5.0.3               # Encryption
  local_auth: ^2.2.0            # Biometric auth
  image_picker: ^1.1.2          # Image selection
  file_picker: ^8.1.6           # File selection
  share_plus: ^12.0.1           # File sharing
  flutter_animate: ^4.5.0       # Animations
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Salam Universe**
- GitHub: [@naoe24003salam-dev](https://github.com/naoe24003salam-dev)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for elegant state management
- Hive for fast local storage
- All open-source contributors

## 📞 Support

If you have any questions or issues, please open an issue on GitHub.

---

**⚠️ Disclaimer**: This app is designed for personal use. Always use strong PINs and keep backups of your data. The developers are not responsible for any data loss.

**Made with ❤️ using Flutter**
