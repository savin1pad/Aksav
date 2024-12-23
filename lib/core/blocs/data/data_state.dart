// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class GoalUploadImageLoadingState extends DataState {}

class GoalUploadImageErrorState extends DataState {
  final String message;
  const GoalUploadImageErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class GoalUploadImageSuccessState extends DataState {
  final String imageUrl;
  const GoalUploadImageSuccessState({
    required this.imageUrl,
  });

  @override
  List<Object> get props => [imageUrl];
}

class GoalLogImageUploadLoadingState extends DataState {}

class GoalLogImageUploadSuccessState extends DataState {
  final String imageUrl;
  const GoalLogImageUploadSuccessState({
    required this.imageUrl,
  });

  @override
  List<Object> get props => [imageUrl];
}

class GoalLogImageUploadErrorState extends DataState {
  final String message;
  const GoalLogImageUploadErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
