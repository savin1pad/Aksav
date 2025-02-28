import 'package:equatable/equatable.dart';

class ZettelFolder extends Equatable {
  final String id;
  final String name;
  final List<String> noteIds;

  const ZettelFolder({
    required this.id,
    required this.name,
    required this.noteIds,
  });

  ZettelFolder copyWith({
    String? id,
    String? name,
    List<String>? noteIds,
  }) {
    return ZettelFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      noteIds: noteIds ?? this.noteIds,
    );
  }

  factory ZettelFolder.fromJson(Map<String, dynamic> json) {
    return ZettelFolder(
      id: json['id'] as String,
      name: json['name'] as String,
      noteIds: (json['noteIds'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'noteIds': noteIds,
    };
  }
  
  @override
  List<Object?> get props => [id, name, noteIds];

}