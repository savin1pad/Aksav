import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/finance_model.dart';
import 'package:journey/core/models/goal_model.dart';

class GoalRepository with LogMixin {
  Future<GoalModel> postGoal({required GoalModel goal}) async {
    final url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/Goal.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': goal.id,
          'goal': goal.goal,
          'finance': goal.finance,
          'photoUrl': goal.photoUrl,
          'userId': goal.userId,
          'isSocial': goal.isSocial,
          'allocatedAmount': goal.allocatedAmount,
          'targetAmount': goal.targetAmount,
        }),
      );
      warningLog('message: ${response.statusCode} and body ${response.body}');
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      errorLog('message: $responseBody');
      return goal;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postFinance(
      {required String amount, required String userId}) async {
    final url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/Finance.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'finance': amount,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        warningLog('Finance posted successfully for user: $userId');
      } else {
        errorLog('Failed to post finance for user: $userId - ${response.body}');
        throw Exception('Failed to post finance');
      }
    } catch (e) {
      errorLog('Error posting finance: $e');
      rethrow;
    }
  }

  Future<FinanceModel> getFinance({required String userId}) async {
    final url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/Finance.json');
    try {
      final response = await http.get(url);
      warningLog('message: ${response.statusCode} and body ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Find the finance entry for the specific user
        final userFinance = data.entries.firstWhere(
          (entry) => entry.value['userId'] == userId,
          orElse: () => MapEntry('', {'finance': '0', 'userId': userId}),
        );

        return FinanceModel(
          income: userFinance.value['finance'],
          userId: userFinance.value['userId'],
        );
      } else {
        throw Exception('Failed to load finance data');
      }
    } catch (e) {
      errorLog('Error getting finance: $e');
      rethrow;
    }
  }

  Future<List<GoalModel>> getGoals({required String userId}) async {
    final url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/Goal.json?orderBy="userId"&equalTo="$userId"');
    try {
      final response = await http.get(url);
      warningLog('message: ${response.statusCode} and body ${response.body}');
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as Map<String, dynamic>;
        List<GoalModel> goals = [];
        responseBody.forEach((key, value) {
          goals.add(
            GoalModel(
              id: key,
              goal: value['goal'],
              finance: value['finance'],
              photoUrl: value['photoUrl'],
              userId: value['userId'],
              isSocial: value['isSocial'],
              allocatedAmount: value['allocatedAmount'],
              targetAmount: value['targetAmount'],
            ),
          );
        });
        return goals;
      } else {
        // Handle error responses appropriately
        throw Exception('Failed to load goals');
      }
    } catch (e) {
      rethrow;
    }
  }

  void distributeGoalAmount(List<GoalModel> goals, String totalFinance) {
    // Get the total amount allocated for goals (40% of savings, which is 20% of total)
    final goalAllocation = double.parse(totalFinance) * 0.20 * 0.50;

    // Distribute evenly among all goals
    if (goals.isNotEmpty) {
      final amountPerGoal = goalAllocation / goals.length;
      for (var goal in goals) {
        goal.allocatedAmount = amountPerGoal;
      }
    }
  }

  Future<List<GoalModel>> getSocialGoals() async {
    final url = Uri.parse(
      'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/Goal.json?orderBy="isSocial"&equalTo=true',
    );
    try {
      final response = await http.get(url);
      errorLog('message: ${response.statusCode} and body ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as Map<String, dynamic>;
        List<GoalModel> goals = [];
        responseBody.forEach((key, value) {
          goals.add(
            GoalModel(
              id: key,
              goal: value['goal'],
              finance: value['finance'],
              photoUrl: value['photoUrl'],
              userId: value['userId'],
              isSocial: value['isSocial'],
              allocatedAmount: value['allocatedAmount'],
              targetAmount: value['targetAmount'],
            ),
          );
        });
        return goals;
      } else {
        // Handle error responses appropriately
        throw Exception('Failed to load goals');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFinance(
      {required String userId, required double newFinance}) async {
    try {
      // First get all finance records to find the one with matching userId
      final url = Uri.parse(
          'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/Finance.json');

      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch finance data');
      }

      final Map<String, dynamic> data = json.decode(response.body);

      // Find the entry with matching userId
      String? docId;
      data.forEach((key, value) {
        if (value['userId'] == userId) {
          docId = key;
        }
      });

      if (docId == null) {
        // If no existing record found, create a new one
        final createResponse = await http.post(
          url,
          body: json.encode({
            'finance': newFinance.toString(),
            'userId': userId,
          }),
        );

        if (createResponse.statusCode != 200) {
          throw Exception('Failed to create finance record');
        }
        warningLog('New finance record created for user: $userId');
      } else {
        // Update existing record
        final updateUrl = Uri.parse(
            'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/Finance/$docId.json');

        final updateResponse = await http.patch(
          updateUrl,
          body: json.encode({
            'finance': newFinance.toString(),
          }),
        );

        if (updateResponse.statusCode != 200) {
          throw Exception('Failed to update finance record');
        }
        warningLog('Finance updated successfully for user: $userId');
      }
    } catch (e) {
      errorLog('Error updating finance: $e');
      rethrow;
    }
  }

  Future<void> updateGoalCompletion(
      {required String goalId, required bool isCompleted}) async {
    final url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/Goal/$goalId.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode({'isCompleted': isCompleted}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update goal completion status');
      }
    } catch (e) {
      errorLog('Error updating goal completion: $e');
      rethrow;
    }
  }

  Future<void> distributeFinances({required String userId}) async {
    try {
      final goals = await getGoals(userId: userId);
      final activeGoals =
          goals.where((goal) => !(goal.isCompleted ?? false)).toList();

      if (activeGoals.isEmpty) return;

      final finance = await getFinance(userId: userId);
      final totalFinance = double.tryParse(finance.income ?? '0') ?? 0;

      // Calculate 40% of savings (which is 20% of total)
      final goalsAllocation = totalFinance * 0.20 * 0.40;

      // Calculate equal distribution
      final perGoalAllocation = goalsAllocation / activeGoals.length;

      for (var goal in activeGoals) {
        final updatedGoal = goal.copyWith(allocatedAmount: perGoalAllocation);

        if ((updatedGoal.allocatedAmount ?? 0) >=
            (updatedGoal.targetAmount ?? 0)) {
          await updateGoalCompletion(
              goalId: updatedGoal.id!, isCompleted: true);
        }

        final url = Uri.parse(
            'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/Goal/${goal.id}.json');
        await http.patch(
          url,
          body: json.encode({
            'allocatedAmount': updatedGoal.allocatedAmount,
          }),
        );
      }
    } catch (e) {
      errorLog('Error distributing finances: $e');
      rethrow;
    }
  }

  Future<void> updateSocial(
      {required String goalId, required bool isSocial}) async {
    final url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/Goal/$goalId.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode({'isSocial': isSocial}),
      );

      if (response.statusCode == 200) {
        warningLog('Social updated successfully for goal: $goalId');
      } else {
        errorLog(
            'Failed to update Social for goal: $goalId - ${response.body}');
        throw Exception('Failed to update finance');
      }
    } catch (e) {
      errorLog('Error updating finance: $e');
      rethrow;
    }
  }
}
