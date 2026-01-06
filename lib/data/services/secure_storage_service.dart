import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cypherkeep/core/constants/storage_keys.dart';

/// Service for storing sensitive data securely using flutter_secure_storage
class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  late final FlutterSecureStorage _storage;

  /// Initialize the secure storage with platform-specific options
  void initialize() {
    const androidOptions = AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    );

    const iosOptions = IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    );

    _storage = const FlutterSecureStorage(
      aOptions: androidOptions,
      iOptions: iosOptions,
    );
  }

  /// Saves the real PIN (hashed)
  Future<void> saveRealPin(String pinHash) async {
    await _storage.write(key: StorageKeys.realPin, value: pinHash);
  }

  /// Gets the real PIN hash
  Future<String?> getRealPin() async {
    return await _storage.read(key: StorageKeys.realPin);
  }

  /// Saves the ghost PIN (hashed)
  Future<void> saveGhostPin(String pinHash) async {
    await _storage.write(key: StorageKeys.ghostPin, value: pinHash);
  }

  /// Gets the ghost PIN hash
  Future<String?> getGhostPin() async {
    return await _storage.read(key: StorageKeys.ghostPin);
  }

  /// Saves biometric enabled setting
  Future<void> saveBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: StorageKeys.biometricEnabled,
      value: enabled.toString(),
    );
  }

  /// Gets biometric enabled setting
  Future<bool> getBiometricEnabled() async {
    final value = await _storage.read(key: StorageKeys.biometricEnabled);
    return value == 'true';
  }

  /// Saves the encryption key
  Future<void> saveEncryptionKey(String key) async {
    await _storage.write(key: StorageKeys.encryptionKey, value: key);
  }

  /// Gets the encryption key
  Future<String?> getEncryptionKey() async {
    return await _storage.read(key: StorageKeys.encryptionKey);
  }

  /// Checks if this is the first launch
  Future<bool> isFirstLaunch() async {
    final value = await _storage.read(key: StorageKeys.firstLaunch);
    return value == null;
  }

  /// Marks the app as no longer first launch
  Future<void> setNotFirstLaunch() async {
    await _storage.write(key: StorageKeys.firstLaunch, value: 'false');
  }

  /// Deletes all secure storage data
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Deletes a specific key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Saves a custom key-value pair
  Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a custom key
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }
}
