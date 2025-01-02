import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/UploadPassportRequestModel/passport_request_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/guests_request_model.dart';
import 'package:vivas/feature/request_details/request_passport/bloc/request_passport_repository.dart';

part 'request_passport_event.dart';
part 'request_passport_state.dart';

class RequestPassportBloc
    extends Bloc<RequestPassportEvent, RequestPassportState> {
  final BaseRequestPassportRepository requestPassportRepository;
  RequestPassportBloc(this.requestPassportRepository)
      : super(RequestPassportInitial()) {
    on<UpdateGuestRequestInfoEvent>(_updateGuestRequestInfoEvent);
    on<UpdateGuestRequestInfoEventV2>(_updateGuestRequestInfoEventV2);
    on<UpdateGuestRequestListApiEvent>(_updateGuestRequestListApiEvent);
    on<UpdateGuestRequestListApiEventV2>(_updateGuestRequestListApiEventV2);
  }

  FutureOr<void> _updateGuestRequestInfoEvent(
      UpdateGuestRequestInfoEvent event, Emitter<RequestPassportState> emit) {
    emit(UpdateGuestRequestInfoState(event.oldData, event.newData));
  }

  FutureOr<void> _updateGuestRequestListApiEvent(
      UpdateGuestRequestListApiEvent event,
      Emitter<RequestPassportState> emit) async {
    emit(RequestPassportLoadingState());
    emit(await requestPassportRepository.updateRequestGuestsApi(
        event.requestId, event.guestList));
  }

  FutureOr<void> _updateGuestRequestInfoEventV2(
      UpdateGuestRequestInfoEventV2 event, Emitter<RequestPassportState> emit) {
    emit(UpdateGuestRequestInfoStateV2(event.oldData, event.newData));
  }

  FutureOr<void> _updateGuestRequestListApiEventV2(
      UpdateGuestRequestListApiEventV2 event,
      Emitter<RequestPassportState> emit) async {
    emit(RequestPassportLoadingState());
    emit(await requestPassportRepository.updateRequestGuestsApiV2(
        event.requestId, event.guestList));
  }
}
