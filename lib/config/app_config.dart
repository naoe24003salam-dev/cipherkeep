/// CipherKeep Application Configuration
class AppConfig {
  // App Information
  static const String appName = 'CipherKeep';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;
  static const String developer = 'SalamUniverse';
  static const String supportEmail = 'support@salamuniverse.com';
  static const String tagline = 'The Invisible Vault';

  // Security Settings
  static const int maxFailedAttempts = 5;
  static const int autoLockTimeoutMinutes = 5;
  static const int pinLength = 6;
  static const String encryptionAlgorithm = 'AES-256-GCM';
  static const String keyDerivationFunction = 'PBKDF2';
  static const int pbkdf2Iterations = 10000;

  // Password Requirements
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const bool requireUppercase = true;
  static const bool requireLowercase = true;
  static const bool requireNumbers = true;
  static const bool requireSpecialChars = true;

  // File Settings
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png'];
  static const int maxImageSizeMB = 10;
  static const int maxNoteSizeKB = 100;
  static const int maxEncodedMessageSizeKB = 50;

  // UI Settings
  static const int fastAnimationMs = 200;
  static const int normalAnimationMs = 300;
  static const int slowAnimationMs = 500;
  static const Duration clipboardClearDuration = Duration(seconds: 30);

  // Feature Flags
  static const FeatureFlags features = FeatureFlags();
}

/// Feature flags for enabling/disabling app features
class FeatureFlags {
  final bool biometricEnabled;
  final bool panicButtonEnabled;
  final bool stegoEnabled;
  final bool themeCustomization;
  final bool hapticFeedback;
  final bool autoBackup;

  const FeatureFlags({
    this.biometricEnabled = true,
    this.panicButtonEnabled = true,
    this.stegoEnabled = true,
    this.themeCustomization = true,
    this.hapticFeedback = true,
    this.autoBackup = false, // Disabled for v1.0 (100% offline)
  });
}
