import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/log_model.dart';

class GoalLogRepository with LogMixin {
  final String _baseUrl =
      'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app';

  Future<void> sendLog({
    required String goalId,
    required String senderId,
    required String message,
    required String logId,
    required String emailOrPhone,
    String? imageUrl, // Optional image URL
  }) async {
    final url = Uri.parse('$_baseUrl/logs/$goalId.json');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'senderId': senderId,
          'message': message,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'logId': logId,
          'emailOrPhone': emailOrPhone,
          'imageUrl': imageUrl, // Add image URL to the data
        }),
      );

      if (response.statusCode == 200) {
        warningLog('Log sent successfully!');
      } else {
        errorLog('Failed to send log: ${response.body}');
        throw Exception('Failed to send log');
      }
    } catch (e) {
      errorLog('Error sending log: $e');
      rethrow;
    }
  }

  // Function to get logs for a specific goal
  Stream<List<LogModel>> getLogs({required String goalId}) async* {
    final url = Uri.parse('$_baseUrl/logs/$goalId.json');

    while (true) {
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final logsData = json.decode(response.body) as Map<String, dynamic>?;
          final List<LogModel> logs = [];

          if (logsData != null) {
            logsData.forEach((logId, logData) {
              logs.add(LogModel.fromMap({
                ...logData,
                'logId': logId,
              }));
            });
          }

          // Sort logs by timestamp
          logs.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

          yield logs;
        } else {
          errorLog('Failed to get logs: ${response.body}');
          throw Exception('Failed to get logs');
        }
      } catch (e) {
        errorLog('Error getting logs: $e');
        rethrow;
      }

      // Adjust the delay as needed for your app
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
