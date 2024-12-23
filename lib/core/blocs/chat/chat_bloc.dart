import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journey/core/models/message_model.dart';
import 'package:journey/core/repository/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription? _messageSubscription;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      emit(SendChatLoadingState());
      try {
        await chatRepository.sendMessage(
          goalId: event.goalId,
          senderId: event.senderId,
          message: event.message,
          messageId: event.messageId,
          emailOrPhone: event.emailOrPhone,
          isLog: event.isLog,
        );
        emit(SendChatSuccessState(
          senderId: event.senderId,
          message: event.message,
          goalId: event.goalId,
          messageId: event.messageId,
          emailOrPhone: event.emailOrPhone,
          isLog: event.isLog,
        ));
      } catch (e) {
        emit(SendChatErrorState(message: e.toString()));
      }
    });

    on<LoadMessagesEvent>((event, emit) async {
      emit(ChatLoadingState());
      await _messageSubscription?.cancel();

      try {
        await emit.forEach<List<MessageModel>>(
          chatRepository.getMessages(
            goalId: event.goalId,
            isLog: event.isLog,
            userId: event.userId,
          ),
          onData: (messages) => ChatLoadedState(messages: messages),
          onError: (error, stackTrace) =>
              ChatErrorState(message: error.toString()),
        );
      } catch (e) {
        emit(ChatErrorState(message: e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
