import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/apis/models/ApartmentRules/apartment_rules_request.dart';
import 'package:vivas/apis/models/ApartmentRules/apartment_rules_response_model.dart';
import 'package:vivas/feature/bookings/bloc/handover_protocols_bloc.dart';

import '../../../apis/models/contract/sign_contract/sign_contract_successfully_response.dart';
import 'bookings_repository.dart';

part 'apartment_rules_event.dart';
part 'apartment_rules_state.dart';

class ApartmentRulesBloc extends Bloc<ApartmentRulesEvent, ApartmentRulesState> {
  final BaseBookingsRepository baseBookingsRepository;
  ApartmentRulesBloc(this.baseBookingsRepository) : super(ApartmentRulesInitial()) {
    on<GetApartmentRulesEvent>(getApartmentRules);
    on<SignApartmentRulesEvent>(_signContractApartmentRulesEvent);
  }

  FutureOr<void> getApartmentRules(GetApartmentRulesEvent event,
      Emitter<ApartmentRulesState> emit) async {
    emit(GetApartmentRulesLoading());
    emit(await baseBookingsRepository
        .getApartmentRules(event.apartmentRulesRequest));
  }

  FutureOr<void> _signContractApartmentRulesEvent(SignApartmentRulesEvent event,
      Emitter<ApartmentRulesState> emit) async {
    emit(SignApartmentRulesLoading());
    emit(await baseBookingsRepository.signApartmentRules(
        event.requestId, event.signID, event.signatureImagePath));
  }
}
