import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/invoices/bloc/invoices_repository.dart';
import 'package:vivas/feature/invoices/helper/filter_enum.dart';

part 'invoices_event.dart';
part 'invoices_state.dart';

class InvoicesBloc extends Bloc<InvoicesEvent, InvoicesState> {
  final BaseInvoicesRepository invoicesRepository;
  InvoicesBloc(this.invoicesRepository) : super(InvoicesInitial()) {
    on<GetInvoicesApiEvent>(_getInvoicesApiEvent);
    on<GetInvoiceDetailsEvent>(_getInvoiceDetailsEvent);
    on<CashPaymentApiEvent>(_cashPaymentApiEvent);
  }

  FutureOr<void> _getInvoicesApiEvent(
      GetInvoicesApiEvent event, Emitter<InvoicesState> emit) async {
    emit(InvoicesLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? InvoicesLoadingState()
          : InvoicesLoadingAsPagingState());
    }
    emit(await invoicesRepository.getInvoicesApi(
        event.pageNumber, event.filter));
  }

  Future<FutureOr<void>> _getInvoiceDetailsEvent(
      GetInvoiceDetailsEvent event, Emitter<InvoicesState> emit) async {
    emit(InvoicesLoadingState());
    emit(await invoicesRepository.getInvoiceDetailsApi(event.invoiceId));
  }

  FutureOr<void> _cashPaymentApiEvent(
      CashPaymentApiEvent event, Emitter<InvoicesState> emit) async {
    emit(InvoicesLoadingState());
    emit(await invoicesRepository.cashPaymentApi(event.invoiceId));
  }
}
