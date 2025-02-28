// lib/models/zettel_note.dart

import 'dart:io';

import 'package:equatable/equatable.dart';

class ZettelNote extends Equatable {
  final String id;
  final String title;
  final String userId;
  final String content;
  final List<File> imageUrls;
  final List<File> videoUrls;
  final List<String> linkedNoteIds;

  const ZettelNote(
      {required this.id,
      required this.userId,
      required this.title,
      required this.content,
      required this.imageUrls,
      required this.videoUrls,
      required this.linkedNoteIds});

  ZettelNote copyWith({
    String? id,
    String? title,
    String? userId,
    String? content,
    List<File>? imageUrls,
    List<File>? videoUrls,
    List<String>? linkedNoteIds,
  }) {
    return ZettelNote(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrls: videoUrls ?? this.videoUrls,
      linkedNoteIds: linkedNoteIds ?? this.linkedNoteIds,
    );
  }

  factory ZettelNote.fromJson(Map<String, dynamic> json) {
    return ZettelNote(
      id: json['id'] as String,
      title: json['title'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => File(e.toString()))
              .toList() ??
          [],
      videoUrls: (json['videoUrls'] as List<dynamic>?)
              ?.map((e) => File(e.toString()))
              .toList() ??
          [],
      linkedNoteIds: (json['linkedNoteIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'userId': userId,
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
      'linkedNoteIds': linkedNoteIds,
    };
  }

  @override
  List<Object?> get props =>
      [id, title, userId, content, imageUrls, videoUrls, linkedNoteIds];
}
