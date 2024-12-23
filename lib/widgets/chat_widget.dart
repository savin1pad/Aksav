// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey/core/blocs/chat/chat_bloc.dart';
import 'package:journey/core/models/message_model.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String goalId;
  final bool isLog;
  final String currentUserId;

  const ChatScreen({
    Key? key,
    required this.goalId,
    required this.isLog,
    required this.currentUserId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessagesEvent(
          goalId: widget.goalId,
          isLog: widget.isLog,
          userId: widget.currentUserId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Column(
            children: [
              state is ChatLoadedState
                  ? SizedBox(
                      height: 400,
                      child: _buildMessageList(state.messages),
                    )
                  : const SizedBox(
                      height: 400,
                      child: Center(
                        child: Text('No Text messages :('),
                      ),
                    ),
              SizedBox(
                height: 100,
                child: _buildMessageInput(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageList(List<MessageModel> messages) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == widget.currentUserId;

        return MessageBubble(
          message: message.message ?? '',
          senderName:
              widget.isLog ? 'You' : message.emailIdOrPhone ?? 'Unknown',
          isMe: isMe,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
              message.timestamp?.millisecondsSinceEpoch ?? 0),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: widget.isLog ? 'Add to log...' : 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    context.read<ChatBloc>().add(SendMessageEvent(
          goalId: widget.goalId,
          senderId: widget.currentUserId,
          message: message,
          messageId: DateTime.now().toString(),
          emailOrPhone: RepositoryProvider.of<UserModel>(context).email!,
          isLog: widget.isLog,
        ));

    _messageController.clear();
  }
}
