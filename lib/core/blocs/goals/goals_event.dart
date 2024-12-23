part of 'goals_bloc.dart';

class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object> get props => [];
}

class GoalsPostEvent extends GoalsEvent {
  final GoalModel goal;
  const GoalsPostEvent({required this.goal});
  @override
  List<Object> get props => [goal];
}

class GoalsGetEvent extends GoalsEvent {
  final String userId;
  const GoalsGetEvent({required this.userId});
  @override
  List<Object> get props => [userId];
}

class GoalsGetSocialEvent extends GoalsEvent {}

class GoalsUpdateFinanceEvent extends GoalsEvent {
  final String userId;
  final double newFinance;
  const GoalsUpdateFinanceEvent(
      {required this.userId, required this.newFinance});
  @override
  List<Object> get props => [userId, newFinance];
}

class GoalsUpdateSocialEvent extends GoalsEvent {
  final bool isSocial;
  final String goalId;
  const GoalsUpdateSocialEvent({required this.isSocial, required this.goalId});
  @override
  List<Object> get props => [isSocial, goalId];
}

class SetFinanceEvents extends GoalsEvent {
  final String amount;
  final String userId;
  const SetFinanceEvents({
    required this.amount,
    required this.userId,
  });
  @override
  List<Object> get props => [amount, userId];
}

class GetFinanceEvents extends GoalsEvent {
  final String userId;
  const GetFinanceEvents({
    required this.userId,
  });
  @override
  List<Object> get props => [userId];
}
