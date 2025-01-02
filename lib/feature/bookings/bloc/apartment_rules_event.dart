part of 'apartment_rules_bloc.dart';

@immutable
sealed class ApartmentRulesEvent {}

class GetApartmentRulesEvent extends ApartmentRulesEvent {
  final ApartmentRulesRequest apartmentRulesRequest;

  GetApartmentRulesEvent(this.apartmentRulesRequest);
}

class SignApartmentRulesEvent extends ApartmentRulesEvent{
  final String requestId;
  final String signID;
  final String signatureImagePath;

  SignApartmentRulesEvent(this.requestId , this.signID , this.signatureImagePath);
}