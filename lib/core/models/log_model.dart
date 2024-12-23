import 'dart:convert';

import 'package:equatable/equatable.dart';

class LogModel extends Equatable {
  final String? senderId;
  final String? message;
  final int? timestamp;
  final String? logId;
  final String? emailOrPhone;
  final String? imageUrl; // Add imageUrl property

  const LogModel({
    required this.senderId,
    required this.message,
    required this.timestamp,
    required this.logId,
    required this.emailOrPhone,
    this.imageUrl, // Initialize imageUrl in the constructor
  });

  @override
  List<Object?> get props => [
        senderId,
        message,
        timestamp,
        logId,
        emailOrPhone,
        imageUrl, // Include imageUrl in props
      ];

  LogModel copyWith({
    String? senderId,
    String? message,
    int? timestamp,
    String? logId,
    String? emailOrPhone,
    String? imageUrl, // Add imageUrl to copyWith
  }) {
    return LogModel(
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      logId: logId ?? this.logId,
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      imageUrl: imageUrl ?? this.imageUrl, // Update imageUrl in copyWith
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
      'logId': logId,
      'emailOrPhone': emailOrPhone,
      'imageUrl': imageUrl, // Include imageUrl in toMap
    };
  }

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      timestamp: map['timestamp'] != null ? map['timestamp'] as int : null,
      logId: map['logId'] != null ? map['logId'] as String : null,
      emailOrPhone:
          map['emailOrPhone'] != null ? map['emailOrPhone'] as String : null,
      imageUrl: map['imageUrl'] != null
          ? map['imageUrl'] as String
          : null, // Get imageUrl from map
    );
  }

  String toJson() => json.encode(toMap());

  factory LogModel.fromJson(String source) =>
      LogModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LogModel(senderId: $senderId, message: $message, timestamp: $timestamp, logId: $logId, emailOrPhone: $emailOrPhone, imageUrl: $imageUrl)';
  }
}
