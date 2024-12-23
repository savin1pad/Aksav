part of 'goal_log_bloc.dart';

class GoalLogEvent extends Equatable {
  const GoalLogEvent();

  @override
  List<Object?> get props => [];
}

class GetGoalLogEvent extends GoalLogEvent {
  final String goalId;
  const GetGoalLogEvent({required this.goalId});

  @override
  List<Object> get props => [goalId];
}

class SendGoalLogEvent extends GoalLogEvent {
  final String goalId;
  final String senderId;
  final String message;
  final String logId;
  final String emailOrPhone;
  final String? imageUrl;
  const SendGoalLogEvent({
    required this.goalId,
    required this.senderId,
    required this.message,
    required this.logId,
    required this.emailOrPhone,
    this.imageUrl,
  });
  @override
  List<Object?> get props => [
        goalId,
        senderId,
        message,
        logId,
        emailOrPhone,
        imageUrl,
      ];
}
