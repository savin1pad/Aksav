part of 'goals_bloc.dart';

class GoalsState extends Equatable {
  const GoalsState();

  @override
  List<Object> get props => [];
}

class GoalsInitial extends GoalsState {}

class GoalsPostLoadingState extends GoalsState {}

class GoalsPostErrorState extends GoalsState {
  final String message;
  const GoalsPostErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class GoalsPostSuccessState extends GoalsState {
  final GoalModel goal;
  const GoalsPostSuccessState({required this.goal});
  @override
  List<Object> get props => [goal];
}

class GoalsGetLoadingState extends GoalsState {}

class GoalsGetErrorState extends GoalsState {
  final String message;
  const GoalsGetErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class GoalsGetSuccessState extends GoalsState {
  final List<GoalModel> goals;
  const GoalsGetSuccessState({required this.goals});
  @override
  List<Object> get props => [goals];
}

class GoalsGetSocialSuccessState extends GoalsState {
  final List<GoalModel> goals;
  const GoalsGetSocialSuccessState({required this.goals});
  @override
  List<Object> get props => [goals];
}

class GoalsGetSocialErrorState extends GoalsState {
  final String message;
  const GoalsGetSocialErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class GoalsGetSocialLoadingState extends GoalsState {}

class GoalsUpdateFinanceSuccessState extends GoalsState {}

class GoalsUpdateFinanceErrorState extends GoalsState {
  final String message;
  const GoalsUpdateFinanceErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class GoalsUpdateFinanceLoadingState extends GoalsState {}

class GoalsUpdateSocialLoadingState extends GoalsState {}

class GoalsUpdateSocialErrorState extends GoalsState {
  final String message;
  const GoalsUpdateSocialErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class GoalsUpdateSocialSuccessState extends GoalsState {}

class SetFinanceLoadingState extends GoalsState {}

class SetFinanceSuccessState extends GoalsState {}

class SetFinanceErrorState extends GoalsState {
  final String message;
  const SetFinanceErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class GetFinanceLoadingState extends GoalsState {}

class GetFinanceErrorState extends GoalsState {
  final String errorMessage;
  const GetFinanceErrorState({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class GetFinanceSuccessState extends GoalsState {
  final FinanceModel finance;
  const GetFinanceSuccessState({required this.finance});
  @override
  List<Object> get props => [finance];
}
