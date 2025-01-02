import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/checkout/checkoutsheet.dart';
import 'package:vivas/apis/models/checkout/post_bank_details_send_model.dart';

import 'checkout_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutDetailsBloc
    extends Bloc<CheckoutDetailsEvent, CheckoutDetailsState> {
  final BaseCheckoutRepository checkoutRepository;
  CheckoutDetailsBloc(this.checkoutRepository)
      : super(CheckoutDetailsInitial()) {
    on<GetCheckoutSheetDetailsEvent>(_getCheckoutSheetDetailsEvent);
    on<ValidateFormEvent>(_validateFormEvent);
    on<ConfirmCheckoutBankDetailsEvent>(_confirmCheckoutBankDetailsEvent);
  }

  FutureOr<void> _getCheckoutSheetDetailsEvent(
      GetCheckoutSheetDetailsEvent event,
      Emitter<CheckoutDetailsState> emit) async {
    emit(CheckoutDetailsLoadingState());
    emit(await checkoutRepository.getCheckoutSheetDetails(event.requestId));
  }

  FutureOr<void> _validateFormEvent(
      ValidateFormEvent event, Emitter<CheckoutDetailsState> emit) async {
    if (event.editFormKey.currentState?.validate() ?? false) {
      event.editFormKey.currentState?.save();
      emit(CheckoutBankDetailsFormValidatedState());
    } else {
      emit(CheckoutBankDetailsFormNotValidatedState());
    }
  }

  FutureOr<void> _confirmCheckoutBankDetailsEvent(
      ConfirmCheckoutBankDetailsEvent event, Emitter<CheckoutDetailsState> emit) async {
    emit(CheckoutDetailsLoadingState());
    emit(await checkoutRepository.confirmCheckout(event._bankDetailsSendModel));
  }
}
