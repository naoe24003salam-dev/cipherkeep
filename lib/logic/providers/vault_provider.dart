import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cypherkeep/data/models/secure_note.dart';
import 'package:cypherkeep/data/models/password_entry.dart';
import 'package:cypherkeep/data/models/encoded_image.dart';
import 'package:cypherkeep/data/services/hive_service.dart';
import 'package:cypherkeep/core/utils/stego_engine.dart';
import 'package:cypherkeep/core/constants/storage_keys.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';

/// Vault state model
class VaultState {
  final List<SecureNote> notes;
  final List<PasswordEntry> passwords;
  final List<EncodedImage> encodedImages;

  VaultState({
    required this.notes,
    required this.passwords,
    required this.encodedImages,
  });

  VaultState copyWith({
    List<SecureNote>? notes,
    List<PasswordEntry>? passwords,
    List<EncodedImage>? encodedImages,
  }) {
    return VaultState(
      notes: notes ?? this.notes,
      passwords: passwords ?? this.passwords,
      encodedImages: encodedImages ?? this.encodedImages,
    );
  }
}

/// Provider for vault data management
final vaultProvider = StateNotifierProvider<VaultNotifier, VaultState>((ref) {
  return VaultNotifier();
});

/// Notifier for managing vault data
class VaultNotifier extends StateNotifier<VaultState> {
  final _hiveService = HiveService();
  final _uuid = const Uuid();

  VaultNotifier()
      : super(VaultState(notes: [], passwords: [], encodedImages: [])) {
    _loadData();
  }

  void _loadData() {
    final notes = _hiveService
        .getBox<SecureNote>(StorageKeys.vaultNotesBox)
        .values
        .toList();
    final passwords = _hiveService
        .getBox<PasswordEntry>(StorageKeys.vaultPasswordsBox)
        .values
        .toList();
    final images = _hiveService
        .getBox<EncodedImage>(StorageKeys.vaultImagesBox)
        .values
        .toList();

    state = VaultState(
      notes: notes,
      passwords: passwords,
      encodedImages: images,
    );
  }

  // ============= Secure Notes =============

  Future<void> addNote(String title, String content) async {
    final note = SecureNote(
      id: _uuid.v4(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      tags: [],
    );

    final box = _hiveService.getBox<SecureNote>(StorageKeys.vaultNotesBox);
    await box.add(note);
    _loadData();
  }

  Future<void> updateNote(String id, String title, String content) async {
    final box = _hiveService.getBox<SecureNote>(StorageKeys.vaultNotesBox);
    final notes = box.values.toList();
    final index = notes.indexWhere((n) => n.id == id);

    if (index != -1) {
      final oldNote = notes[index];
      final updatedNote = SecureNote(
        id: oldNote.id,
        title: title,
        content: content,
        createdAt: oldNote.createdAt,
        lastModified: DateTime.now(),
        tags: oldNote.tags,
      );
      await box.putAt(index, updatedNote);
      _loadData();
    }
  }

  Future<void> deleteNote(String id) async {
    final box = _hiveService.getBox<SecureNote>(StorageKeys.vaultNotesBox);
    final index = box.values.toList().indexWhere((n) => n.id == id);
    if (index != -1) {
      await box.deleteAt(index);
      _loadData();
    }
  }

  // ============= Password Entries =============

  Future<void> addPassword(String site, String username, String password,
      {String? notes}) async {
    final entry = PasswordEntry(
      id: _uuid.v4(),
      title: site,
      site: site,
      username: username,
      password: password,
      notes: notes,
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
    );

    final box =
        _hiveService.getBox<PasswordEntry>(StorageKeys.vaultPasswordsBox);
    await box.add(entry);
    _loadData();
  }

  Future<void> updatePassword(
      String id, String site, String username, String password,
      {String? notes}) async {
    final box =
        _hiveService.getBox<PasswordEntry>(StorageKeys.vaultPasswordsBox);
    final passwords = box.values.toList();
    final index = passwords.indexWhere((p) => p.id == id);

    if (index != -1) {
      final oldEntry = passwords[index];
      final updatedEntry = PasswordEntry(
        id: oldEntry.id,
        title: site,
        site: site,
        username: username,
        password: password,
        notes: notes,
        createdAt: oldEntry.createdAt,
        lastModified: DateTime.now(),
      );
      await box.putAt(index, updatedEntry);
      _loadData();
    }
  }

  Future<void> deletePassword(String id) async {
    final box =
        _hiveService.getBox<PasswordEntry>(StorageKeys.vaultPasswordsBox);
    final index = box.values.toList().indexWhere((p) => p.id == id);
    if (index != -1) {
      await box.deleteAt(index);
      _loadData();
    }
  }

  // ============= Encoded Images =============

  Future<void> encodeImage(Uint8List imageBytes, String message) async {
    final encodedBytes = await StegoEngine.encodeMessage(imageBytes, message);

    final encodedImage = EncodedImage(
      id: _uuid.v4(),
      imageData: encodedBytes,
      messageLength: message.length,
      encodedAt: DateTime.now(),
    );

    final box = _hiveService.getBox<EncodedImage>(StorageKeys.vaultImagesBox);
    await box.add(encodedImage);
    _loadData();
  }

  Future<String> decodeImage(String id) async {
    final box = _hiveService.getBox<EncodedImage>(StorageKeys.vaultImagesBox);
    final images = box.values.toList();
    final image = images.firstWhere((img) => img.id == id);

    return await StegoEngine.decodeMessage(Uint8List.fromList(image.imageData));
  }

  Future<void> deleteEncodedImage(String id) async {
    final box = _hiveService.getBox<EncodedImage>(StorageKeys.vaultImagesBox);
    final index = box.values.toList().indexWhere((img) => img.id == id);
    if (index != -1) {
      await box.deleteAt(index);
      _loadData();
    }
  }

  // ============= Clear All Data =============

  Future<void> clearAllData() async {
    await _hiveService.getBox<SecureNote>(StorageKeys.vaultNotesBox).clear();
    await _hiveService
        .getBox<PasswordEntry>(StorageKeys.vaultPasswordsBox)
        .clear();
    await _hiveService.getBox<EncodedImage>(StorageKeys.vaultImagesBox).clear();
    _loadData();
  }

  // ============= Import/Export =============

  Future<void> importVault(Map<String, dynamic> data) async {
    try {
      if (data['notes'] != null) {
        final notesList = data['notes'] as List;
        for (final noteData in notesList) {
          final note = SecureNote.fromJson(noteData as Map<String, dynamic>);
          final box =
              _hiveService.getBox<SecureNote>(StorageKeys.vaultNotesBox);
          await box.add(note);
        }
      }

      if (data['passwords'] != null) {
        final passwordsList = data['passwords'] as List;
        for (final passwordData in passwordsList) {
          final password =
              PasswordEntry.fromJson(passwordData as Map<String, dynamic>);
          final box =
              _hiveService.getBox<PasswordEntry>(StorageKeys.vaultPasswordsBox);
          await box.add(password);
        }
      }

      if (data['encodedImages'] != null) {
        final imagesList = data['encodedImages'] as List;
        for (final imageData in imagesList) {
          final image =
              EncodedImage.fromJson(imageData as Map<String, dynamic>);
          final box =
              _hiveService.getBox<EncodedImage>(StorageKeys.vaultImagesBox);
          await box.add(image);
        }
      }

      _loadData();
    } catch (e) {
      throw Exception('Failed to import vault: $e');
    }
  }
}
