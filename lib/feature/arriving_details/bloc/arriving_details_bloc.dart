import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:vivas/feature/arriving_details/Models/arriving_details_request_model.dart';
import 'package:vivas/feature/arriving_details/bloc/arriving_repository.dart';

part 'arriving_details_event.dart';

part 'arriving_details_state.dart';

class ArrivingDetailsBloc
    extends Bloc<ArrivingDetailsEvent, ArrivingDetailsState> {
  ArrivingRepository arrivingRepository;

  ArrivingDetailsBloc(
    this.arrivingRepository,
  ) : super(ArrivingDetailsInitial()) {
    on<SendArrivingDetailsEvent>(_sendArrivingDetails);
    on<ValidateFormEvent>(_validateFormEvent);
    on<SetArrivingDetailsEvent>(_setArrivingDetails);
  }

  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<ArrivingDetailsState> emit) {
    if (event.requestFormKey.currentState?.validate() ?? false) {
      event.requestFormKey.currentState?.save();
      emit(FormValidatedState());
    } else {
      emit(FormNotValidState());
    }
  }

  FutureOr<void> _setArrivingDetails(
      SetArrivingDetailsEvent event, Emitter<ArrivingDetailsState> emit) {
    emit(SetArrivingDetailsState(event.arrivingDetailsRequestModel));
  }

  FutureOr<void> _sendArrivingDetails(SendArrivingDetailsEvent event,
      Emitter<ArrivingDetailsState> emit) async {
    emit(SendingArrivingDetailsLoading());
    emit(await arrivingRepository
        .sendArrivingDetails(event.arrivingDetailsRequestModel));
  }
}
