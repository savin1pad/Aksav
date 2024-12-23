// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:journey/core/logger.dart';

import 'package:journey/core/repository/storage_repository.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> with LogMixin {
  final StorageRepository storageRepository;
  DataBloc({
    required this.storageRepository,
  }) : super(DataInitial()) {
    on<DataEvent>((event, emit) {});
    on<GoalUploadImageEvent>((event, emit) async {
      emit(GoalUploadImageLoadingState());
      try {
        final String? imageUrl = await storageRepository.uploadMedia(
            file: event.xFile, userID: event.userID);
        emit(GoalUploadImageSuccessState(imageUrl: imageUrl!));
      } catch (e) {
        emit(GoalUploadImageErrorState(message: e.toString()));
      }
    });
  }
}
