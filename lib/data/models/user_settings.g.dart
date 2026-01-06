// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 4;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      themeMode: fields[0] as String,
      biometricEnabled: fields[1] as bool,
      autoLockEnabled: fields[2] as bool,
      autoLockMinutes: fields[3] as int,
      panicWipeEnabled: fields[4] as bool,
      maxFailedAttempts: fields[5] as int,
      hapticFeedback: fields[6] as bool,
      language: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.biometricEnabled)
      ..writeByte(2)
      ..write(obj.autoLockEnabled)
      ..writeByte(3)
      ..write(obj.autoLockMinutes)
      ..writeByte(4)
      ..write(obj.panicWipeEnabled)
      ..writeByte(5)
      ..write(obj.maxFailedAttempts)
      ..writeByte(6)
      ..write(obj.hapticFeedback)
      ..writeByte(7)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
