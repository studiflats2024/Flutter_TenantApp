part of 'invoices_bloc.dart';

sealed class InvoicesState extends Equatable {
  const InvoicesState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class InvoicesInitial extends InvoicesState {}

class InvoicesLoadingAsPagingState extends InvoicesState {}

class InvoicesLoadingState extends InvoicesState {}

class InvoicesErrorState extends InvoicesState {
  final String errorMassage;
  final bool isLocalizationKey;
  const InvoicesErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class InvoicesLoadedState extends InvoicesState {
  final List<InvoiceApiModel> list;
  final MetaModel pagingInfo;

  const InvoicesLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list, pagingInfo];
}

class InvoiceDetailsLoadedState extends InvoicesState {
  final InvoiceApiModel invoiceApiModel;

  const InvoiceDetailsLoadedState(this.invoiceApiModel);
  @override
  List<Object> get props => [invoiceApiModel];
}

class CashPaymentSuccessState extends InvoicesState {
  const CashPaymentSuccessState();
  @override
  List<Object> get props => [identityHashCode(this)];
}
