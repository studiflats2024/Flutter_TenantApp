part of 'sign_contract_bloc.dart';

abstract class SignContractEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetContractEvent extends SignContractEvent {
  final String requestId;
  GetContractEvent(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class GetContractEventV2 extends SignContractEvent {
  final String requestId;
  final String apartmentId;
  final String bedId;
  GetContractEventV2(this.requestId , this.apartmentId, this.bedId);

  @override
  List<Object?> get props => [requestId, apartmentId, bedId];
}

class SignContractApiEvent extends SignContractEvent {
  final String requestId;
  final String signatureImagePath;
  SignContractApiEvent(this.requestId, this.signatureImagePath);

  @override
  List<Object?> get props => [requestId, signatureImagePath];
}

class SignContractApiEventV2 extends SignContractEvent {
  final String requestId;
  final String signID;
  final String signatureImagePath;

  SignContractApiEventV2(this.requestId, this.signID, this.signatureImagePath);

  @override
  List<Object?> get props => [requestId, signID, signatureImagePath];
}

class ChangeTermsAndConditionsStatusEvent extends SignContractEvent {
  final bool isChecked;
  ChangeTermsAndConditionsStatusEvent(this.isChecked);
  @override
  List<Object?> get props => [isChecked];
}
