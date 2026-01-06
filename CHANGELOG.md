# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-06

### Added
- 🔐 Dual-mode security system (Real Vault + Ghost Mode)
- 🔑 4-digit PIN authentication for each mode
- 👆 Biometric authentication (fingerprint/face ID) with support for all sensor types
- 📝 Secure Notes feature with encryption
  - Add, edit, delete notes
  - Search functionality
  - Grid/List view toggle
  - Timestamps tracking
- 🔒 Password Manager
  - Secure password storage
  - 16-character password generator
  - Password strength indicator
  - One-tap copy to clipboard
  - Search functionality
- 🖼️ Steganography Lab
  - Hide messages in images using LSB encoding
  - Image gallery with thumbnails
  - Share encoded images
  - Decode with one tap
- 🎨 Theme System
  - 5 beautiful Material 3 themes
  - Ocean Blue (Default)
  - Crimson Red
  - Forest Green
  - Sunset Orange
  - Purple Dream
- ⚙️ Settings & Security
  - Change Real PIN
  - Change Ghost PIN
  - Export vault data (JSON)
  - Import vault data
  - Clear vault data
  - Biometric toggle
- 🛡️ Security Features
  - Panic wipe on max failed attempts (5 attempts)
  - Failed attempt tracking
  - AES-256 encryption
  - Flutter Secure Storage integration
  - PIN hashing with SHA-256
- 🎭 Decoy Interface
  - Fully functional todo app
  - Add/Edit/Delete tasks
  - Priority levels (Low/Medium/High)
  - Due date management
  - Task completion tracking
  - Secret vault access via menu
- 📱 UI/UX
  - Animated splash screen
  - 4-step setup wizard
  - Edge-to-edge display
  - Portrait-only orientation
  - Custom animations with flutter_animate
  - Shimmer effects
  - Material 3 design

### Technical Details
- **Framework**: Flutter 3.x
- **State Management**: Riverpod 2.6
- **Navigation**: GoRouter 14.x
- **Local Database**: Hive 2.2
- **Secure Storage**: Flutter Secure Storage 9.2
- **Encryption**: encrypt 5.0 (AES-256)
- **Biometric**: local_auth 2.2
- **Platform**: Android (API 26+)

### Security
- All sensitive data encrypted at rest
- PINs hashed before storage
- No plain text credentials
- Secure random number generation
- Offline-first architecture
- No data sent to external servers

---

## Release Notes

### v1.0.0 - Initial Release
This is the first stable release of CypherKeep, featuring a complete security vault system with dual-mode authentication, encrypted storage, and a unique decoy mode for enhanced privacy protection.

**Download**: [app-release.apk](build/app/outputs/flutter-apk/app-release.apk) (56.1 MB)

---

[1.0.0]: https://github.com/naoe24003salam-dev/cipherkeep/releases/tag/v1.0.0
