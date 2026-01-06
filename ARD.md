# CipherKeep: The Invisible Vault
## Complete GitHub Copilot Development Guide
**Developer:** SalamUniverse

---

## 📋 PROJECT OVERVIEW

**CipherKeep** is a cutting-edge, 100% offline privacy and security utility that combines steganography, dual-authentication, and decoy interfaces to provide maximum security for sensitive data.

### Unique Features:
- 🎭 **Ghost PIN System**: Decoy interface activated with alternate PIN
- 🖼️ **Steganography**: Hide data inside images using LSB encoding
- 🔐 **Military-Grade Encryption**: AES-256 for all sensitive data
- 🎨 **Multiple Themes**: 5 beautiful themes (Cyberpunk, Ocean, Forest, Sunset, Minimal)
- ⚡ **Edge-to-Edge UI**: Modern Android 15 compliant design
- 📱 **16KB Page Size Support**: Optimized for latest Android requirements
- 🚨 **Panic Features**: Self-destruct and quick wipe capabilities
- 💾 **100% Offline**: Zero internet permissions, no data collection

---

## 🚀 TECHNICAL REQUIREMENTS

### Prerequisites
- Flutter SDK: 3.24.0 or higher
- Dart SDK: 3.5.0 or higher
- Android targetSdkVersion: 35 (Android 15)
- Minimum SDK: 26 (Android 8.0)

### Build Configuration for 16KB Memory Page Size
```yaml
# Required in build.gradle
android {
    ndkVersion "27.0.12077973"
    splits {
        abi {
            enable true
            reset()
            include 'arm64-v8a', 'armeabi-v7a', 'x86_64'
        }
    }
}
```

---

## 📁 PROJECT STRUCTURE

```
cipher_keep/
├── android/
│   └── app/
│       ├── build.gradle (16KB page size config)
│       └── src/main/AndroidManifest.xml
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── app_config.dart
│   │   ├── themes/
│   │   │   ├── theme_data.dart
│   │   │   ├── cyberpunk_theme.dart
│   │   │   ├── ocean_theme.dart
│   │   │   ├── forest_theme.dart
│   │   │   ├── sunset_theme.dart
│   │   │   └── minimal_theme.dart
│   │   └── routes.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   └── storage_keys.dart
│   │   ├── utils/
│   │   │   ├── stego_engine.dart
│   │   │   ├── encryption_service.dart
│   │   │   ├── validators.dart
│   │   │   └── logger.dart
│   │   └── extensions/
│   │       ├── context_extensions.dart
│   │       └── string_extensions.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── secure_note.dart
│   │   │   ├── encoded_image.dart
│   │   │   ├── password_entry.dart
│   │   │   ├── todo_item.dart (decoy)
│   │   │   └── user_settings.dart
│   │   ├── repositories/
│   │   │   ├── vault_repository.dart
│   │   │   ├── decoy_repository.dart
│   │   │   └── settings_repository.dart
│   │   └── services/
│   │       ├── secure_storage_service.dart
│   │       ├── biometric_service.dart
│   │       ├── hive_service.dart
│   │       └── file_service.dart
│   ├── logic/
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── vault_provider.dart
│   │   │   ├── decoy_provider.dart
│   │   │   ├── theme_provider.dart
│   │   │   └── settings_provider.dart
│   │   └── state/
│   │       ├── auth_state.dart
│   │       ├── vault_state.dart
│   │       └── app_state.dart
│   └── presentation/
│       ├── screens/
│       │   ├── splash/
│       │   │   └── splash_screen.dart
│       │   ├── onboarding/
│       │   │   ├── onboarding_screen.dart
│       │   │   └── setup_screen.dart
│       │   ├── auth/
│       │   │   ├── pin_screen.dart
│       │   │   └── biometric_screen.dart
│       │   ├── decoy/
│       │   │   ├── decoy_home_screen.dart
│       │   │   └── decoy_todo_screen.dart
│       │   ├── vault/
│       │   │   ├── vault_home_screen.dart
│       │   │   ├── secure_notes_screen.dart
│       │   │   ├── password_manager_screen.dart
│       │   │   ├── stego_lab_screen.dart
│       │   │   └── vault_settings_screen.dart
│       │   └── shared/
│       │       └── error_screen.dart
│       └── widgets/
│           ├── custom_pin_pad.dart
│           ├── animated_card.dart
│           ├── secure_text_field.dart
│           ├── theme_selector.dart
│           ├── password_strength_indicator.dart
│           └── biometric_button.dart
└── test/
    ├── unit/
    ├── widget/
    └── integration/
```

---

# 🎯 PHASE-BY-PHASE DEVELOPMENT

## ⚠️ IMPORTANT: Error Checking Protocol

**After EVERY file creation, GitHub Copilot MUST:**
1. Run `flutter analyze` to check for compilation errors
2. Fix all errors before proceeding to next file
3. Verify imports and dependencies
4. Test the created widget/screen if possible
5. Document any warnings that need attention

---

## 📦 PHASE 0: PROJECT INITIALIZATION

### Step 0.1: Create Project
```bash
flutter create cipher_keep --org com.salamuniverse.cipherkeep
cd cipher_keep
```

### Step 0.2: Update pubspec.yaml

**Prompt for Copilot:**
```
Create a comprehensive pubspec.yaml file for CipherKeep with the following requirements:

1. Set app name: "CipherKeep"
2. Description: "Privacy-first offline security vault by SalamUniverse"
3. Version: 1.0.0+1
4. Flutter SDK: >=3.24.0 <4.0.0

5. Add these dependencies:
   - flutter_riverpod: ^2.5.1
   - riverpod_annotation: ^2.3.5
   - hive: ^2.2.3
   - hive_flutter: ^1.1.0
   - flutter_secure_storage: ^9.2.2
   - go_router: ^14.2.0
   - image_picker: ^1.1.2
   - permission_handler: ^11.3.1
   - local_auth: ^2.2.0
   - encrypt: ^5.0.3
   - image: ^4.2.0
   - path_provider: ^2.1.3
   - share_plus: ^9.0.0
   - uuid: ^4.4.0
   - intl: ^0.19.0
   - animations: ^2.0.11
   - flutter_animate: ^4.5.0
   - shimmer: ^3.0.0
   - lottie: ^3.1.2

6. Dev dependencies:
   - flutter_test
   - flutter_lints: ^4.0.0
   - build_runner: ^2.4.11
   - hive_generator: ^2.0.1
   - riverpod_generator: ^2.4.0
   - mockito: ^5.4.4

7. Assets section for:
   - assets/animations/
   - assets/images/
   - assets/icons/

After creating, run:
- flutter pub get
- flutter analyze

Fix any errors before proceeding.
```

### Step 0.3: Configure Android for 16KB Page Size & Edge-to-Edge

**Prompt for Copilot:**
```
Update android/app/build.gradle with these exact configurations:

1. Set compileSdk = 35
2. Set minSdk = 26
3. Set targetSdk = 35
4. Set ndkVersion = "27.0.12077973"
5. Add namespace 'com.salamuniverse.cipherkeep'

6. Configure for 16KB memory page size:
android {
    splits {
        abi {
            enable true
            reset()
            include 'arm64-v8a', 'armeabi-v7a', 'x86_64'
        }
    }
}

7. Enable edge-to-edge display:
   - Add window insets handling
   - Configure transparent status bar

8. Update AndroidManifest.xml:
   - Remove INTERNET permission
   - Add USE_BIOMETRIC permission
   - Add READ_EXTERNAL_STORAGE permission (for API < 33)
   - Add READ_MEDIA_IMAGES permission (for API >= 33)
   - Add WRITE_EXTERNAL_STORAGE permission (for API < 29)
   - Configure for edge-to-edge: android:windowSoftInputMode="adjustResize"
   - Set android:enableOnBackInvokedCallback="true"

9. Update MainActivity.kt for edge-to-edge:
   - Enable WindowCompat.setDecorFitsSystemWindows(window, false)

After making changes:
- Run flutter clean
- Run flutter pub get
- Run flutter analyze
- Fix any errors
```

---

## 🎨 PHASE 1: CORE CONFIGURATION & THEMING

### Step 1.1: Create Theme System

**Prompt for Copilot:**
```
Create a comprehensive theme system in lib/config/themes/:

1. Create theme_data.dart with AppTheme enum:
   - Cyberpunk (neon green/purple on black)
   - Ocean (deep blue/cyan gradients)
   - Forest (emerald green/earth tones)
   - Sunset (orange/pink gradients)
   - Minimal (clean black/white/grey)

2. For EACH theme, create:
   - Custom ColorScheme
   - TextTheme with multiple font sizes
   - CardTheme with elevation and borders
   - AppBarTheme
   - BottomNavigationBarTheme
   - InputDecorationTheme
   - ButtonTheme variants

3. All themes MUST support:
   - Edge-to-edge safe areas
   - Smooth color transitions
   - High contrast for accessibility
   - Dark mode optimization

4. Export all themes from a single theme_data.dart

Example structure for Cyberpunk theme:
- Primary: Color(0xFF00FF41) // Matrix green
- Secondary: Color(0xFFBF00FF) // Cyber purple  
- Background: Color(0xFF0A0E27)
- Surface: Color(0xFF1A1F3A)
- Error: Color(0xFFFF3366)

Run flutter analyze after creation. Fix all errors.
```

### Step 1.2: Create App Configuration

**Prompt for Copilot:**
```
Create lib/config/app_config.dart with:

1. AppConfig class containing:
   - App version and build number
   - Developer name: "SalamUniverse"
   - Support email: support@salamuniverse.com
   - Max failed attempts: 5
   - Auto-lock timeout: 5 minutes
   - Supported image formats
   - Max file sizes
   - Encryption algorithm details

2. Create FeatureFlags class:
   - biometricEnabled
   - panicButtonEnabled
   - stegoEnabled
   - themeCustomization

3. Constants for:
   - PIN length (6 digits)
   - Password strength requirements
   - File size limits
   - Animation durations

Ensure all values are type-safe with proper documentation.
Run flutter analyze and fix errors.
```

### Step 1.3: Create Core Constants

**Prompt for Copilot:**
```
Create lib/core/constants/app_constants.dart and storage_keys.dart:

1. app_constants.dart:
   - Animation durations (fast: 200ms, normal: 300ms, slow: 500ms)
   - Border radius values
   - Padding/margin constants
   - Icon sizes
   - Font sizes
   - Elevation levels

2. storage_keys.dart:
   - Hive box names (vaultBox, decoyBox, settingsBox)
   - Secure storage keys (realPin, ghostPin, biometricEnabled)
   - Preference keys
   - All keys should be constants with proper naming

Use descriptive names and group related constants.
Run flutter analyze and fix errors.
```

---

## 🔐 PHASE 2: DATA LAYER - MODELS & SERVICES

### Step 2.1: Create Data Models with Hive

**Prompt for Copilot:**
```
Create Hive models in lib/data/models/:

1. secure_note.dart:
   @HiveType(typeId: 0)
   class SecureNote {
     @HiveField(0) String id;
     @HiveField(1) String title;
     @HiveField(2) String encryptedContent;
     @HiveField(3) DateTime createdAt;
     @HiveField(4) DateTime modifiedAt;
     @HiveField(5) List<String> tags;
     @HiveField(6) bool isFavorite;
     @HiveField(7) String color; // for UI customization
   }

2. encoded_image.dart:
   @HiveType(typeId: 1)
   class EncodedImage {
     @HiveField(0) String id;
     @HiveField(1) String originalPath;
     @HiveField(2) String encodedPath;
     @HiveField(3) String thumbnailPath;
     @HiveField(4) int messageLength;
     @HiveField(5) DateTime encodedAt;
     @HiveField(6) String title;
   }

3. password_entry.dart:
   @HiveType(typeId: 2)
   class PasswordEntry {
     @HiveField(0) String id;
     @HiveField(1) String title;
     @HiveField(2) String encryptedUsername;
     @HiveField(3) String encryptedPassword;
     @HiveField(4) String url;
     @HiveField(5) String notes;
     @HiveField(6) DateTime createdAt;
     @HiveField(7) DateTime lastModified;
     @HiveField(8) List<String> tags;
     @HiveField(9) String icon; // app icon identifier
   }

4. todo_item.dart (for decoy):
   @HiveType(typeId: 3)
   class TodoItem {
     @HiveField(0) String id;
     @HiveField(1) String title;
     @HiveField(2) String description;
     @HiveField(3) bool isCompleted;
     @HiveField(4) DateTime createdAt;
     @HiveField(5) DateTime? dueDate;
     @HiveField(6) int priority; // 1-5
   }

5. user_settings.dart:
   @HiveType(typeId: 4)
   class UserSettings {
     @HiveField(0) String themeMode; // AppTheme enum as string
     @HiveField(1) bool biometricEnabled;
     @HiveField(2) bool autoLockEnabled;
     @HiveField(3) int autoLockMinutes;
     @HiveField(4) bool panicWipeEnabled;
     @HiveField(5) int maxFailedAttempts;
     @HiveField(6) bool hapticFeedback;
     @HiveField(7) String language;
   }

For each model:
- Add .g.dart part file declaration
- Add toJson/fromJson methods
- Add copyWith method
- Add equality override

After creation, run:
- flutter pub run build_runner build --delete-conflicting-outputs
- flutter analyze
- Fix any errors
```

### Step 2.2: Create Encryption Service

**Prompt for Copilot:**
```
Create lib/data/services/encryption_service.dart:

1. EncryptionService class using AES-256-GCM:
   - Generate secure random IV for each encryption
   - Use PBKDF2 for key derivation from PIN
   - Methods:
     * Future<String> encrypt(String plaintext, String key)
     * Future<String> decrypt(String ciphertext, String key)
     * String generateSecureKey()
     * bool verifyIntegrity(String data, String hash)

2. Use the encrypt package properly:
   - final key = Key.fromUtf8(derivedKey);
   - final iv = IV.fromSecureRandom(16);
   - final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

3. Add proper error handling:
   - Try-catch blocks
   - Custom EncryptionException
   - Logging for debugging (without exposing sensitive data)

4. Add comments explaining security measures

Test the encryption/decryption with sample data.
Run flutter analyze and fix errors.
```

### Step 2.3: Create Steganography Engine

**Prompt for Copilot:**
```
Create lib/core/utils/stego_engine.dart:

Implement LSB (Least Significant Bit) steganography:

1. encodeMessage method:
   - Accept File image and String message
   - Compress message if needed
   - Convert message to binary
   - Hide in LSB of RGB channels
   - Add header with message length
   - Return new encoded image File

2. decodeMessage method:
   - Accept File image
   - Read header to get message length
   - Extract bits from LSB
   - Convert binary back to string
   - Return decoded message

3. Helper methods:
   - String _stringToBinary(String text)
   - String _binaryToString(String binary)
   - bool canFitMessage(File image, String message)
   - double getCapacity(File image) // in bytes

4. Use the image package:
   - import 'package:image/image.dart' as img;
   - Decode image: img.decodeImage(bytes)
   - Manipulate pixels
   - Encode back: img.encodePng(image)

5. Error handling:
   - Check if image is large enough
   - Validate message format
   - Handle corrupted data

Add detailed comments explaining the algorithm.
Test with a sample image and message.
Run flutter analyze and fix errors.
```

### Step 2.4: Create Secure Storage Service

**Prompt for Copilot:**
```
Create lib/data/services/secure_storage_service.dart:

Wrapper around flutter_secure_storage:

1. SecureStorageService class with methods:
   - Future<void> saveRealPin(String pin)
   - Future<String?> getRealPin()
   - Future<void> saveGhostPin(String pin)
   - Future<String?> getGhostPin()
   - Future<void> saveBiometricEnabled(bool enabled)
   - Future<bool> getBiometricEnabled()
   - Future<void> saveEncryptionKey(String key)
   - Future<String?> getEncryptionKey()
   - Future<void> deleteAll()

2. Use proper options:
   AndroidOptions(
     encryptedSharedPreferences: true,
     resetOnError: true,
   )
   IOSOptions(
     accessibility: KeychainAccessibility.first_unlock_this_device,
   )

3. Add singleton pattern:
   static final SecureStorageService _instance = SecureStorageService._internal();
   factory SecureStorageService() => _instance;

4. Error handling with try-catch
5. Add logging

Test each method.
Run flutter analyze and fix errors.
```

### Step 2.5: Create Biometric Service

**Prompt for Copilot:**
```
Create lib/data/services/biometric_service.dart:

1. BiometricService class:
   - Future<bool> isBiometricAvailable()
   - Future<bool> authenticate({String reason})
   - Future<List<BiometricType>> getAvailableBiometrics()
   - Stream<bool> get authenticationStatus

2. Use local_auth package:
   - Check device support
   - Handle different biometric types (fingerprint, face)
   - Proper error messages

3. Integration with secure storage:
   - Check if biometric is enabled in settings
   - Fall back to PIN if biometric fails

4. Handle edge cases:
   - Device doesn't support biometrics
   - User cancels authentication
   - Too many failed attempts

Add comprehensive error handling.
Run flutter analyze and fix errors.
```

### Step 2.6: Create Hive Service

**Prompt for Copilot:**
```
Create lib/data/services/hive_service.dart:

1. HiveService class for initialization:
   - Future<void> init() async {
       await Hive.initFlutter();
       Hive.registerAdapter(SecureNoteAdapter());
       Hive.registerAdapter(EncodedImageAdapter());
       Hive.registerAdapter(PasswordEntryAdapter());
       Hive.registerAdapter(TodoItemAdapter());
       Hive.registerAdapter(UserSettingsAdapter());
       
       await Hive.openBox<SecureNote>('vaultNotesBox');
       await Hive.openBox<EncodedImage>('vaultImagesBox');
       await Hive.openBox<PasswordEntry>('vaultPasswordsBox');
       await Hive.openBox<TodoItem>('decoyTodoBox');
       await Hive.openBox<UserSettings>('settingsBox');
     }

2. Methods for encryption:
   - Future<void> setEncryptionKey(String key)
   - Open encrypted boxes for vault data

3. Cleanup method:
   - Future<void> deleteVaultData() // for panic wipe
   - Future<void> deleteAllData()
   - Future<void> close()

4. Singleton pattern

Run flutter analyze and fix errors.
```

---

## 🎯 PHASE 3: BUSINESS LOGIC - PROVIDERS & STATE

### Step 3.1: Create Auth Provider

**Prompt for Copilot:**
```
Create lib/logic/providers/auth_provider.dart using Riverpod:

1. AuthNotifier class:
   - State: AuthState (authenticated, unauthenticated, decoyMode, loading)
   - failedAttempts counter
   - lastAttemptTime

2. Methods:
   - Future<void> setupPins(String realPin, String ghostPin)
   - Future<AuthResult> authenticateWithPin(String pin)
   - Future<AuthResult> authenticateWithBiometric()
   - void incrementFailedAttempts()
   - Future<void> triggerPanicWipe()
   - Future<void> logout()
   - Future<bool> hasExistingSetup()

3. Logic:
   - If pin matches realPin -> navigate to vault
   - If pin matches ghostPin -> navigate to decoy (no visual difference!)
   - If wrong pin:
     * Increment counter
     * Check if max attempts reached
     * Trigger wipe if enabled and limit reached

4. Use SecureStorageService and EncryptionService

5. Proper error handling with custom exceptions

Create corresponding auth_state.dart with:
- Sealed class AuthState
- AuthAuthenticated, AuthUnauthenticated, AuthDecoy, AuthLoading states

Run flutter analyze and fix errors.
```

### Step 3.2: Create Vault Provider

**Prompt for Copilot:**
```
Create lib/logic/providers/vault_provider.dart:

1. VaultNotifier for managing vault data:
   - State: VaultState (notes, images, passwords)
   - CRUD operations for all vault items
   - Search and filter functionality
   - Tag management

2. Methods for Secure Notes:
   - Future<void> addNote(SecureNote note)
   - Future<void> updateNote(SecureNote note)
   - Future<void> deleteNote(String id)
   - List<SecureNote> searchNotes(String query)
   - List<SecureNote> getNotesByTag(String tag)

3. Methods for Encoded Images:
   - Future<void> encodeAndSaveImage(File image, String message, String title)
   - Future<String> decodeImageMessage(String imageId)
   - Future<void> deleteEncodedImage(String id)
   - List<EncodedImage> getAllImages()

4. Methods for Passwords:
   - Future<void> addPassword(PasswordEntry entry)
   - Future<void> updatePassword(PasswordEntry entry)
   - Future<void> deletePassword(String id)
   - Future<String> getDecryptedPassword(String id)
   - List<PasswordEntry> searchPasswords(String query)

5. Use:
   - Hive for storage
   - EncryptionService for data encryption
   - StegoEngine for image encoding

6. Add loading states and error handling

Run flutter analyze and fix errors.
```

### Step 3.3: Create Decoy Provider

**Prompt for Copilot:**
```
Create lib/logic/providers/decoy_provider.dart:

Simple provider for the fake todo app:

1. DecoyNotifier for todo management:
   - State: List<TodoItem>
   - Basic CRUD operations

2. Methods:
   - Future<void> addTodo(TodoItem item)
   - Future<void> updateTodo(TodoItem item)
   - Future<void> deleteTodo(String id)
   - Future<void> toggleComplete(String id)
   - List<TodoItem> getActiveTodos()
   - List<TodoItem> getCompletedTodos()

3. Use Hive 'decoyTodoBox'

4. Make it look realistic:
   - Add some default todos on first launch
   - Simple, boring functionality
   - No advanced features

Run flutter analyze and fix errors.
```

### Step 3.4: Create Theme Provider

**Prompt for Copilot:**
```
Create lib/logic/providers/theme_provider.dart:

1. ThemeNotifier:
   - State: AppTheme enum
   - Load theme from settings
   - Persist theme changes

2. Methods:
   - void setTheme(AppTheme theme)
   - ThemeData getCurrentThemeData()
   - List<AppTheme> getAvailableThemes()

3. Integration:
   - Save to UserSettings in Hive
   - Notify listeners on change
   - Support theme transitions

Run flutter analyze and fix errors.
```

### Step 3.5: Create Settings Provider

**Prompt for Copilot:**
```
Create lib/logic/providers/settings_provider.dart:

1. SettingsNotifier managing UserSettings:
   - Load settings on init
   - Update individual settings
   - Validate setting changes

2. Methods:
   - Future<void> toggleBiometric()
   - Future<void> setAutoLockTimeout(int minutes)
   - Future<void> togglePanicWipe()
   - Future<void> setMaxFailedAttempts(int attempts)
   - Future<void> toggleHapticFeedback()
   - Future<void> exportVaultBackup()
   - Future<void> resetApp()

3. Use Hive and SecureStorageService

Run flutter analyze and fix errors.
```

---

## 🎨 PHASE 4: UI FOUNDATION - WIDGETS & COMPONENTS

### Step 4.1: Create Custom PIN Pad

**Prompt for Copilot:**
```
Create lib/presentation/widgets/custom_pin_pad.dart:

Beautiful, animated PIN entry widget:

1. CustomPinPad widget:
   - 10 number buttons (0-9)
   - Backspace button
   - Biometric button (if available)
   - PIN dots display (•••••• for 6 digits)

2. Features:
   - Haptic feedback on press
   - Ripple animation on button press
   - Shake animation on wrong PIN
   - Smooth number entry animation
   - Obscure PIN dots after 2 seconds

3. Styling:
   - Responsive to screen size
   - Theme-aware colors
   - Glassmorphism effect for buttons
   - Smooth transitions

4. Callbacks:
   - onPinComplete(String pin)
   - onBiometricPressed()

5. Use flutter_animate for animations:
   - Scale animation on button press
   - Slide animation for PIN dots
   - Shake animation on error

Run flutter analyze and test the widget in isolation.
Fix any errors.
```

### Step 4.2: Create Animated Card Widget

**Prompt for Copilot:**
```
Create lib/presentation/widgets/animated_card.dart:

Reusable card widget with beautiful animations:

1. AnimatedCard widget:
   - Hero animation support
   - Hover effects (for desktop)
   - Long-press menu
   - Swipe-to-delete gesture

2. Properties:
   - title, subtitle, trailing icon
   - onTap, onLongPress callbacks
   - custom colors and elevation
   - Optional thumbnail/icon

3. Animations:
   - Entrance animation (slide + fade)
   - Shimmer loading effect
   - Delete swipe animation
   - Scale on press

4. Accessibility:
   - Semantic labels
   - Touch target size (48x48 minimum)

Use the animations package.
Run flutter analyze and fix errors.
```

### Step 4.3: Create Secure Text Field

**Prompt for Copilot:**
```
Create lib/presentation/widgets/secure_text_field.dart:

Enhanced text field for passwords and sensitive data:

1. SecureTextField widget:
   - Password visibility toggle
   - Copy button with auto-clear after 30s
   - Strong password generator
   - Validation feedback

2. Features:
   - Show/hide password icon
   - Strength indicator (weak/medium/strong)
   - Character counter
   - Error messages
   - Auto-focus support

3. Validation:
   - Minimum length check
   - Complexity requirements
   - Real-time feedback

4. Styling:
   - Theme-aware
   - Custom border colors
   - Smooth focus transitions
   - Icons that change on state

Run flutter analyze and fix errors.
```

### Step 4.4: Create Password Strength Indicator

**Prompt for Copilot:**
```
Create lib/presentation/widgets/password_strength_indicator.dart:

Visual password strength meter:

1. PasswordStrengthIndicator widget:
   - 4-segment bar
   - Color progression (red -> yellow -> green)
   - Strength label (Weak, Fair, Good, Strong)
   - Animated transitions

2. Strength calculation:
   - Length >= 8 characters
   - Contains uppercase and lowercase
   - Contains numbers
   - Contains special characters
   - Not in common password list

3. Animations:
   - Fill animation for segments
   - Color transition
   - Label fade in/out

Run flutter analyze and fix errors.
```

### Step 4.5: Create Theme Selector Widget

**Prompt for Copilot:**
```
Create lib/presentation/widgets/theme_selector.dart:

Beautiful theme selection interface:

1. ThemeSelector widget:
   - Horizontal scrollable list of theme previews
   - Each preview shows the theme's color scheme
   - Selected theme has checkmark and scale animation
   - Smooth color transitions

2. Theme Preview Card:
   - Shows primary, secondary, background colors
   - Theme name label
   - Selection indicator
   - Touch feedback

3. Use the theme provider to change themes

4. Animations:
   - Selection scale animation
   - Color morph transition
   - Ripple effect on tap

Run flutter analyze and fix errors.
```

### Step 4.6: Create Biometric Button

**Prompt for Copilot:**
```
Create lib/presentation/widgets/biometric_button.dart:

Animated biometric authentication button:

1. BiometricButton widget:
   - Fingerprint or face icon (based on available biometric)
   - Pulse animation
   - Loading state
   - Success/failure feedback

2. States:
   - idle (pulse animation)
   - authenticating (spinner)
   - success (checkmark + scale)
   - failure (shake + red tint)

3. Use lottie for fingerprint animation if possible

4. Haptic feedback on press

Run flutter analyze and fix errors.
```

---

## 📱 PHASE 5: SPLASH & ONBOARDING SCREENS

### Step 5.1: Create Splash Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/splash/splash_screen.dart:

Beautiful animated splash screen:

1. Display:
   - "CipherKeep" logo/text with gradient animation
   - "by SalamUniverse" subtitle
   - Loading indicator
   - Version number at bottom

2. Logic:
   - Check if app is set up (has PINs)
   - Initialize Hive
   - Load user settings
   - Navigate to:
     * OnboardingScreen if first launch
     * PinScreen if already set up

3. Animations:
   - Fade in logo
   - Shimmer effect on text
   - Smooth transition to next screen

4. Use edge-to-edge layout:
   - Transparent status bar
   - Handle safe area insets

Run flutter analyze and test navigation.
Fix any errors.
```

### Step 5.2: Create Onboarding Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/onboarding/onboarding_screen.dart:

Multi-page onboarding with PageView:

1. Three pages explaining:
   - Page 1: "Military-Grade Security" 
     * AES-256 encryption
     * 100% offline
     * No data collection
   
   - Page 2: "Invisible Protection"
     * Ghost PIN feature
     * Decoy interface
     * Steganography
   
   - Page 3: "Complete Privacy"
     * Self-destruct options
     * Biometric support
     * Zero traces

2. Each page:
   - Beautiful illustration or lottie animation
   - Title and description
   - Theme-colored accents

3. Navigation:
   - Swipe between pages
   - Page indicator dots
   - "Next" button
   - "Get Started" on last page

4. Smooth page transitions with animations

Navigate to SetupScreen on complete.
Run flutter analyze and fix errors.
```

### Step 5.3: Create Setup Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/onboarding/setup_screen.dart:

Initial setup wizard:

1. Step 1: Create Real PIN
   - CustomPinPad widget
   - "Enter your Real PIN" title
   - "This unlocks your vault" description
   - 6-digit PIN
   - Confirm PIN step

2. Step 2: Create Ghost PIN
   - CustomPinPad widget
   - "Enter your Ghost PIN" title
   - "This shows the decoy app" description
   - Must be different from Real PIN
   - Confirm PIN step

3. Step 3: Optional Biometric
   - Enable biometric authentication
   - Skip option

4. Step 4: Choose Theme
   - ThemeSelector widget
   - Preview of selected theme

5. Progress indicator at top

6. Validation:
   - PINs are not the same
   - PINs are 6 digits
   - Confirmation matches

7. Save setup:
   - Save PINs to SecureStorage
   - Save settings to Hive
   - Navigate to PinScreen

Use flutter_animate for step transitions.
Run flutter analyze and fix errors.
```

---

## 🔐 PHASE 6: AUTHENTICATION SCREENS

### Step 6.1: Create PIN Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/auth/pin_screen.dart:

Main authentication screen:

1. Display:
   - "CipherKeep" title at top
   - "Enter PIN" instruction
   - CustomPinPad widget
   - Biometric button (if enabled)
   - Failed attempts indicator (only shows after first failure)

2. Logic:
   - Get entered PIN from CustomPinPad
   - When 6 digits entered:
     * Show loading spinner
     * Call authProvider.authenticateWithPin()
     * If real PIN -> navigate to /vault
     * If ghost PIN -> navigate to /decoy
     * If wrong:
       - Shake animation
       - Show error message
       - Increment failed attempts
       - Clear PIN input
       - Check if max attempts reached -> trigger panic wipe

3. Failed attempts handling:
   - Show "X/5 attempts remaining"
   - Red color when close to limit
   - Trigger panic wipe if enabled

4. Edge-to-edge UI:
   - Gradient background
   - Safe area padding
   - Handle keyboard insets

5. Animations:
   - Entrance animation
   - Shake on wrong PIN
   - Success checkmark before navigation

Run flutter analyze and test both PIN scenarios.
Fix any errors.
```

### Step 6.2: Create Biometric Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/auth/biometric_screen.dart:

Optional biometric authentication overlay:

1. Display:
   - Large fingerprint/face icon with pulse animation
   - "Authenticate with biometrics" text
   - "Use PIN instead" button

2. Logic:
   - Automatically trigger biometric prompt on mount
   - On success -> check if vault or decoy mode -> navigate
   - On failure -> allow retry or fall back to PIN
   - On cancel -> stay on screen

3. Use BiometricService

4. Animations:
   - Pulse animation for icon
   - Success animation
   - Failure shake

Run flutter analyze and fix errors.
```

---

## 🎭 PHASE 7: DECOY INTERFACE (Fake App)

### Step 7.1: Create Decoy Home Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/decoy/decoy_home_screen.dart:

The fake To-Do app interface:

1. AppBar:
   - "My Tasks" title
   - Generic blue color scheme (Material 3)
   - Settings icon (shows fake settings)

2. Body:
   - List of TodoItems
   - Tab bar: "Active" and "Completed"
   - Empty state with friendly illustration

3. FloatingActionButton:
   - "+" icon
   - Opens DecoyTodoScreen for new task

4. UI Style:
   - Bright, friendly colors (blues and whites)
   - Simple, boring design
   - Generic Material 3 components
   - NO hints of security features
   - NO way to access vault from here

5. Use DecoyProvider to manage todos

6. Pre-populate with realistic todos:
   - "Buy groceries"
   - "Call dentist"
   - "Finish project report"
   - etc.

Make it look completely innocent!
Run flutter analyze and fix errors.
```

### Step 7.2: Create Decoy Todo Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/decoy/decoy_todo_screen.dart:

Simple todo add/edit screen:

1. Form fields:
   - Title (required)
   - Description
   - Due date picker
   - Priority selector (Low/Medium/High)

2. Actions:
   - Save button
   - Cancel button

3. Validation:
   - Title must not be empty

4. Save to DecoyProvider

5. Generic Material 3 design

Run flutter analyze and fix errors.
```

---

## 🔒 PHASE 8: VAULT INTERFACE (Real App)

### Step 8.1: Create Vault Home Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/vault/vault_home_screen.dart:

Main vault interface with bottom navigation:

1. BottomNavigationBar with 4 tabs:
   - Secure Notes
   - Password Manager
   - Stego Lab
   - Settings

2. AppBar:
   - "CipherKeep Vault" title
   - Lock icon button (logout)
   - Search icon
   - Theme matches selected theme

3. Each tab shows corresponding screen

4. Cyberpunk aesthetic (or current theme):
   - Dark background
   - Neon accents
   - Glassmorphism cards
   - Smooth tab transitions

5. Edge-to-edge design with proper insets

6. Auto-lock timer:
   - Track last activity
   - Lock after 5 minutes (or user setting)
   - Show subtle timer in app bar

Run flutter analyze and fix errors.
```

### Step 8.2: Create Secure Notes Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/vault/secure_notes_screen.dart:

Note management interface:

1. Display:
   - Grid/List toggle
   - Search bar at top
   - Tag filter chips
   - List of note cards using AnimatedCard widget
   - FloatingActionButton for new note

2. Note Card shows:
   - Title
   - First line of content (decrypted preview)
   - Date modified
   - Tags
   - Favorite star
   - Custom color accent

3. Actions:
   - Tap to view/edit
   - Long press menu: Edit, Delete, Favorite, Share
   - Swipe to delete

4. New/Edit Note Dialog:
   - Title field
   - Content field (large, multi-line)
   - Tag selector (create new or select existing)
   - Color picker
   - Save button

5. Use VaultProvider:
   - Encrypt content before saving
   - Decrypt for display
   - Real-time search

6. Animations:
   - Staggered list entrance
   - Card flip animation for edit
   - Delete animation

Run flutter analyze and fix errors.
```

### Step 8.3: Create Password Manager Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/vault/password_manager_screen.dart:

Password vault interface:

1. Display:
   - Search bar
   - List of password entries using AnimatedCard
   - FloatingActionButton for new entry
   - Filter by tags

2. Password Entry Card shows:
   - App icon (use first letter as avatar if no icon)
   - Title
   - Username
   - "••••••••" (hidden password)
   - URL
   - Copy username/password buttons

3. Actions:
   - Tap to view details
   - Long press menu
   - Quick copy buttons

4. Add/Edit Dialog:
   - Title field
   - URL field (with validation)
   - Username field with copy button
   - SecureTextField for password with:
     * Show/hide toggle
     * Generate password button
     * PasswordStrengthIndicator
   - Notes field (encrypted)
   - Tags

5. Password Generator:
   - Length slider (8-32)
   - Checkboxes: Uppercase, Lowercase, Numbers, Symbols
   - Generate button
   - Copy button

6. Use VaultProvider:
   - Encrypt username and password
   - Decrypt for display
   - Auto-copy with 30s clipboard clear

7. Animations:
   - Reveal animation for password
   - Success animation on copy

Run flutter analyze and fix errors.
```

### Step 8.4: Create Stego Lab Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/vault/stego_lab_screen.dart:

Steganography interface:

1. Two tabs: "Encode" and "Decode"

2. Encode Tab:
   - Image picker button
   - Selected image preview
   - Text input for secret message
   - Character count and capacity indicator
   - "Encode & Save" button
   - Preview of encoding process

3. Decode Tab:
   - Image picker button
   - Selected image preview
   - "Decode Message" button
   - Decoded message display (with copy button)
   - History of encoded images

4. Encoded Images List:
   - Thumbnail
   - Title
   - Encoded date
   - Message length
   - Actions: View, Decode, Share, Delete

5. Logic:
   - Use StegoEngine for encoding/decoding
   - Save encoded images to gallery
   - Store metadata in Hive
   - Show capacity warning if message too large

6. Visual feedback:
   - Progress indicator during encoding
   - Success animation
   - Before/after comparison

7. Animations:
   - Image fade in
   - Progress bar
   - Reveal animation for decoded text

Run flutter analyze and fix errors.
```

### Step 8.5: Create Vault Settings Screen

**Prompt for Copilot:**
```
Create lib/presentation/screens/vault/vault_settings_screen.dart:

Comprehensive settings interface:

1. Sections:

   SECURITY:
   - Change Real PIN
   - Change Ghost PIN
   - Enable/Disable Biometric
   - Auto-Lock timeout slider
   - Failed attempts before wipe (with warning)
   - Enable Panic Wipe toggle

   APPEARANCE:
   - Theme selector (ThemeSelector widget)
   - Enable haptic feedback
   - Edge-to-edge display toggle

   DATA:
   - Export encrypted backup
   - Import backup
   - Clear vault data (with confirmation)
   - Storage usage indicator

   ABOUT:
   - App version
   - Developer: SalamUniverse
   - Support email
   - Privacy policy
   - Open source licenses

   DANGER ZONE:
   - Reset app (delete everything)
   - Logout

2. Each setting:
   - Clear description
   - Current state
   - Change dialog/action
   - Confirmation for dangerous actions

3. Use SettingsProvider

4. Visual hierarchy:
   - Section headers
   - Dividers
   - Cards for settings groups

5. Confirmation dialogs for:
   - Changing PINs
   - Enabling panic wipe
   - Clearing data
   - Resetting app

Run flutter analyze and fix errors.
```

---

## 🎯 PHASE 9: NAVIGATION & ROUTING

### Step 9.1: Create Router Configuration

**Prompt for Copilot:**
```
Create lib/config/routes.dart using GoRouter:

1. Define all routes:
   - / -> SplashScreen
   - /onboarding -> OnboardingScreen
   - /setup -> SetupScreen
   - /pin -> PinScreen
   - /biometric -> BiometricScreen
   - /vault -> VaultHomeScreen (with nested navigation for tabs)
   - /decoy -> DecoyHomeScreen
   - /error -> ErrorScreen

2. Guards:
   - Check authentication state
   - Redirect unauthenticated users to /pin
   - Handle deep links

3. Transitions:
   - Custom page transitions for each route
   - Slide, fade, scale animations
   - Different transitions for vault vs decoy

4. Error handling:
   - 404 page
   - Error page with retry

Example structure:
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    // ... more routes
  ],
  redirect: (context, state) {
    // Check auth state and redirect
  },
);

Run flutter analyze and fix errors.
```

---

## 🔨 PHASE 10: MAIN APP SETUP

### Step 10.1: Create Main App

**Prompt for Copilot:**
```
Create/update lib/main.dart:

1. Initialize services:
   - WidgetsFlutterBinding.ensureInitialized()
   - await HiveService().init()
   - SystemChrome configurations for edge-to-edge

2. Main app widget:
   - Wrap in ProviderScope
   - Use ConsumerWidget
   - Watch theme provider
   - Apply current theme
   - Use GoRouter for navigation

3. System UI configurations:
   - Set preferred orientations (portrait only)
   - Configure edge-to-edge:
     SystemChrome.setEnabledSystemUIMode(
       SystemUiMode.edgeToEdge,
     );
   - Transparent status bar
   - Navigation bar handling

4. Error handling:
   - Global error handler
   - Crash reporting (without internet)

Example:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Edge-to-edge
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  
  await HiveService().init();
  
  runApp(ProviderScope(child: CipherKeepApp()));
}

Run flutter analyze and fix errors.
```

---

## 🧪 PHASE 11: TESTING & POLISH

### Step 11.1: Create Unit Tests

**Prompt for Copilot:**
```
Create comprehensive unit tests in test/unit/:

1. test_encryption_service.dart:
   - Test encryption/decryption
   - Test key generation
   - Test edge cases

2. test_stego_engine.dart:
   - Test message encoding
   - Test message decoding
   - Test capacity calculation

3. test_validators.dart:
   - Test PIN validation
   - Test password strength
   - Test form validators

4. Run tests:
   flutter test

Fix any failing tests.
```

### Step 11.2: Widget Tests

**Prompt for Copilot:**
```
Create widget tests in test/widget/:

1. test_custom_pin_pad.dart:
   - Test button presses
   - Test PIN entry
   - Test callbacks

2. test_password_strength_indicator.dart:
   - Test strength calculation
   - Test visual feedback

3. Run tests:
   flutter test

Fix any failing tests.
```

### Step 11.3: Integration Tests

**Prompt for Copilot:**
```
Create integration test in test/integration/app_test.dart:

1. Test complete user flow:
   - App launch
   - Onboarding
   - PIN setup
   - Vault access
   - Note creation
   - Password storage
   - Image encoding
   - Decoy mode

2. Run:
   flutter test integration_test/app_test.dart

Fix any issues.
```

---

## 🎨 PHASE 12: FINAL POLISH & OPTIMIZATION

### Step 12.1: Performance Optimization

**Prompt for Copilot:**
```
Optimize the app for performance:

1. Check and optimize:
   - Image loading (use cached_network_image principles for local images)
   - List scrolling (use const constructors)
   - State management (avoid unnecessary rebuilds)
   - Memory leaks (dispose controllers)

2. Add:
   - Image compression for encoded images
   - Lazy loading for lists
   - Debouncing for search

3. Profile the app:
   flutter run --profile
   
4. Check memory usage in DevTools

Run flutter analyze and fix warnings.
```

### Step 12.2: Add Animations & Transitions

**Prompt for Copilot:**
```
Enhance all screens with beautiful animations:

1. Add to SplashScreen:
   - Logo scale + fade in
   - Shimmer effect
   - Smooth transition out

2. Add to all list screens:
   - Staggered entrance animations
   - Item addition animation
   - Item deletion animation
   - Pull-to-refresh

3. Add to form screens:
   - Field focus animations
   - Validation feedback animations
   - Success/error animations

4. Add micro-interactions:
   - Button press feedback
   - Toggle animations
   - Tab switching animations

5. Use flutter_animate package for:
   - Slide animations
   - Fade animations
   - Scale animations
   - Shimmer effects

Run flutter analyze and test animations.
```

### Step 12.3: Accessibility Improvements

**Prompt for Copilot:**
```
Make the app accessible:

1. Add semantic labels to all widgets:
   - Buttons
   - Images
   - Interactive elements

2. Ensure proper contrast ratios:
   - Text on backgrounds
   - Icons on surfaces

3. Add:
   - Screen reader support
   - Larger touch targets (48x48dp minimum)
   - Focus indicators
   - Alternative text for images

4. Test with TalkBack/VoiceOver

5. Add accessibility settings:
   - Font size multiplier
   - Reduced motion option
   - High contrast mode

Run flutter analyze and test accessibility.
```

### Step 12.4: Add Lottie Animations

**Prompt for Copilot:**
```
Add Lottie animations for enhanced visual appeal:

1. Download free Lottie animations from LottieFiles:
   - Security/lock animation for splash
   - Fingerprint animation for biometric
   - Success animation
   - Error animation
   - Empty state animations

2. Add to assets/animations/ folder

3. Integrate in:
   - SplashScreen
   - BiometricButton
   - Empty states (no notes, no passwords)
   - Success dialogs
   - Error screens

4. Use lottie package:
   Lottie.asset(
     'assets/animations/security.json',
     width: 200,
     height: 200,
   )

Run flutter analyze and test animations.
```

---

## 📦 PHASE 13: BUILD & RELEASE PREPARATION

### Step 13.1: Update App Icons & Splash

**Prompt for Copilot:**
```
Create app icon and splash screen:

1. Design requirements:
   - Icon: 1024x1024 PNG
   - Use a lock/shield symbol
   - Color matches Cyberpunk theme (neon green/black)
   - "CK" monogram option

2. Use flutter_launcher_icons package:
   - Add to dev_dependencies
   - Configure in pubspec.yaml:
     flutter_icons:
       android: true
       ios: false
       image_path: "assets/icons/app_icon.png"
       adaptive_icon_background: "#0A0E27"
       adaptive_icon_foreground: "assets/icons/app_icon_foreground.png"

3. Run:
   flutter pub run flutter_launcher_icons

4. Native splash screen:
   - Use flutter_native_splash package
   - Configure with CipherKeep branding

Run flutter clean && flutter pub get
```

### Step 13.2: Prepare Release Build

**Prompt for Copilot:**
```
Configure for release build:

1. Update android/app/build.gradle:
   - Set version code and name
   - Configure signing (keystore)
   - Enable ProGuard/R8:
     buildTypes {
       release {
         minifyEnabled true
         shrinkResources true
         proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
       }
     }

2. Create android/app/proguard-rules.pro:
   - Add rules for Hive
   - Add rules for encryption packages
   - Add rules for image package

3. Generate signing key:
   keytool -genkey -v -keystore ~/cipherkeep-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias cipherkeep

4. Create android/key.properties:
   storePassword=<password>
   keyPassword=<password>
   keyAlias=cipherkeep
   storeFile=<path-to-jks>

5. Update build.gradle to use signing config

Run flutter clean
```

### Step 13.3: Final Code Review

**Prompt for Copilot:**
```
Perform final code review and cleanup:

1. Run all checks:
   - flutter analyze
   - flutter test
   - dart format lib/
   - dart fix --apply

2. Remove:
   - All debug prints
   - Unused imports
   - Dead code
   - Test data

3. Verify:
   - All TODOs are resolved
   - No hardcoded strings (use constants)
   - Error handling is comprehensive
   - All widgets have proper keys

4. Check AndroidManifest.xml:
   - No INTERNET permission
   - All required permissions present
   - Correct package name
   - Version codes match

5. Update documentation:
   - README.md
   - CHANGELOG.md
   - Add code comments

Fix all issues found.
```

### Step 13.4: Build Release APK

**Prompt for Copilot:**
```
Build the release APK:

1. Clean build:
   flutter clean
   flutter pub get

2. Build release APK:
   flutter build apk --release --target-platform android-arm64,android-arm

3. Build App Bundle (for Play Store):
   flutter build appbundle --release

4. Verify outputs:
   - Check build/app/outputs/flutter-apk/app-release.apk
   - Check build/app/outputs/bundle/release/app-release.aab
   - Verify file sizes are reasonable

5. Test release build on device:
   flutter install --release

6. Test all features:
   - PIN authentication
   - Both vault and decoy modes
   - All vault features
   - Biometric (if available)
   - Theme switching
   - Panic wipe (be careful!)

Document any issues found.
```

---

## 📝 PHASE 14: PLAY STORE SUBMISSION

### Step 14.1: Create Store Listing Assets

**Prompt for Copilot:**
```
Prepare Play Store listing:

1. Screenshots (required):
   - Take 6-8 screenshots (phone)
   - Resolution: 1080x1920 or higher
   - Show:
     * Splash screen
     * PIN entry
     * Vault home
     * Secure notes
     * Password manager
     * Stego lab
     * Settings
   - Add device frames and descriptions

2. Feature Graphic:
   - 1024x500 pixels
   - Showcase "CipherKeep" branding
   - Highlight key features

3. App Icon (already done in Phase 13)

4. Video (optional but recommended):
   - 30-60 seconds
   - Demonstrate key features
   - Show vault/decoy concept

5. Organize in a store_assets/ folder
```

### Step 14.2: Write Store Description

**Prompt for Copilot:**
```
Create comprehensive Play Store description:

SHORT DESCRIPTION (80 chars max):
"Military-grade offline vault with decoy mode & steganography | by SalamUniverse"

FULL DESCRIPTION:
🔒 CipherKeep: The Invisible Vault

Your privacy deserves military-grade protection. CipherKeep is a 100% offline security vault that goes beyond simple encryption. Built by SalamUniverse, it's the ultimate privacy tool for storing your most sensitive data.

✨ UNIQUE FEATURES

🎭 Ghost PIN Protection
• Create two PINs: Real & Ghost
• Ghost PIN opens a convincing decoy app
• Real PIN accesses your secure vault
• Zero visual difference - undetectable

🖼️ Steganography Lab
• Hide messages inside images
• LSB (Least Significant Bit) encoding
• Share secrets in plain sight
• Decode hidden messages

🔐 Military-Grade Security
• AES-256-GCM encryption
• PBKDF2 key derivation
• Biometric authentication
• Auto-lock protection

🎨 Beautiful Themes
• Cyberpunk (neon green/black)
• Ocean (deep blue/cyan)
• Forest (emerald green)
• Sunset (orange/pink)
• Minimal (clean monochrome)

💾 VAULT FEATURES

📝 Secure Notes
• Encrypted text storage
• Tag organization
• Color coding
• Favorites
• Search & filter

🔑 Password Manager
• Encrypted credentials
• Strong password generator
• Password strength indicator
• Quick copy with auto-clear
• Website organization

🚨 PANIC FEATURES

⚡ Panic Wipe
• Auto-wipe after failed attempts
• Configurable threshold
• Vault data only (decoy intact)

🔒 PRIVACY FIRST

✅ 100% Offline - No internet permission
✅ Zero Data Collection
✅ No Analytics
✅ No Ads
✅ Open Source Security
✅ Local Storage Only

🎯 PERFECT FOR

• Privacy-conscious users
• Journalists & activists
• Security professionals
• Anyone who values digital privacy

💡 HOW IT WORKS

1. Set up Real PIN (vault access)
2. Set up Ghost PIN (decoy access)
3. Store sensitive data in vault
4. If compromised, use Ghost PIN
5. Show convincing decoy to-do app

🛡️ SECURITY CERTIFICATIONS

• Google Play Policy Compliant
• No Dangerous Permissions
• 16KB Memory Page Size Compatible
• Edge-to-Edge Modern UI

📱 REQUIREMENTS

• Android 8.0 or higher
• 50MB free storage
• Optional: Biometric sensor

🏢 ABOUT SALAMUNIVERSE

SalamUniverse builds privacy-first applications that put users in control of their digital lives. No tracking, no ads, just pure functionality.

🔗 SUPPORT & CONTACT

Email: support@salamuniverse.com
Privacy Policy: [URL]

⚠️ IMPORTANT NOTE

This app is designed for legitimate privacy protection. Use responsibly and legally. The developer is not responsible for misuse.

🌟 YOUR PRIVACY MATTERS

Download CipherKeep today and take control of your digital security. Your secrets stay yours.

---

Keywords: privacy, security, encryption, vault, password manager, steganography, offline, decoy, ghost mode, AES-256

CATEGORY: Tools / Productivity
CONTENT RATING: Everyone
```

### Step 14.3: Privacy Policy

**Prompt for Copilot:**
```
Create privacy policy document (host on GitHub Pages or similar):

PRIVACY POLICY FOR CIPHERKEEP

Last Updated: [DATE]

1. INTRODUCTION
CipherKeep ("we," "our," "the App") is developed by SalamUniverse. We are committed to protecting your privacy.

2. DATA COLLECTION
CipherKeep collects ZERO data. Period.

The app:
• Does not access the internet
• Does not collect user data
• Does not track usage
• Does not contain analytics
• Does not share data with third parties
• Does not store data on remote servers

3. LOCAL STORAGE
All data is stored locally on your device:
• Encrypted notes
• Encrypted passwords
• Encoded images
• User preferences

You have complete control. Uninstalling the app removes all data.

4. PERMISSIONS
The app requests:
• Storage: To save and load images for steganography
• Biometric: Optional, for fingerprint/face authentication

5. SECURITY
• AES-256-GCM encryption
• PBKDF2 key derivation
• Local-only data storage
• No network communication

6. THIRD-PARTY SERVICES
None. The app is 100% offline.

7. CHANGES TO POLICY
Updates will be posted here and in the app.

8. CONTACT
support@salamuniverse.com

By using CipherKeep, you agree to this privacy policy.

---

Save as privacy_policy.html and host it.
Update Play Store listing with URL.
```

### Step 14.4: Final Submission Checklist

**Prompt for Copilot:**
```
Pre-submission checklist:

TECHNICAL:
☐ Compiled with latest Flutter stable
☐ Targets Android API 35
☐ 16KB page size compatible
☐ Edge-to-edge UI implemented
☐ No INTERNET permission in manifest
☐ All required permissions declared
☐ App signed with release key
☐ ProGuard enabled
☐ Tested on multiple devices
☐ Tested on Android 8.0 minimum
☐ No crashes or ANRs
☐ Proper memory management

STORE LISTING:
☐ App icon (512x512 and adaptive)
☐ Feature graphic (1024x500)
☐ 6+ screenshots with descriptions
☐ Short description (under 80 chars)
☐ Full description (compelling)
☐ Privacy policy URL
☐ Content rating completed
☐ Correct category selected
☐ Pricing set (Free)

COMPLIANCE:
☐ No policy violations
☐ Appropriate content rating
☐ No misleading claims
☐ Privacy policy accurate
☐ Permissions justified
☐ No malicious behavior
☐ No copyright violations

TESTING:
☐ Vault mode works perfectly
☐ Decoy mode convincing
☐ Steganography functional
☐ Encryption verified
☐ Panic wipe tested (carefully!)
☐ All themes work
☐ Biometric authentication works
☐ Settings persist
☐ No data leaks

LEGAL:
☐ Terms of service (if needed)
☐ Open source licenses included
☐ Copyright notice for SalamUniverse
☐ Disclaimer added

Once all checked:
1. Upload AAB to Play Console
2. Complete store listing
3. Submit for review
4. Monitor for feedback
```

---

## 🎉 PHASE 15: POST-LAUNCH & MAINTENANCE

### Step 15.1: Monitoring & Updates

**Prompt for Copilot:**
```
Set up post-launch processes:

1. Monitor Play Console:
   - Crash reports
   - ANR reports
   - User reviews
   - Download stats

2. Version planning:
   - Bug fix releases (1.0.x)
   - Feature releases (1.x.0)
   - Major updates (x.0.0)

3. Feedback collection:
   - Read reviews
   - Note feature requests
   - Track bugs

4. Update strategy:
   - Monthly minor updates
   - Quarterly feature updates
   - Security patches as needed

5. Communication:
   - Respond to reviews
   - Update changelog
   - Announce features
```

### Step 15.2: Future Features Roadmap

**Prompt for Copilot:**
```
Plan future enhancements:

VERSION 1.1:
• Cloud backup (encrypted, optional)
• Multi-language support
• More themes
• Widget for quick vault access

VERSION 1.2:
• File vault (PDFs, documents)
• Secure photo gallery
• Voice notes with encryption
• Backup/restore improvements

VERSION 1.3:
• Secure chat (local, no internet)
• Advanced steganography (audio, video)
• Duress password (wipes data automatically)
• Decoy data seeding

VERSION 2.0:
• Desktop companion app
• Hardware key support (YubiKey)
• Advanced cryptographic features
• Enhanced panic mode

Prioritize based on user feedback.
```

---

## 📚 APPENDIX: TROUBLESHOOTING GUIDE

### Common Issues & Solutions

**Issue: Build fails with 16KB page size error**
```
Solution:
1. Update NDK: ndkVersion "27.0.12077973"
2. Add ABI splits in build.gradle
3. Use arm64-v8a for testing
4. Ensure targetSdk = 35
```

**Issue: Edge-to-edge not working**
```
Solution:
1. Check SystemChrome.setEnabledSystemUIMode()
2. Verify transparent status bar
3. Use SafeArea widgets
4. Check AndroidManifest.xml windowSoftInputMode
```

**Issue: Hive encryption not working**
```
Solution:
1. Verify encryption key generation
2. Check if box is opened with encryption
3. Ensure key is stored securely
4. Test encryption service independently
```

**Issue: Steganography producing corrupted images**
```
Solution:
1. Check image encoding format (PNG only)
2. Verify message length < image capacity
3. Test with smaller images
4. Check LSB manipulation logic
```

**Issue: Biometric authentication fails**
```
Solution:
1. Check device support
2. Verify USE_BIOMETRIC permission
3. Test on physical device (not emulator)
4. Check local_auth package version
```

**Issue: App getting rejected by Play Store**
```
Solution:
1. Review rejection reason carefully
2. Common issues:
   - Misleading claims in description
   - Missing privacy policy
   - Permissions not justified
   - Content rating incorrect
3. Fix and resubmit with changes noted
```

---

## 🎓 BEST PRACTICES REMINDER

1. **Security First**: Never log sensitive data, even in debug mode
2. **User Experience**: Test on low-end devices for performance
3. **Code Quality**: Maintain consistent formatting and naming
4. **Documentation**: Comment complex logic
5. **Testing**: Write tests for critical features
6. **Updates**: Keep dependencies up to date
7. **Feedback**: Listen to users and iterate

---

## ✅ FINAL VALIDATION

Before considering the project complete, ensure:

1. ✅ All 15 phases completed
2. ✅ No compilation errors
3. ✅ All tests passing
4. ✅ Performance optimized
5. ✅ UI polished
6. ✅ Play Store ready
7. ✅ Documentation complete

---

## 🚀 DEPLOYMENT COMMAND

Final build command:
```bash
flutter clean && \
flutter pub get && \
flutter analyze && \
flutter test && \
flutter build appbundle --release --target-platform android-arm64 && \
echo "✅ CipherKeep by SalamUniverse is ready for Play Store!"
```

---

**Good luck with your app launch! 🎉**

**Developed with ❤️ by SalamUniverse**

---

## 📞 SUPPORT

For development questions or issues:
- Email: dev@salamuniverse.com
- GitHub: Create an issue in the repository

---

*End of Development Guide*