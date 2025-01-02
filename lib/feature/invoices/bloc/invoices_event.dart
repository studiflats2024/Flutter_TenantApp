part of 'invoices_bloc.dart';

sealed class InvoicesEvent extends Equatable {
  const InvoicesEvent();

  @override
  List<Object> get props => [];
}

class GetInvoicesApiEvent extends InvoicesEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  final InvoicesFilter filter;
  const GetInvoicesApiEvent(
      this.pageNumber, this.isSwipeToRefresh, this.filter);

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}

class GetInvoiceDetailsEvent extends InvoicesEvent {
  final String invoiceId;
  const GetInvoiceDetailsEvent(this.invoiceId);

  @override
  List<Object> get props => [invoiceId];
}

class CashPaymentApiEvent extends InvoicesEvent {
  final String invoiceId;

  const CashPaymentApiEvent(this.invoiceId);

  @override
  List<Object> get props => [invoiceId];
}
