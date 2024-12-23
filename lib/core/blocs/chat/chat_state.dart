part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class SendChatLoadingState extends ChatState {}

class SendChatErrorState extends ChatState {
  final String message;
  const SendChatErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [
        message,
      ];
}

class SendChatSuccessState extends ChatState {
  final String senderId;
  final String message;
  final String goalId;
  final String messageId;
  final String emailOrPhone;
  final bool isLog;
  const SendChatSuccessState({
    required this.senderId,
    required this.message,
    required this.goalId,
    required this.messageId,
    required this.emailOrPhone,
    required this.isLog,
  });
  @override
  List<Object> get props => [
        senderId,
        message,
        goalId,
        messageId,
        emailOrPhone,
        isLog,
      ];
}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<MessageModel> messages;

  const ChatLoadedState({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatErrorState extends ChatState {
  final String message;
  const ChatErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
