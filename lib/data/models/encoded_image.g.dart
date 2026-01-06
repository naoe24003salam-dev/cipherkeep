// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encoded_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EncodedImageAdapter extends TypeAdapter<EncodedImage> {
  @override
  final int typeId = 1;

  @override
  EncodedImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EncodedImage(
      id: fields[0] as String,
      imageData: (fields[1] as List).cast<int>(),
      messageLength: fields[2] as int,
      encodedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EncodedImage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageData)
      ..writeByte(2)
      ..write(obj.messageLength)
      ..writeByte(3)
      ..write(obj.encodedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncodedImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
