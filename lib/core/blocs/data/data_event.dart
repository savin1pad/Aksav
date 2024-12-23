// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'data_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object?> get props => [];
}

class GoalUploadImageEvent extends DataEvent {
  final File? xFile;
  final String? userID;

  const GoalUploadImageEvent({required this.xFile, required this.userID});

  @override
  List<Object?> get props => [xFile!, userID];
}

class GoalLogImageUploadEvent extends DataEvent {
  final File? xFile;
  final String? userID;
  final String? goalId;
  const GoalLogImageUploadEvent(
      {required this.xFile, required this.userID, required this.goalId});

  @override
  List<Object?> get props => [xFile!, userID, goalId];
}
