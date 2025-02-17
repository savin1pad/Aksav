import 'package:uuid/uuid.dart';

class ZettelModel {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final List<String> tags;
  final double? financialAmount;
  final String? financialCategory; // 'needs', 'wants', 'savings'
  final List<String> linkedZettelIds;
  final String? goalId; // Optional link to a financial goal

  ZettelModel({
    String? id,
    required this.userId,
    required this.title,
    required this.content,
    required this.tags,
    this.financialAmount,
    this.financialCategory,
    List<String>? linkedZettelIds,
    this.goalId,
  })  : id = id ?? const Uuid().v4(),
        createdAt = DateTime.now(),
        linkedZettelIds = linkedZettelIds ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'tags': tags,
        'financialAmount': financialAmount,
        'financialCategory': financialCategory,
        'linkedZettelIds': linkedZettelIds,
        'goalId': goalId,
      };

  factory ZettelModel.fromJson(Map<String, dynamic> json) => ZettelModel(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        content: json['content'],
        tags: List<String>.from(json['tags']),
        financialAmount: json['financialAmount'],
        financialCategory: json['financialCategory'],
        linkedZettelIds: List<String>.from(json['linkedZettelIds']),
        goalId: json['goalId'],
      );
}