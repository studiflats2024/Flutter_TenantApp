import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/contract/check_in_details/check_in_details_response.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/bloc/check_in_repository.dart';

part 'check_in_details_event.dart';
part 'check_in_state.dart';

class CheckInDetailsBloc
    extends Bloc<CheckInDetailsEvent, CheckInDetailsState> {
  final BaseCheckInDetailsRepository checkInDetailsRepository;
  CheckInDetailsBloc(this.checkInDetailsRepository)
      : super(CheckInDetailsInitial()) {
    on<GetCheckInDetailsEvent>(_getCheckInDetailsEvent);
  }

  FutureOr<void> _getCheckInDetailsEvent(
      GetCheckInDetailsEvent event, Emitter<CheckInDetailsState> emit) async {
    emit(CheckInDetailsLoadingState());
    emit(await checkInDetailsRepository.getCheckInDetails(event.requestId));
  }
}
