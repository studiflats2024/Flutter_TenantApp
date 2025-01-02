import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/complaint/create/create_ticket_send_model.dart';
import 'package:vivas/apis/models/complaint/details/details.api.model.dart';
import 'package:vivas/apis/models/complaint/list/complaint_api_model.dart';
import 'package:vivas/apis/models/complaint/reply/reply_complaint_send_model.dart';
import 'package:vivas/feature/complaints/bloc/complaints_repository.dart';

part 'complaints_event.dart';
part 'complaints_state.dart';

class ComplaintsBloc extends Bloc<ComplaintsEvent, ComplaintsState> {
  final BaseComplaintsRepository complaintsRepository;
  ComplaintsBloc(this.complaintsRepository) : super(ComplaintsInitial()) {
    on<GetComplaintsApiEvent>(_getComplaintsApiEvent);
    on<GetComplaintsTypeApiEvent>(_getComplaintsTypeApiEvent);
    on<GetComplaintDetailsApiEvent>(_getComplaintDetailsApiEvent);
    on<CreateTicketApiEvent>(_createTicketApiEvent);
    on<ReplyComplaintApiEvent>(_replyComplaintApiEvent);
    on<ValidateFormEvent>(_validateFormEvent);
  }

  FutureOr<void> _getComplaintsApiEvent(
      GetComplaintsApiEvent event, Emitter<ComplaintsState> emit) async {
    emit(ComplaintsLoadingState());
    emit(await complaintsRepository.getComplaintsListApi());
  }

  FutureOr<void> _getComplaintsTypeApiEvent(
      GetComplaintsTypeApiEvent event, Emitter<ComplaintsState> emit) async {
    emit(ComplaintsLoadingState());
    emit(await complaintsRepository.getTicketsTypesListApi());
  }

  FutureOr<void> _getComplaintDetailsApiEvent(
      GetComplaintDetailsApiEvent event, Emitter<ComplaintsState> emit) async {
    emit(ComplaintsLoadingState());
    emit(await complaintsRepository.getComplaintsDetailsApi(event.ticketId));
  }

  FutureOr<void> _createTicketApiEvent(
      CreateTicketApiEvent event, Emitter<ComplaintsState> emit) async {
    emit(ComplaintsLoadingState());
    emit(await complaintsRepository
        .createTicketApi(event.createTicketSendModel));
  }

  FutureOr<void> _replyComplaintApiEvent(
      ReplyComplaintApiEvent event, Emitter<ComplaintsState> emit) async {
    emit(ComplaintsLoadingState());
    emit(await complaintsRepository
        .replyTicketApi(event.replyComplaintSendModel));
  }

  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<ComplaintsState> emit) {
    if (event.formKey.currentState?.validate() ?? false) {
      event.formKey.currentState?.save();
      emit(FormValidatedState());
    } else {
      emit(FormNotValidatedState());
    }
  }
}
