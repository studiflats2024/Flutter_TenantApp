part of 'credit_card_bloc.dart';

abstract class CreditCardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreditCardInitial extends CreditCardState {}

class CreditCardLoadingState extends CreditCardState {}

class CreditCardErrorState extends CreditCardState {
  final String errorMassage;
  final bool isLocalizationKey;
  CreditCardErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class CreditCardPaidSuccessfullyState extends CreditCardState {
  final String response;
  CreditCardPaidSuccessfullyState(this.response);

  @override
  List<Object?> get props => [response];
}
