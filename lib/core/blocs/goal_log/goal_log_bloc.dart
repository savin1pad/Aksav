import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:journey/core/models/log_model.dart';
import 'package:journey/core/repository/goal_log_repository.dart';

part 'goal_log_event.dart';
part 'goal_log_state.dart';

class GoalLogBloc extends Bloc<GoalLogEvent, GoalLogState> {
  final GoalLogRepository goalLogRepository;
  GoalLogBloc({required this.goalLogRepository}) : super(GoalLogInitial()) {
    on<GoalLogEvent>((event, emit) {});
    on<SendGoalLogEvent>((event, emit) {
      emit(SendGoalLoadingState());
      try {
        goalLogRepository.sendLog(
          goalId: event.goalId,
          senderId: event.senderId,
          message: event.message,
          logId: event.logId,
          emailOrPhone: event.emailOrPhone,
          imageUrl: event.imageUrl,
        );
        emit(
          SendGoalSuccessState(),
        );
      } catch (e) {
        emit(SendGoalErrorState(message: e.toString()));
      }
    });
  }
}
