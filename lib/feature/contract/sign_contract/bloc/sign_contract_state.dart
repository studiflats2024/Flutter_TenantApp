part of 'sign_contract_bloc.dart';

abstract class SignContractState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignContractInitial extends SignContractState {}

class SignContractLoadingState extends SignContractState {}

class SignContractErrorState extends SignContractState {
  final String errorMassage;
  final bool isLocalizationKey;
  SignContractErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class SignContractLoadedState extends SignContractState {
  final GetContractResponse contractResponse;
  SignContractLoadedState(this.contractResponse);

  @override
  List<Object?> get props => [contractResponse];
}

class SignContractLoadedStateV2 extends SignContractState {
  final ContractModel contractResponse;
  SignContractLoadedStateV2(this.contractResponse);

  @override
  List<Object?> get props => [contractResponse];
}

class ContractSignedSuccessfullyState extends SignContractState {
  final SignContractSuccessfullyResponse response;
  ContractSignedSuccessfullyState(this.response);

  @override
  List<Object?> get props => [response];
}

class ContractTermsAndConditionsStatusChanged extends SignContractState {
  final bool acceptTermsAndConditions;
  ContractTermsAndConditionsStatusChanged(this.acceptTermsAndConditions);

  @override
  List<Object?> get props => [acceptTermsAndConditions];
}
