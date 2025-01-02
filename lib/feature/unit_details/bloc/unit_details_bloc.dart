import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import 'package:vivas/apis/models/apartments/apartment_details/unit_details_api_model.dart';
import 'package:vivas/apis/models/general/faq_list_wrapper.dart';
import 'package:vivas/feature/unit_details/bloc/unit_details_repository.dart';

part 'unit_details_event.dart';
part 'unit_details_state.dart';

class UnitDetailsBloc extends Bloc<UnitDetailsEvent, UnitDetailsState> {
  final BaseUnitDetailsRepository unitDetailsRepository;
  UnitDetailsBloc(this.unitDetailsRepository)
      : super(UnitDetailLoadingState()) {
    on<GetUnitDetailsApiEvent>(_getUnitDetailsApiEventV2);
    on<GetFaqApiEvent>(_getFaqApiEvent);
    on<CheckIsLoggedInEvent>(_getIsLogInEvent);
  }

  FutureOr<void> _getUnitDetailsApiEvent(
      GetUnitDetailsApiEvent event, Emitter<UnitDetailsState> emit) async {
    emit(UnitDetailLoadingState());
    emit(await unitDetailsRepository.getUnitDetailsApi(event.uuid));
  }
  FutureOr<void> _getUnitDetailsApiEventV2(
      GetUnitDetailsApiEvent event, Emitter<UnitDetailsState> emit) async {
    emit(UnitDetailLoadingState());
    UnitDetailsState unitDetailsState = await unitDetailsRepository.getUnitDetailsApiV2(event.uuid);
    emit(unitDetailsState);
  }

  FutureOr<void> _getFaqApiEvent(
      GetFaqApiEvent event, Emitter<UnitDetailsState> emit) async {
    emit(UnitDetailLoadingState());
    emit(await unitDetailsRepository.getFaqApi());
  }

  FutureOr<void> _getIsLogInEvent(
      CheckIsLoggedInEvent event, Emitter<UnitDetailsState> emit) async {
    emit(UnitDetailLoadingState());
    emit(await unitDetailsRepository.checkLoggedIn());
  }
}
