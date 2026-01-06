import 'package:hive/hive.dart';
import 'package:cypherkeep/core/constants/storage_keys.dart';

part 'secure_note.g.dart';

@HiveType(typeId: HiveTypeIds.secureNote)
class SecureNote extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime lastModified;

  @HiveField(5)
  List<String> tags;

  @HiveField(6)
  bool isFavorite;

  @HiveField(7)
  String color; // Hex color for UI customization

  SecureNote({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.lastModified,
    this.tags = const [],
    this.isFavorite = false,
    this.color = '#1A1F3A',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'lastModified': lastModified.toIso8601String(),
        'tags': tags,
        'isFavorite': isFavorite,
        'color': color,
      };

  factory SecureNote.fromJson(Map<String, dynamic> json) => SecureNote(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastModified: DateTime.parse(json['lastModified'] as String),
        tags: (json['tags'] as List<dynamic>).cast<String>(),
        isFavorite: json['isFavorite'] as bool,
        color: json['color'] as String,
      );

  SecureNote copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? lastModified,
    List<String>? tags,
    bool? isFavorite,
    String? color,
  }) =>
      SecureNote(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        lastModified: lastModified ?? this.lastModified,
        tags: tags ?? this.tags,
        isFavorite: isFavorite ?? this.isFavorite,
        color: color ?? this.color,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecureNote && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
