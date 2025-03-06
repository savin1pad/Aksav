import 'package:equatable/equatable.dart';

class ZettelFolder extends Equatable {
  final String id;
  final String name;
  final List<String> noteIds;
  final String userId;

  const ZettelFolder({
    required this.id,
    required this.name,
    required this.noteIds,
     this.userId = '',
  });

  ZettelFolder copyWith({
    String? id,
    String? name,
    List<String>? noteIds,
    String? userId,
  }) {
    return ZettelFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      noteIds: noteIds ?? this.noteIds,
      userId: userId ?? this.userId,
    );
  }

  factory ZettelFolder.fromJson(Map<String, dynamic> json) {
    return ZettelFolder(
      id: json['id'] as String,
      name: json['name'] as String,
      noteIds: (json['noteIds'] as List).map((e) => e as String).toList(),
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'noteIds': noteIds,
      'userId': userId,
    };
  }
  
  @override
  List<Object?> get props => [id, name, noteIds, userId];

}