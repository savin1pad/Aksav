import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/message_model.dart';

class ChatRepository with LogMixin {
  final String _baseUrl =
      'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app';

  Future<void> sendMessage({
    required String goalId,
    required String senderId,
    required String message,
    required String messageId,
    required String emailOrPhone,
    required bool isLog, // New parameter
  }) async {
    // Use different paths for logs and social messages
    final path = isLog ? 'logs' : 'chats';
    final url = Uri.parse('$_baseUrl/$path/$goalId.json');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'senderId': senderId,
          'message': message,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'messageId': messageId,
          'emailOrPhone': emailOrPhone,
          'isLog': isLog,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      errorLog('Error sending message: $e');
      rethrow;
    }
  }

  Stream<List<MessageModel>> getMessages({
    required String goalId,
    required bool isLog,
    required String userId, // For log access control
  }) async* {
    final path = isLog ? 'logs' : 'chats';
    final url = Uri.parse('$_baseUrl/$path/$goalId.json');

    while (true) {
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final messagesData =
              json.decode(response.body) as Map<String, dynamic>?;
          final List<MessageModel> messages = [];

          if (messagesData != null) {
            messagesData.forEach((key, value) {
              // For logs, only include messages if user is the owner
              if (!isLog || value['senderId'] == userId) {
                messages
                    .add(MessageModel.fromMap({...value, 'messageId': key}));
              }
            });

            messages.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
            yield messages;
          }
        }
      } catch (e) {
        errorLog('Error getting messages: $e');
        rethrow;
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
