import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/contract/get_contract/get_contract_response.dart';
import 'package:vivas/apis/models/contract/get_contract/get_contract_response_v2.dart';
import 'package:vivas/apis/models/contract/sign_contract/sign_contract_successfully_response.dart';
import 'package:vivas/feature/contract/sign_contract/bloc/sign_contract_repository.dart';

part 'sign_contract_event.dart';

part 'sign_contract_state.dart';

class SignContractBloc extends Bloc<SignContractEvent, SignContractState> {
  final BaseSignContractRepository signContractRepository;

  SignContractBloc(this.signContractRepository) : super(SignContractInitial()) {
    on<GetContractEvent>(_getContractEvent);
    on<GetContractEventV2>(_getContractEventV2);
    on<SignContractApiEvent>(_signContractEvent);
    on<SignContractApiEventV2>(_signContractEventV2);
    on<ChangeTermsAndConditionsStatusEvent>(
        _changeTermsAndConditionsStatusEvent);
  }

  FutureOr<void> _getContractEvent(
      GetContractEvent event, Emitter<SignContractState> emit) async {
    emit(SignContractLoadingState());
    emit(await signContractRepository.getContractData(event.requestId));
  }

  FutureOr<void> _getContractEventV2(
      GetContractEventV2 event, Emitter<SignContractState> emit) async {
    emit(SignContractLoadingState());
    emit(await signContractRepository.getContractDataV2(
        event.requestId, event.apartmentId, event.bedId));
  }

  FutureOr<void> _signContractEvent(
      SignContractApiEvent event, Emitter<SignContractState> emit) async {
    emit(SignContractLoadingState());
    emit(await signContractRepository.signContract(
        event.requestId, event.signatureImagePath));
  }

  FutureOr<void> _signContractEventV2(
      SignContractApiEventV2 event, Emitter<SignContractState> emit) async {
    emit(SignContractLoadingState());
    emit(await signContractRepository.signContractV2(
        event.requestId, event.signID,event.signatureImagePath));
  }

  FutureOr<void> _changeTermsAndConditionsStatusEvent(
      ChangeTermsAndConditionsStatusEvent event,
      Emitter<SignContractState> emit) async {
    emit(ContractTermsAndConditionsStatusChanged(event.isChecked));
  }
}
