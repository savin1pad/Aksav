part of 'goal_log_bloc.dart';

class GoalLogState extends Equatable {
  const GoalLogState();

  @override
  List<Object> get props => [];
}

class GoalLogInitial extends GoalLogState {}

class GetGoalLoadingState extends GoalLogState {}

class GetGoalSuccessState extends GoalLogState {
  final List<LogModel> logs;
  const GetGoalSuccessState({required this.logs});
  @override
  List<Object> get props => [logs];
}

class GetGoalErrorState extends GoalLogState {
  final String message;
  const GetGoalErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class SendGoalLoadingState extends GoalLogState {}

class SendGoalSuccessState extends GoalLogState {}

class SendGoalErrorState extends GoalLogState {
  final String message;
  const SendGoalErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
