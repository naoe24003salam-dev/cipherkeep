import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cypherkeep/config/themes/theme_data.dart';
import 'package:cypherkeep/data/services/hive_service.dart';
import 'package:cypherkeep/data/models/user_settings.dart';
import 'package:cypherkeep/core/constants/storage_keys.dart';

/// Provider for current theme
final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});

/// Notifier for theme management
class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme.cyberpunk) {
    _loadTheme();
  }

  final _hiveService = HiveService();

  /// Loads the saved theme from settings
  Future<void> _loadTheme() async {
    try {
      final settingsBox =
          _hiveService.getBox<UserSettings>(StorageKeys.settingsBox);
      if (settingsBox.isNotEmpty) {
        final settings = settingsBox.getAt(0);
        if (settings != null) {
          final themeName = settings.themeMode;
          state = AppTheme.values.firstWhere(
            (t) => t.name == themeName,
            orElse: () => AppTheme.cyberpunk,
          );
        }
      }
    } catch (e) {
      // If error, keep default theme
      state = AppTheme.cyberpunk;
    }
  }

  /// Sets the theme and persists it
  Future<void> setTheme(AppTheme theme) async {
    try {
      state = theme;

      // Save to settings
      final settingsBox =
          _hiveService.getBox<UserSettings>(StorageKeys.settingsBox);
      UserSettings settings;

      if (settingsBox.isEmpty) {
        settings = UserSettings(themeMode: theme.name);
        await settingsBox.add(settings);
      } else {
        settings = settingsBox.getAt(0)!;
        final updated = settings.copyWith(themeMode: theme.name);
        await settingsBox.putAt(0, updated);
      }
    } catch (e) {
      // Error saving theme, but state is still updated
    }
  }

  /// Gets all available themes
  List<AppTheme> getAvailableThemes() {
    return AppTheme.values;
  }
}
