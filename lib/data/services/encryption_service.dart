import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart' as pc;

/// Exception for encryption-related errors
class EncryptionException implements Exception {
  final String message;
  EncryptionException(this.message);

  @override
  String toString() => 'EncryptionException: $message';
}

/// Service for AES-256-GCM encryption and decryption using PointyCastle
class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  /// PBKDF2 iterations for key derivation
  static const int _pbkdf2Iterations = 10000;

  /// Derives a key from a PIN using PBKDF2
  Uint8List _deriveKey(String pin, Uint8List salt) {
    final derivator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64));
    final params = pc.Pbkdf2Parameters(salt, _pbkdf2Iterations, 32);
    derivator.init(params);

    return derivator.process(Uint8List.fromList(utf8.encode(pin)));
  }

  /// Encrypts plaintext using AES-256-GCM
  Future<String> encrypt(String plaintext, String pin) async {
    try {
      // Generate random salt for key derivation
      final salt = _generateSecureRandom(16);

      // Derive key from PIN
      final key = _deriveKey(pin, salt);

      // Generate random nonce (IV) for GCM
      final nonce = _generateSecureRandom(12);

      // Create GCM cipher
      final cipher = pc.GCMBlockCipher(pc.AESEngine());
      final params = pc.AEADParameters(
        pc.KeyParameter(key),
        128, // tag length in bits
        nonce,
        Uint8List(0), // no additional authenticated data
      );

      cipher.init(true, params); // true = encrypt

      // Encrypt the plaintext
      final plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));
      final ciphertext = cipher.process(plaintextBytes);

      // Combine salt + nonce + ciphertext for storage
      final combined = Uint8List.fromList([
        ...salt,
        ...nonce,
        ...ciphertext,
      ]);

      return base64.encode(combined);
    } catch (e) {
      throw EncryptionException('Encryption failed: $e');
    }
  }

  /// Decrypts ciphertext using AES-256-GCM
  Future<String> decrypt(String ciphertext, String pin) async {
    try {
      // Decode the combined data
      final combined = base64.decode(ciphertext);

      // Extract salt, nonce, and encrypted data
      final salt = Uint8List.fromList(combined.sublist(0, 16));
      final nonce = Uint8List.fromList(combined.sublist(16, 28));
      final encryptedBytes = Uint8List.fromList(combined.sublist(28));

      // Derive key from PIN
      final key = _deriveKey(pin, salt);

      // Create GCM cipher
      final cipher = pc.GCMBlockCipher(pc.AESEngine());
      final params = pc.AEADParameters(
        pc.KeyParameter(key),
        128, // tag length in bits
        nonce,
        Uint8List(0),
      );

      cipher.init(false, params); // false = decrypt

      // Decrypt
      final decrypted = cipher.process(encryptedBytes);

      return utf8.decode(decrypted);
    } catch (e) {
      throw EncryptionException('Decryption failed: $e');
    }
  }

  /// Generates a secure random key for encryption
  String generateSecureKey() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(values);
  }

  /// Generates secure random bytes
  Uint8List _generateSecureRandom(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (i) => random.nextInt(256)),
    );
  }

  /// Verifies data integrity using SHA-256 hash
  bool verifyIntegrity(String data, String expectedHash) {
    try {
      final bytes = utf8.encode(data);
      final digest = sha256.convert(bytes);
      return digest.toString() == expectedHash;
    } catch (e) {
      return false;
    }
  }

  /// Creates a hash of the data for integrity checking
  String createHash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Hashes a PIN for storage comparison (using SHA-256)
  String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
