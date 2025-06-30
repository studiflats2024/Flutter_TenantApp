import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/apis/models/my_problems/add_problem_response.dart';
import 'package:vivas/apis/models/my_problems/problem_api_model.dart';
import 'package:vivas/apis/models/my_problems/problem_details_api_model.dart';
import 'package:vivas/apis/models/my_problems/user_apartments_api_model.dart';
import 'package:vivas/feature/problem/bloc/my_problem_repository.dart';
import 'package:vivas/feature/problem/model/filter_enum.dart';
import 'package:vivas/feature/problem/model/send_problem_model.dart';

part 'my_problem_event.dart';

part 'my_problem_state.dart';

class MyProblemBloc extends Bloc<MyProblemEvent, MyProblemState> {
  final BaseMyProblemRepository myProblemRepository;

  MyProblemBloc(this.myProblemRepository) : super(MyProblemInitial()) {
    on<GetMyProblemApiEvent>(_getMyProblemApiEvent);
    on<GetUserApartmentsApiEvent>(_getUserApartmentsApiEvent);
    on<ValidateFormEvent>(_validateFormEvent);
    on<ChangeNumberOfDateAvailableEvent>(_changeNumberOfDateAvailableEvent);
    on<SendProblemApiEvent>(_sendProblemApiEvent);
    on<GetProblemDetailsApiEvent>(_getProblemDetailsApiEvent);
    on<EditDescriptionApiEvent>(_editDescriptionApiEvent);
    on<ReadMaintenanceEvent>(_updateReadProblemApiEvent);
  }

  FutureOr<void> _getMyProblemApiEvent(
      GetMyProblemApiEvent event, Emitter<MyProblemState> emit) async {
    emit(MyProblemLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? MyProblemLoadingState()
          : MyProblemLoadingAsPagingState());
    }
    emit(await myProblemRepository.getMyProblemApi(
        event.pageNumber, event.problemFilter));
  }

  FutureOr<void> _getUserApartmentsApiEvent(
      GetUserApartmentsApiEvent event, Emitter<MyProblemState> emit) async {
    emit(MyProblemLoadingState());
    emit(await myProblemRepository.getUserApartmentsApi());
  }

  FutureOr<void> _changeNumberOfDateAvailableEvent(
      ChangeNumberOfDateAvailableEvent event, Emitter<MyProblemState> emit) {
    emit(ChangeNumberOfDateAvailableState(event.numberDate));
  }

  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<MyProblemState> emit) {
    if (event.formKey.currentState?.validate() ?? false) {
      event.formKey.currentState?.save();
      emit(FormValidatedState());
    } else {
      emit(FormNotValidatedState());
    }
  }

  FutureOr<void> _sendProblemApiEvent(
      SendProblemApiEvent event, Emitter<MyProblemState> emit) async {
    emit(MyProblemLoadingState());
    emit(await myProblemRepository.sendProblemApi(event.sendProblemModel));
  }

  FutureOr<void> _getProblemDetailsApiEvent(
      GetProblemDetailsApiEvent event, Emitter<MyProblemState> emit) async {
    emit(MyProblemLoadingState());
    emit(await myProblemRepository.getProblemDetailsApi(event.problemId));
  }

  _updateReadProblemApiEvent(
      ReadMaintenanceEvent event, Emitter<MyProblemState> emit) async {
    emit(ReadMyProblemMaintenance(event.isRead));
  }

  FutureOr<void> _editDescriptionApiEvent(
      EditDescriptionApiEvent event, Emitter<MyProblemState> emit) async {
    emit(MyProblemLoadingState());
    emit(await myProblemRepository.editDescriptionApi(
        event.problemId, event.description));
  }
}
