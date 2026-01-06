import 'package:hive_flutter/hive_flutter.dart';
import 'package:cypherkeep/core/constants/storage_keys.dart';
import 'package:cypherkeep/data/models/secure_note.dart';
import 'package:cypherkeep/data/models/encoded_image.dart';
import 'package:cypherkeep/data/models/password_entry.dart';
import 'package:cypherkeep/data/models/todo_item.dart';
import 'package:cypherkeep/data/models/user_settings.dart';

/// Service for initializing and managing Hive database
class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  bool _initialized = false;

  /// Initialize Hive and register adapters
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Initialize Hive for Flutter
      await Hive.initFlutter();

      // Register all type adapters
      Hive.registerAdapter(SecureNoteAdapter());
      Hive.registerAdapter(EncodedImageAdapter());
      Hive.registerAdapter(PasswordEntryAdapter());
      Hive.registerAdapter(TodoItemAdapter());
      Hive.registerAdapter(UserSettingsAdapter());

      // Open all boxes
      await Hive.openBox<SecureNote>(StorageKeys.vaultNotesBox);
      await Hive.openBox<EncodedImage>(StorageKeys.vaultImagesBox);
      await Hive.openBox<PasswordEntry>(StorageKeys.vaultPasswordsBox);
      await Hive.openBox<TodoItem>(StorageKeys.decoyTodoBox);
      await Hive.openBox<UserSettings>(StorageKeys.settingsBox);

      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize Hive: $e');
    }
  }

  /// Gets a box by name
  Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  /// Deletes all vault data (for panic wipe)
  Future<void> deleteVaultData() async {
    try {
      // Clear vault boxes only, keep decoy and settings
      final notesBox = Hive.box<SecureNote>(StorageKeys.vaultNotesBox);
      final imagesBox = Hive.box<EncodedImage>(StorageKeys.vaultImagesBox);
      final passwordsBox =
          Hive.box<PasswordEntry>(StorageKeys.vaultPasswordsBox);

      await notesBox.clear();
      await imagesBox.clear();
      await passwordsBox.clear();
    } catch (e) {
      throw Exception('Failed to delete vault data: $e');
    }
  }

  /// Deletes all data (complete reset)
  Future<void> deleteAllData() async {
    try {
      final notesBox = Hive.box<SecureNote>(StorageKeys.vaultNotesBox);
      final imagesBox = Hive.box<EncodedImage>(StorageKeys.vaultImagesBox);
      final passwordsBox =
          Hive.box<PasswordEntry>(StorageKeys.vaultPasswordsBox);
      final todoBox = Hive.box<TodoItem>(StorageKeys.decoyTodoBox);
      final settingsBox = Hive.box<UserSettings>(StorageKeys.settingsBox);

      await notesBox.clear();
      await imagesBox.clear();
      await passwordsBox.clear();
      await todoBox.clear();
      await settingsBox.clear();
    } catch (e) {
      throw Exception('Failed to delete all data: $e');
    }
  }

  /// Closes all Hive boxes
  Future<void> close() async {
    try {
      await Hive.close();
      _initialized = false;
    } catch (e) {
      throw Exception('Failed to close Hive: $e');
    }
  }

  /// Checks if Hive is initialized
  bool get isInitialized => _initialized;
}
