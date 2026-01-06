import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cypherkeep/data/services/secure_storage_service.dart';

/// Service for handling biometric authentication
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Checks if the device has biometric hardware
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  /// Gets the list of available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Authenticates using biometrics
  Future<bool> authenticate(
      {String reason = 'Authenticate to access your vault'}) async {
    try {
      // Check if biometric is enabled in settings
      final isEnabled = await _secureStorage.getBiometricEnabled();
      if (!isEnabled) {
        return false;
      }

      // Check if device supports biometrics
      final canAuthenticate = await isBiometricAvailable();
      if (!canAuthenticate) {
        return false;
      }

      // Perform authentication with proper configuration for all sensor types
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow both biometric and device credentials
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );
    } on PlatformException catch (e) {
      // Handle specific error codes
      if (e.code == 'NotAvailable') {
        // Biometrics not available on device
        return false;
      } else if (e.code == 'NotEnrolled') {
        // No biometrics enrolled
        return false;
      } else if (e.code == 'LockedOut') {
        // Too many failed attempts
        return false;
      } else if (e.code == 'PermanentlyLockedOut') {
        // Too many failed attempts, permanently locked
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Stops any ongoing authentication
  Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      // Ignore errors
    }
  }

  /// Gets a user-friendly name for the biometric type
  String getBiometricTypeName(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (types.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (types.contains(BiometricType.iris)) {
      return 'Iris';
    } else if (types.contains(BiometricType.strong)) {
      return 'Biometric';
    } else if (types.contains(BiometricType.weak)) {
      return 'Biometric';
    }
    return 'Biometric';
  }

  /// Checks if biometric authentication is currently enabled
  Future<bool> isEnabled() async {
    return await _secureStorage.getBiometricEnabled();
  }

  /// Enables biometric authentication
  Future<void> enable() async {
    await _secureStorage.saveBiometricEnabled(true);
  }

  /// Disables biometric authentication
  Future<void> disable() async {
    await _secureStorage.saveBiometricEnabled(false);
  }
}
