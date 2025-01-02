part of 'request_details_bloc.dart';

sealed class RequestDetailsState extends Equatable {
  const RequestDetailsState();

  @override
  List<Object> get props => [];
}

final class RequestDetailsInitial extends RequestDetailsState {}

class RequestDetailLoadingState extends RequestDetailsState {}

class RequestDetailErrorState extends RequestDetailsState {
  final String errorMassage;
  final bool isLocalizationKey;

  const RequestDetailErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class RequestDetailsLoadedState extends RequestDetailsState {
  final ApartmentRequestsApiModel apartmentRequestsApiModel;

  const RequestDetailsLoadedState(this.apartmentRequestsApiModel);

  @override
  List<Object> get props => [apartmentRequestsApiModel];
}

class RequestDetailsLoadedStateV2 extends RequestDetailsState {
  final BookingDetailsModel bookingDetailsModel;

  const RequestDetailsLoadedStateV2(this.bookingDetailsModel);

  @override
  List<Object> get props => [bookingDetailsModel];
}

class UpdateRequestDatesState extends RequestDetailsState {
  const UpdateRequestDatesState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class UpdateApproveRejectOfferState extends RequestDetailsState {
  const UpdateApproveRejectOfferState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class CancelRequestSuccessfullyState extends RequestDetailsState {
  const CancelRequestSuccessfullyState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class ChangeAcceptTermsConditionState extends RequestDetailsState {
  final bool acceptTermsCondition;

  const ChangeAcceptTermsConditionState(this.acceptTermsCondition);

  @override
  List<Object> get props => [acceptTermsCondition];
}

class ChangePercentageDepositState extends RequestDetailsState {
  final int percentageDeposit;

  const ChangePercentageDepositState(this.percentageDeposit);

  @override
  List<Object> get props => [percentageDeposit];
}

class InvoiceLoadedState extends RequestDetailsState {
  final InvoiceApiModel invoiceApiModel;

  const InvoiceLoadedState(this.invoiceApiModel);

  @override
  List<Object> get props => [invoiceApiModel];
}

class InvoiceLoadedStateV2 extends RequestDetailsState {
  final InvoiceModel invoiceApiModel;

  const InvoiceLoadedStateV2(this.invoiceApiModel);

  @override
  List<Object> get props => [invoiceApiModel];
}

class InvoicePayRentLoadedStateV2 extends RequestDetailsState {
  final InvoiceRentModel invoiceApiModel;

  const InvoicePayRentLoadedStateV2(this.invoiceApiModel);

  @override
  List<Object> get props => [invoiceApiModel];
}

class CashPaymentSuccessState extends RequestDetailsState {
  const CashPaymentSuccessState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

class OnlinePaymentSuccessState extends RequestDetailsState {
  final String invoiceUrl;

  const OnlinePaymentSuccessState(this.invoiceUrl);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class ReviewSentSuccessfullyState extends RequestDetailsState {
  const ReviewSentSuccessfullyState();

  @override
  List<Object> get props => [identityHashCode(this)];
}
