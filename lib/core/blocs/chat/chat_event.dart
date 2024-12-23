part of 'chat_bloc.dart';

class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String goalId;
  final String message;
  final String emailOrPhone;
  final String senderId;
  final String messageId;
  final bool isLog;

  const SendMessageEvent({
    required this.goalId,
    required this.message,
    required this.emailOrPhone,
    required this.messageId,
    required this.senderId,
    required this.isLog,
  });

  @override
  List<Object> get props =>
      [goalId, message, senderId, emailOrPhone, messageId, isLog];
}

class LoadMessagesEvent extends ChatEvent {
  final String goalId;
  final bool isLog;
  final String userId;
  const LoadMessagesEvent({
    required this.goalId,
    required this.isLog,
    required this.userId,
  });

  @override
  List<Object> get props => [goalId, isLog, userId];
}
