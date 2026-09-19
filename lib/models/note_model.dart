import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String category;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.category = 'geral',
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    String? category,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }
}