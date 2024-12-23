// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String? senderId;
  final String? message;
  final DateTime? timestamp;
  final String? goalId;
  final String? messageId;
  final String? emailIdOrPhone;

  const MessageModel(
      {required this.senderId,
      required this.message,
      required this.timestamp,
      required this.goalId,
      required this.messageId,
      required this.emailIdOrPhone});

  @override
  List<Object?> get props =>
      [senderId, message, timestamp, goalId, messageId, emailIdOrPhone];

  MessageModel copyWith({
    String? senderId,
    String? message,
    DateTime? timestamp,
    String? goalId,
    String? messageId,
    String? emailIdOrPhone,
  }) {
    return MessageModel(
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      goalId: goalId ?? this.goalId,
      messageId: messageId ?? this.messageId,
      emailIdOrPhone: emailIdOrPhone ?? this.emailIdOrPhone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'goalId': goalId,
      'messageId': messageId,
      'emailIdOrPhone': emailIdOrPhone,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : null,
      goalId: map['goalId'] != null ? map['goalId'] as String : null,
      messageId: map['messageId'] != null ? map['messageId'] as String : null,
      emailIdOrPhone: map['emailIdOrPhone'] != null
          ? map['emailIdOrPhone'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(senderId: $senderId, message: $message, timestamp: $timestamp, goalId: $goalId, messageId: $messageId, emailIdOrPhone: $emailIdOrPhone)';
  }
}
