part of 'credit_card_bloc.dart';

abstract class CreditCardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PayNowEvent extends CreditCardEvent {
  PayNowEvent();

  @override
  List<Object?> get props => [];
}
