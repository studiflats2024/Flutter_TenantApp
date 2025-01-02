// ignore: unused_import
import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/payment_api_manger.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/get_request_invoice_send_model.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/get_request_invoice_send_model_v2.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_rent_request.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/accept_reject_offer_model.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/cancel_request_send_model.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/update_request_date_send_model.dart';
import 'package:vivas/apis/models/checkout/review/review_send_model.dart';
import 'package:vivas/feature/request_details/request_details/bloc/request_details_bloc.dart';

abstract class BaseRequestDetailsRepository {
  Future<RequestDetailsState> getRequestDetailsApi(String uuid);

  Future<RequestDetailsState> getRequestDetailsApiV2(String uuid);

  Future<RequestDetailsState> updateRequestDateApi(
      String requestId, DateTime startDate, DateTime endDate);

  Future<RequestDetailsState> cancelRequestApi(String requestId, String guestId,
      String reason, DateTime? terminationDate);

  Future<RequestDetailsState> getRequestInvoiceApi(
      String requestId, int paidPercentage);

  Future<RequestDetailsState> getRequestInvoiceApiV2(
      String requestId, String guestId);

  Future<RequestDetailsState> getRequestInvoicePayRentApiV2(
      String requestId, List<String> tenants);

  Future<RequestDetailsState> cashPaymentApi(String invoiceId);

  Future<RequestDetailsState> cashPaymentApiV2(
      List<String> invoiceCode, bool isCash);

  Future<RequestDetailsState> approveRejectOfferApi(
      String requestId, bool status, String notes);

  Future<RequestDetailsState> sendReview(ReviewSendModel reviewSendModel);
}

class RequestDetailsRepository implements BaseRequestDetailsRepository {
  final ApartmentRequestsApiManger apartmentRequestsApiManger;
  final PaymentApiManger paymentApiManger;

  RequestDetailsRepository({
    required this.apartmentRequestsApiManger,
    required this.paymentApiManger,
  });

  @override
  Future<RequestDetailsState> getRequestDetailsApi(String uuid) async {
    late RequestDetailsState requestDetailsState;

    await apartmentRequestsApiManger.getRequestsDetailsApi(uuid,
        (apartmentRequestsApiModel) {
      requestDetailsState =
          RequestDetailsLoadedState(apartmentRequestsApiModel);
    }, (errorApiModel) {
      requestDetailsState = RequestDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return requestDetailsState;
  }

  @override
  Future<RequestDetailsState> getRequestDetailsApiV2(String uuid) async {
    late RequestDetailsState requestDetailsState;

    await apartmentRequestsApiManger.getRequestsDetailsApiV2(uuid,
        (bookingDetails) {
      requestDetailsState = RequestDetailsLoadedStateV2(bookingDetails);
    }, (errorApiModel) {
      requestDetailsState = RequestDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return requestDetailsState;
  }

  @override
  Future<RequestDetailsState> updateRequestDateApi(
      String requestId, DateTime startDate, DateTime endDate) async {
    late RequestDetailsState requestDetailsState;

    await apartmentRequestsApiManger.updateRequestDatesApi(
        UpdateRequestDateSendModel(
            requestId: requestId,
            startDate: startDate,
            endDate: endDate), (updateRequestResponse) {
      requestDetailsState = const UpdateRequestDatesState();
    }, (errorApiModel) {
      requestDetailsState = RequestDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return requestDetailsState;
  }

  @override
  Future<RequestDetailsState> approveRejectOfferApi(
      String requestId, bool status, String notes) async {
    late RequestDetailsState requestDetailsState;

    await apartmentRequestsApiManger.approveRejectOffer(
        AcceptRejectOfferSendModel(
            requestId: requestId,
            status: status,
            notes: notes), (updateRequestResponse) {
      requestDetailsState = const UpdateApproveRejectOfferState();
    }, (errorApiModel) {
      requestDetailsState = RequestDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return requestDetailsState;
  }

  @override
  Future<RequestDetailsState> cancelRequestApi(String requestId, String guestId,
      String reason, DateTime? terminationDate) async {
    late RequestDetailsState requestDetailsState;

    await apartmentRequestsApiManger.cancelRequestApi(
        CancelRequestSendModel(
            requestId: requestId,
            reason: reason,
            guestId: guestId,
            terminationDate: terminationDate), (apartmentRequestsApiModel) {
      requestDetailsState = const CancelRequestSuccessfullyState();
    }, (errorApiModel) {
      requestDetailsState = RequestDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return requestDetailsState;
  }

  @override
  Future<RequestDetailsState> getRequestInvoiceApi(
      String requestId, int paidPercentage) async {
    late RequestDetailsState requestDetailsState;

    await apartmentRequestsApiManger.getRequestInvoiceApi(
        GetRequestInvoiceSendModel(
            requestId: requestId,
            paidPercentage: paidPercentage), (invoiceApiModel) {
      requestDetailsState = InvoiceLoadedState(invoiceApiModel);
    }, (errorApiModel) {
      requestDetailsState = RequestDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return requestDetailsState;
  }

  @override
  Future<RequestDetailsState> getRequestInvoiceApiV2(
      String requestId, String guestId) async {
    late RequestDetailsState requestDetailsState;

    await apartmentRequestsApiManger.getRequestInvoiceApiV2(
        GetRequestInvoiceSendModelV2(requestId: requestId, guestId: guestId),
        (invoiceApiModel) {
      requestDetailsState = InvoiceLoadedStateV2(invoiceApiModel);
    }, (errorApiModel) {
      requestDetailsState = RequestDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return requestDetailsState;
  }

  @override
  Future<RequestDetailsState> cashPaymentApi(String invoiceId) async {
    late RequestDetailsState requestDetailsState;

    await paymentApiManger.getPaymentUrlApi(invoiceId, true, (success) {
      requestDetailsState = const CashPaymentSuccessState();
    }, (errorApiModel) {
      requestDetailsState = RequestDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return requestDetailsState;
  }

  @override
  Future<RequestDetailsState> sendReview(
      ReviewSendModel reviewSendModel) async {
    late RequestDetailsState requestDetailsState;
    await apartmentRequestsApiManger.sendReviewApi(reviewSendModel, (sucess) {
      requestDetailsState = const ReviewSentSuccessfullyState();
    }, (error) {
      requestDetailsState = RequestDetailErrorState(
          error.message, error.isMessageLocalizationKey);
    });
    return requestDetailsState;
  }

  @override
  Future<RequestDetailsState> getRequestInvoicePayRentApiV2(
      String requestId, List<String> tenants) async {
    late RequestDetailsState requestDetailsState;

    await apartmentRequestsApiManger.getRequestInvoicePayRentApiV2(
        InvoiceRentRequest(requestId, tenants), (invoiceApiModel) {
      requestDetailsState = InvoicePayRentLoadedStateV2(invoiceApiModel);
    }, (errorApiModel) {
      requestDetailsState = RequestDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return requestDetailsState;
  }

  @override
  Future<RequestDetailsState> cashPaymentApiV2(
      List<String> invoiceCode, bool isCash) async {
    late RequestDetailsState requestDetailsState;

    await paymentApiManger.getPaymentUrlApiV2(invoiceCode, isCash, (success) {
      if (isCash) {
        requestDetailsState = const CashPaymentSuccessState();
      } else {
        requestDetailsState = OnlinePaymentSuccessState(success);
      }
    }, (errorApiModel) {
      requestDetailsState = RequestDetailErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return requestDetailsState;
  }
}
