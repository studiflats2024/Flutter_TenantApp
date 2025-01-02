import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/apis/models/HandoverProtocols/handover_protocols_model.dart';
import 'package:vivas/apis/models/HandoverProtocols/handover_protocols_request.dart';
import 'package:vivas/apis/models/booking/handover_protocols_model.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';

import '../../../apis/models/contract/sign_contract/sign_contract_successfully_response.dart';

part 'handover_protocols_event.dart';

part 'handover_protocols_state.dart';

class HandoverProtocolsBloc
    extends Bloc<HandoverProtocolsEvent, HandoverProtocolsState> {
  final BaseBookingsRepository baseBookingsRepository;

  HandoverProtocolsBloc(this.baseBookingsRepository)
      : super(HandoverProtocolsInitial()) {
    on<GetHandoverProtocolsEvent>(getHandoverProtocols);
    on<SignHandoverProtocolsEvent>(_signContractHandoverProtocolsEvent);
  }

  FutureOr<void> getHandoverProtocols(GetHandoverProtocolsEvent event,
      Emitter<HandoverProtocolsState> emit) async {
    emit(GetHandoverProtocolsLoading());
    emit(await baseBookingsRepository
        .getHandoverProtocols(event.handoverProtocolsRequest));
  }

  FutureOr<void> _signContractHandoverProtocolsEvent(SignHandoverProtocolsEvent event,
      Emitter<HandoverProtocolsState> emit) async {
    emit(SignHandoverProtocolsLoading());
    emit(await baseBookingsRepository.signHandoverProtocols(
        event.requestId, event.signID, event.signatureImagePath));
  }
}
