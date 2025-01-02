import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/feature/payment/bloc/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final BasePaymentRepository paymentRepository;
  PaymentBloc(this.paymentRepository) : super(PaymentInitial()) {
    on<GetPaymentUrlApiEvent>(_getPaymentUrlApiEvent);
    on<CheckPaymentUrlApiEvent>(_checkPaidStatus);
  }

  FutureOr<void> _getPaymentUrlApiEvent(
      GetPaymentUrlApiEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoadingState());
    emit(await paymentRepository.getPaymentUrlApi(event.invoiceId));
  }

  FutureOr<void> _checkPaidStatus(
      CheckPaymentUrlApiEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoadingState());
    emit(await paymentRepository.checkPayStatus(event.url));
  }
}
