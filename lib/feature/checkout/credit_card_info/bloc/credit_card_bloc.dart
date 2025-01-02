import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'credit_card_repository.dart';

part 'credit_card_event.dart';
part 'credit_card_state.dart';

class CreditCardBloc extends Bloc<CreditCardEvent, CreditCardState> {
  final BaseCreditCardRepository creditCardRepository;
  CreditCardBloc(this.creditCardRepository) : super(CreditCardInitial()) {
    on<PayNowEvent>(_payNowEvent);
  }

  FutureOr<void> _payNowEvent(
      PayNowEvent event, Emitter<CreditCardState> emit) async {
    emit(CreditCardLoadingState());
    emit(await creditCardRepository.payByCreditOrDebitCard());
  }
}
