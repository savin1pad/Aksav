import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journey/core/models/finance_model.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:journey/core/repository/goal_repository.dart';

part 'goals_event.dart';
part 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final GoalRepository goalRepository;
  GoalsBloc({required this.goalRepository}) : super(GoalsInitial()) {
    on<GoalsEvent>((event, emit) {});

    on<GoalsPostEvent>((event, emit) async {
      emit(GoalsPostLoadingState());
      try {
        final goal = await goalRepository.postGoal(goal: event.goal);
        emit(GoalsPostSuccessState(goal: goal));
      } catch (e) {
        emit(GoalsPostErrorState(message: e.toString()));
      }
    });

    on<GoalsGetEvent>((event, emit) async {
      emit(GoalsGetLoadingState());
      try {
        final List<GoalModel> goals =
            await goalRepository.getGoals(userId: event.userId);
        emit(GoalsGetSuccessState(goals: goals));
      } catch (e) {
        emit(GoalsGetErrorState(message: e.toString()));
      }
    });

    on<GoalsGetSocialEvent>((event, emit) async {
      emit(GoalsGetSocialLoadingState());
      try {
        final List<GoalModel> goals = await goalRepository.getSocialGoals();
        emit(GoalsGetSocialSuccessState(goals: goals));
      } catch (e) {
        emit(GoalsGetSocialErrorState(message: e.toString()));
      }
    });

    on<GoalsUpdateFinanceEvent>((event, emit) async {
      emit(GoalsUpdateFinanceLoadingState());
      try {
        await goalRepository.updateFinance(
            userId: event.userId, newFinance: event.newFinance);
        emit(GoalsUpdateFinanceSuccessState());
      } catch (e) {
        emit(
          GoalsUpdateFinanceErrorState(
            message: e.toString(),
          ),
        );
      }
    });

    on<GoalsUpdateSocialEvent>((event, emit) {
      emit(GoalsUpdateSocialLoadingState());
      try {
        goalRepository.updateSocial(
            goalId: event.goalId, isSocial: event.isSocial);
        emit(GoalsUpdateSocialSuccessState());
      } catch (e) {
        emit(GoalsUpdateSocialErrorState(message: e.toString()));
      }
    });

    on<SetFinanceEvents>((event, emit) async {
      emit(SetFinanceLoadingState());
      try {
        await goalRepository.postFinance(
            amount: event.amount, userId: event.userId);
        emit(SetFinanceSuccessState());
      } catch (e) {
        emit(SetFinanceErrorState(
          message: e.toString(),
        ));
      }
    });

    on<GetFinanceEvents>((event, emit) async {
      emit(GetFinanceLoadingState());
      try {
        final finance = await goalRepository.getFinance(userId: event.userId);
        emit(GetFinanceSuccessState(finance: finance));
      } catch (e) {
        emit(GetFinanceErrorState(errorMessage: e.toString()));
      }
    });
  }
}
