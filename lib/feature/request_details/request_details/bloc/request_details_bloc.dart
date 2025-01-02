import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_rent_model.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/apis/models/checkout/review/review_send_model.dart';
import 'package:vivas/feature/request_details/request_details/bloc/unit_details_repository.dart';

import '../../../../apis/models/apartment_requests/request_invoice/invoice_model.dart';

part 'request_details_event.dart';

part 'request_details_state.dart';

class RequestDetailsBloc
    extends Bloc<RequestDetailsEvent, RequestDetailsState> {
  final BaseRequestDetailsRepository requestDetailsRepository;

  RequestDetailsBloc(this.requestDetailsRepository)
      : super(RequestDetailsInitial()) {
    // on<GetRequestDetailsApiEvent>(_getRequestDetailsApiEvent);
    on<GetRequestDetailsApiEvent>(_getRequestDetailsApiEventV2);
    on<ChangeDateRequestApiEvent>(_changeDateRequestApiEvent);
    on<CancelRequestApiEvent>(_cancelRequestApiEvent);
    on<ChangeAcceptTermsConditionEvent>(_changeAcceptTermsConditionEvent);
    on<ChangePercentageDepositEvent>(_changePercentageDepositEvent);
    on<GetInvoiceApiEvent>(_getInvoiceApiEvent);
    on<GetInvoiceApiEventV2>(_getInvoiceApiEventV2);
    on<GetInvoicePayRentApiEventV2>(_getInvoicePayRentApiEventV2);
    on<CashPaymentApiEvent>(_cashPaymentApiEvent);
    on<CashPaymentApiEventV2>(_cashPaymentApiEventV2);
    on<ApproveRejectOfferApiEvent>(_approveRejectOfferApiEvent);
    on<SendReviewApiEvent>(_sendReviewApiEvent);
  }

  FutureOr<void> _getRequestDetailsApiEvent(GetRequestDetailsApiEvent event,
      Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.getRequestDetailsApi(event.uuid));
  }

  FutureOr<void> _getRequestDetailsApiEventV2(GetRequestDetailsApiEvent event,
      Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.getRequestDetailsApiV2(event.uuid));
  }

  FutureOr<void> _changeDateRequestApiEvent(ChangeDateRequestApiEvent event,
      Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.updateRequestDateApi(
        event.requestId, event.checkIn, event.checkOut));
  }

  FutureOr<void> _approveRejectOfferApiEvent(ApproveRejectOfferApiEvent event,
      Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.approveRejectOfferApi(
        event.requestId, event.status, event.notes!));
  }

  FutureOr<void> _cancelRequestApiEvent(
      CancelRequestApiEvent event, Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.cancelRequestApi(event.requestId,
        event.guestId ?? "", event.reason, event.terminationDate));
  }

  FutureOr<void> _changeAcceptTermsConditionEvent(
      ChangeAcceptTermsConditionEvent event,
      Emitter<RequestDetailsState> emit) {
    emit(ChangeAcceptTermsConditionState(event.acceptTermsCondition));
  }

  FutureOr<void> _changePercentageDepositEvent(
      ChangePercentageDepositEvent event, Emitter<RequestDetailsState> emit) {
    emit(ChangePercentageDepositState(event.percentageDeposit));
  }

  FutureOr<void> _getInvoiceApiEvent(
      GetInvoiceApiEvent event, Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.getRequestInvoiceApi(
        event.requestId, event.paidPercentage));
  }

  FutureOr<void> _getInvoiceApiEventV2(
      GetInvoiceApiEventV2 event, Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.getRequestInvoiceApiV2(
        event.requestId, event.guestId));
  }

  FutureOr<void> _getInvoicePayRentApiEventV2(GetInvoicePayRentApiEventV2 event,
      Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.getRequestInvoicePayRentApiV2(
        event.requestId, event.tenants));
  }

  FutureOr<void> _cashPaymentApiEvent(
      CashPaymentApiEvent event, Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.cashPaymentApi(event.invoiceId));
  }

  FutureOr<void> _cashPaymentApiEventV2(
      CashPaymentApiEventV2 event, Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.cashPaymentApiV2(
        event.invoiceId, event.isCash));
  }

  FutureOr<void> _sendReviewApiEvent(
      SendReviewApiEvent event, Emitter<RequestDetailsState> emit) async {
    emit(RequestDetailLoadingState());
    emit(await requestDetailsRepository.sendReview(event._reviewSendModel));
  }
}
