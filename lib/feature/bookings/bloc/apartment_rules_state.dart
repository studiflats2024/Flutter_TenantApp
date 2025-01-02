part of 'apartment_rules_bloc.dart';

@immutable
sealed class ApartmentRulesState {}

final class ApartmentRulesInitial extends ApartmentRulesState {}

final class GetApartmentRulesLoading extends ApartmentRulesState {}

final class GetApartmentRulesSuccess extends ApartmentRulesState {
  final ApartmentRulesResponseModel model;
  GetApartmentRulesSuccess(this.model);
}

final class GetApartmentRulesException extends ApartmentRulesState {
  final String message;
  final bool isLocalizationKey;
  GetApartmentRulesException(this.message , this.isLocalizationKey);
}

final class SignApartmentRulesLoading extends ApartmentRulesState {}

final class SignApartmentRulesSuccess extends ApartmentRulesState {
  final SignContractSuccessfullyResponse response;

  SignApartmentRulesSuccess(this.response);
}


final class SignApartmentRulesException extends ApartmentRulesState {
  final String message;
  final bool isLocalizationKey;
  SignApartmentRulesException(this.message , this.isLocalizationKey);
}