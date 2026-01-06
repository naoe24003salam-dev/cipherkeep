import 'package:hive/hive.dart';
import 'package:cypherkeep/core/constants/storage_keys.dart';

part 'encoded_image.g.dart';

@HiveType(typeId: HiveTypeIds.encodedImage)
class EncodedImage extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  List<int> imageData;

  @HiveField(2)
  int messageLength;

  @HiveField(3)
  DateTime encodedAt;

  EncodedImage({
    required this.id,
    required this.imageData,
    required this.messageLength,
    required this.encodedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageData': imageData,
        'messageLength': messageLength,
        'encodedAt': encodedAt.toIso8601String(),
      };

  factory EncodedImage.fromJson(Map<String, dynamic> json) => EncodedImage(
        id: json['id'] as String,
        imageData: List<int>.from(json['imageData'] as List),
        messageLength: json['messageLength'] as int,
        encodedAt: DateTime.parse(json['encodedAt'] as String),
      );

  EncodedImage copyWith({
    String? id,
    List<int>? imageData,
    int? messageLength,
    DateTime? encodedAt,
  }) =>
      EncodedImage(
        id: id ?? this.id,
        imageData: imageData ?? this.imageData,
        messageLength: messageLength ?? this.messageLength,
        encodedAt: encodedAt ?? this.encodedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncodedImage &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
