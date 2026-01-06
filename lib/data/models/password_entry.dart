import 'package:hive/hive.dart';
import 'package:cypherkeep/core/constants/storage_keys.dart';

part 'password_entry.g.dart';

@HiveType(typeId: HiveTypeIds.passwordEntry)
class PasswordEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String username;

  @HiveField(3)
  String password;

  @HiveField(4)
  String site;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime lastModified;

  @HiveField(8)
  List<String> tags;

  @HiveField(9)
  String icon; // App icon identifier (first letter of title by default)

  PasswordEntry({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.site,
    this.notes,
    required this.createdAt,
    required this.lastModified,
    this.tags = const [],
    String? icon,
  }) : icon = icon ??
            (title.isNotEmpty ? title.substring(0, 1).toUpperCase() : 'P');

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'username': username,
        'password': password,
        'site': site,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'lastModified': lastModified.toIso8601String(),
        'tags': tags,
        'icon': icon,
      };

  factory PasswordEntry.fromJson(Map<String, dynamic> json) => PasswordEntry(
        id: json['id'] as String,
        title: json['title'] as String,
        username: json['username'] as String,
        password: json['password'] as String,
        site: json['site'] as String,
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastModified: DateTime.parse(json['lastModified'] as String),
        tags: (json['tags'] as List<dynamic>).cast<String>(),
        icon: json['icon'] as String,
      );

  PasswordEntry copyWith({
    String? id,
    String? title,
    String? username,
    String? password,
    String? site,
    String? notes,
    DateTime? createdAt,
    DateTime? lastModified,
    List<String>? tags,
    String? icon,
  }) =>
      PasswordEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        username: username ?? this.username,
        password: password ?? this.password,
        site: site ?? this.site,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        lastModified: lastModified ?? this.lastModified,
        tags: tags ?? this.tags,
        icon: icon ?? this.icon,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
