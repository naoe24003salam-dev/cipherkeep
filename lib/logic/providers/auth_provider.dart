import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cypherkeep/logic/state/auth_state.dart';
import 'package:cypherkeep/data/services/secure_storage_service.dart';
import 'package:cypherkeep/data/services/encryption_service.dart';
import 'package:cypherkeep/data/services/biometric_service.dart';
import 'package:cypherkeep/data/services/hive_service.dart';
import 'package:cypherkeep/config/app_config.dart';

/// Provider for authentication state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Notifier for managing authentication
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthUnauthenticated());

  final _secureStorage = SecureStorageService();
  final _encryption = EncryptionService();
  final _biometric = BiometricService();
  final _hiveService = HiveService();

  int _failedAttempts = 0;

  /// Sets up the initial PINs during first launch
  Future<void> setupPins(String realPin, String ghostPin) async {
    try {
      if (realPin == ghostPin) {
        throw Exception('PINs must be different');
      }

      if (realPin.length != AppConfig.pinLength ||
          ghostPin.length != AppConfig.pinLength) {
        throw Exception('PINs must be ${AppConfig.pinLength} digits');
      }

      // Hash the PINs
      final realPinHash = _encryption.hashPin(realPin);
      final ghostPinHash = _encryption.hashPin(ghostPin);

      // Save to secure storage
      await _secureStorage.saveRealPin(realPinHash);
      await _secureStorage.saveGhostPin(ghostPinHash);
      await _secureStorage.setNotFirstLaunch();

      // Generate and save encryption key
      final encryptionKey = _encryption.generateSecureKey();
      await _secureStorage.saveEncryptionKey(encryptionKey);
    } catch (e) {
      throw Exception('Failed to setup PINs: $e');
    }
  }

  /// Authenticates with PIN
  Future<AuthResult> authenticateWithPin(String pin) async {
    try {
      state = const AuthLoading();

      // Hash the entered PIN
      final enteredPinHash = _encryption.hashPin(pin);

      // Get stored PIN hashes
      final realPinHash = await _secureStorage.getRealPin();
      final ghostPinHash = await _secureStorage.getGhostPin();

      if (realPinHash == null || ghostPinHash == null) {
        state = const AuthUnauthenticated();
        return const AuthResult.failure('No PINs configured');
      }

      // Check if it matches real PIN
      if (enteredPinHash == realPinHash) {
        _resetFailedAttempts();
        state = const AuthAuthenticated();
        return const AuthResult.success(AuthAuthenticated());
      }

      // Check if it matches ghost PIN
      if (enteredPinHash == ghostPinHash) {
        _resetFailedAttempts();
        state = const AuthDecoy();
        return const AuthResult.success(AuthDecoy());
      }

      // Wrong PIN
      await _incrementFailedAttempts();
      state = const AuthUnauthenticated();
      return AuthResult.failure(
        'Wrong PIN. ${AppConfig.maxFailedAttempts - _failedAttempts} attempts remaining.',
      );
    } catch (e) {
      state = const AuthUnauthenticated();
      return AuthResult.failure('Authentication failed: $e');
    }
  }

  /// Authenticates with biometrics
  Future<AuthResult> authenticateWithBiometric() async {
    try {
      state = const AuthLoading();

      final isEnabled = await _biometric.isEnabled();
      if (!isEnabled) {
        state = const AuthUnauthenticated();
        return const AuthResult.failure('Biometric not enabled');
      }

      final authenticated = await _biometric.authenticate();
      if (!authenticated) {
        state = const AuthUnauthenticated();
        return const AuthResult.failure('Biometric authentication failed');
      }

      // Biometric successful - log in to real vault (not decoy)
      _resetFailedAttempts();
      state = const AuthAuthenticated();
      return const AuthResult.success(AuthAuthenticated());
    } catch (e) {
      state = const AuthUnauthenticated();
      return AuthResult.failure('Biometric authentication failed: $e');
    }
  }

  /// Increments failed attempts counter
  Future<void> _incrementFailedAttempts() async {
    _failedAttempts++;

    // Check if max attempts reached
    if (_failedAttempts >= AppConfig.maxFailedAttempts) {
      // Trigger panic wipe if enabled
      const panicWipeEnabled = true; // TODO: Get from settings
      if (panicWipeEnabled) {
        await triggerPanicWipe();
      }
    }
  }

  /// Resets failed attempts counter
  void _resetFailedAttempts() {
    _failedAttempts = 0;
  }

  /// Triggers panic wipe (deletes vault data only)
  Future<void> triggerPanicWipe() async {
    try {
      await _hiveService.deleteVaultData();
      _resetFailedAttempts();
      state = const AuthUnauthenticated();
    } catch (e) {
      throw Exception('Panic wipe failed: $e');
    }
  }

  /// Logs out the user
  Future<void> logout() async {
    state = const AuthUnauthenticated();
    _resetFailedAttempts();
  }

  /// Changes the Real PIN
  Future<void> changeRealPin(String newPin) async {
    try {
      if (newPin.length != AppConfig.pinLength) {
        throw Exception('PIN must be ${AppConfig.pinLength} digits');
      }

      final newPinHash = _encryption.hashPin(newPin);
      await _secureStorage.saveRealPin(newPinHash);
    } catch (e) {
      throw Exception('Failed to change Real PIN: $e');
    }
  }

  /// Changes the Ghost PIN
  Future<void> changeGhostPin(String newPin) async {
    try {
      if (newPin.length != AppConfig.pinLength) {
        throw Exception('PIN must be ${AppConfig.pinLength} digits');
      }

      final newPinHash = _encryption.hashPin(newPin);
      await _secureStorage.saveGhostPin(newPinHash);
    } catch (e) {
      throw Exception('Failed to change Ghost PIN: $e');
    }
  }

  /// Checks if the app has existing setup
  Future<bool> hasExistingSetup() async {
    final isFirstLaunch = await _secureStorage.isFirstLaunch();
    return !isFirstLaunch;
  }

  /// Gets the failed attempts count
  int get failedAttemptsCount => _failedAttempts;

  /// Gets the remaining attempts
  int get remainingAttempts => AppConfig.maxFailedAttempts - _failedAttempts;
}
