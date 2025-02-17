// lib/models/zettel_note.dart

class ZettelNote {
  final String id;
  final String title;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
   String? goalId;
  // You can store links explicitly as well
  final List<String> linkedNoteIds;

  ZettelNote({
    required this.id,
    required this.title,
    required this.content,
     this.goalId,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
    required this.linkedNoteIds,
  });

  // Create from JSON
  factory ZettelNote.fromMap(String id, Map<dynamic, dynamic> data) {
    return ZettelNote(
      id: id,
      goalId: data['goalId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrls: data['imageUrls'] == null
          ? []
          : List<String>.from(data['imageUrls'] as List),
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] ?? 0),
      linkedNoteIds: data['linkedNoteIds'] == null
          ? []
          : List<String>.from(data['linkedNoteIds'] as List),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'imageUrls': imageUrls,
      'goalId': goalId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'linkedNoteIds': linkedNoteIds,
    };
  }

  ZettelNote copyWith({
    String? title,
    String? content,
    String? goalId,
    List<String>? imageUrls,
    DateTime? updatedAt,
    List<String>? linkedNoteIds,
  }) {
    return ZettelNote(
      id: id,
      title: title ?? this.title,
      goalId: goalId ?? this.goalId,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      linkedNoteIds: linkedNoteIds ?? this.linkedNoteIds,
    );
  }
}