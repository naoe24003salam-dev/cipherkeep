import 'package:hive/hive.dart';
import 'package:cypherkeep/core/constants/storage_keys.dart';

part 'user_settings.g.dart';

@HiveType(typeId: HiveTypeIds.userSettings)
class UserSettings extends HiveObject {
  @HiveField(0)
  String themeMode; // AppTheme enum as string

  @HiveField(1)
  bool biometricEnabled;

  @HiveField(2)
  bool autoLockEnabled;

  @HiveField(3)
  int autoLockMinutes;

  @HiveField(4)
  bool panicWipeEnabled;

  @HiveField(5)
  int maxFailedAttempts;

  @HiveField(6)
  bool hapticFeedback;

  @HiveField(7)
  String language;

  UserSettings({
    this.themeMode = 'cyberpunk',
    this.biometricEnabled = false,
    this.autoLockEnabled = true,
    this.autoLockMinutes = 5,
    this.panicWipeEnabled = false,
    this.maxFailedAttempts = 5,
    this.hapticFeedback = true,
    this.language = 'en',
  });

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode,
        'biometricEnabled': biometricEnabled,
        'autoLockEnabled': autoLockEnabled,
        'autoLockMinutes': autoLockMinutes,
        'panicWipeEnabled': panicWipeEnabled,
        'maxFailedAttempts': maxFailedAttempts,
        'hapticFeedback': hapticFeedback,
        'language': language,
      };

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        themeMode: json['themeMode'] as String,
        biometricEnabled: json['biometricEnabled'] as bool,
        autoLockEnabled: json['autoLockEnabled'] as bool,
        autoLockMinutes: json['autoLockMinutes'] as int,
        panicWipeEnabled: json['panicWipeEnabled'] as bool,
        maxFailedAttempts: json['maxFailedAttempts'] as int,
        hapticFeedback: json['hapticFeedback'] as bool,
        language: json['language'] as String,
      );

  UserSettings copyWith({
    String? themeMode,
    bool? biometricEnabled,
    bool? autoLockEnabled,
    int? autoLockMinutes,
    bool? panicWipeEnabled,
    int? maxFailedAttempts,
    bool? hapticFeedback,
    String? language,
  }) =>
      UserSettings(
        themeMode: themeMode ?? this.themeMode,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        autoLockEnabled: autoLockEnabled ?? this.autoLockEnabled,
        autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
        panicWipeEnabled: panicWipeEnabled ?? this.panicWipeEnabled,
        maxFailedAttempts: maxFailedAttempts ?? this.maxFailedAttempts,
        hapticFeedback: hapticFeedback ?? this.hapticFeedback,
        language: language ?? this.language,
      );
}
