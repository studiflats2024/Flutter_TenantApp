part of 'request_details_bloc.dart';

sealed class RequestDetailsEvent extends Equatable {
  const RequestDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetRequestDetailsApiEvent extends RequestDetailsEvent {
  final String uuid;
  const GetRequestDetailsApiEvent(this.uuid);

  @override
  List<Object> get props => [uuid];
}

class ChangeAcceptTermsConditionEvent extends RequestDetailsEvent {
  final bool acceptTermsCondition;
  const ChangeAcceptTermsConditionEvent(this.acceptTermsCondition);

  @override
  List<Object> get props => [acceptTermsCondition];
}

class ChangePercentageDepositEvent extends RequestDetailsEvent {
  final int percentageDeposit;
  const ChangePercentageDepositEvent(this.percentageDeposit);

  @override
  List<Object> get props => [percentageDeposit];
}

class ChangeDateRequestApiEvent extends RequestDetailsEvent {
  final String requestId;
  final DateTime checkIn;
  final DateTime checkOut;
  const ChangeDateRequestApiEvent(this.requestId, this.checkIn, this.checkOut);

  @override
  List<Object> get props => [requestId, checkIn, checkOut];
}

class CancelRequestApiEvent extends RequestDetailsEvent {
  final String requestId;
  final String? guestId;
  final String reason;
  final DateTime? terminationDate;

  const CancelRequestApiEvent(
    this.requestId,
    this.reason,
    this.terminationDate,{this.guestId}
  );

  @override
  List<Object> get props => [requestId, reason];
}

class ApproveRejectOfferApiEvent extends RequestDetailsEvent {
  final String requestId;
  final bool status;
  final String? notes;

  const ApproveRejectOfferApiEvent(
    this.requestId,
    this.status,
    this.notes,
  );

  @override
  List<Object> get props => [requestId, status, notes!];
}

class GetInvoiceApiEvent extends RequestDetailsEvent {
  final String requestId;
  final int paidPercentage;
  const GetInvoiceApiEvent(this.requestId, this.paidPercentage);

  @override
  List<Object> get props => [requestId, paidPercentage];
}

class GetInvoiceApiEventV2 extends RequestDetailsEvent {
final String requestId;
final String guestId;

const GetInvoiceApiEventV2(this.requestId, this.guestId);

@override
List<Object> get props => [requestId, guestId];
}

class GetInvoicePayRentApiEventV2 extends RequestDetailsEvent {
  final String requestId;
  final List<String> tenants;

  const GetInvoicePayRentApiEventV2(this.requestId, this.tenants);

  @override
  List<Object> get props => [requestId, tenants];
}

class CashPaymentApiEvent extends RequestDetailsEvent {
  final String invoiceId;

  const CashPaymentApiEvent(this.invoiceId);

  @override
  List<Object> get props => [invoiceId];
}
class CashPaymentApiEventV2 extends RequestDetailsEvent {
  final List<String> invoiceId;
  final bool isCash;

  const CashPaymentApiEventV2(this.invoiceId , this.isCash);

  @override
  List<Object> get props => [invoiceId , isCash];
}


class SendReviewApiEvent extends RequestDetailsEvent {
  final ReviewSendModel _reviewSendModel;
  const SendReviewApiEvent(this._reviewSendModel);

  @override
  List<Object> get props => [_reviewSendModel];
}
