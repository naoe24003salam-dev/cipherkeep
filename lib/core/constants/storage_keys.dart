/// Storage keys for Hive boxes and secure storage
class StorageKeys {
  // Hive Box Names
  static const String vaultNotesBox = 'vault_notes_box';
  static const String vaultImagesBox = 'vault_images_box';
  static const String vaultPasswordsBox = 'vault_passwords_box';
  static const String decoyTodoBox = 'decoy_todo_box';
  static const String settingsBox = 'settings_box';

  // Secure Storage Keys
  static const String realPin = 'real_pin';
  static const String ghostPin = 'ghost_pin';
  static const String encryptionKey = 'encryption_key';
  static const String biometricEnabled = 'biometric_enabled';
  static const String firstLaunch = 'first_launch';

  // Settings Keys
  static const String selectedTheme = 'selected_theme';
  static const String autoLockEnabled = 'auto_lock_enabled';
  static const String autoLockMinutes = 'auto_lock_minutes';
  static const String panicWipeEnabled = 'panic_wipe_enabled';
  static const String maxFailedAttempts = 'max_failed_attempts';
  static const String hapticFeedbackEnabled = 'haptic_feedback_enabled';
  static const String language = 'language';

  // Temporary Keys
  static const String lastActiveTime = 'last_active_time';
  static const String failedAttemptCount = 'failed_attempt_count';
  static const String lastFailedAttemptTime = 'last_failed_attempt_time';
}

/// Type IDs for Hive adapters
class HiveTypeIds {
  static const int secureNote = 0;
  static const int encodedImage = 1;
  static const int passwordEntry = 2;
  static const int todoItem = 3;
  static const int userSettings = 4;
}
