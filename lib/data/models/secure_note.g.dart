// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecureNoteAdapter extends TypeAdapter<SecureNote> {
  @override
  final int typeId = 0;

  @override
  SecureNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecureNote(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      createdAt: fields[3] as DateTime,
      lastModified: fields[4] as DateTime,
      tags: (fields[5] as List).cast<String>(),
      isFavorite: fields[6] as bool,
      color: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SecureNote obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastModified)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecureNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
