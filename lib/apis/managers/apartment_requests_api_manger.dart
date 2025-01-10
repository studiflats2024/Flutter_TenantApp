import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/api_keys.dart';
import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/apis/models/ApartmentRules/apartment_rules_request.dart';
import 'package:vivas/apis/models/ApartmentRules/apartment_rules_response_model.dart';
import 'package:vivas/apis/models/HandoverProtocols/handover_protocols_model.dart';
import 'package:vivas/apis/models/HandoverProtocols/handover_protocols_request.dart';
import 'package:vivas/apis/models/UploadPassportRequestModel/upload_passport_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_request_list_wrapper.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/apartment_requests_api_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/get_requests_send_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/get_requests_send_model_v2.dart';
import 'package:vivas/apis/models/apartment_requests/make_request/apartment_request_send_model_v2.dart';
import 'package:vivas/apis/models/apartment_requests/make_request/apartment_requests_send_model.dart';
import 'package:vivas/apis/models/apartment_requests/make_request/make_request_response.dart';
import 'package:vivas/apis/models/apartment_requests/make_waiting_request/waiting_request_response.dart';
import 'package:vivas/apis/models/apartment_requests/make_waiting_request/waiting_requests_send_model.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/get_request_invoice_send_model.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/get_request_invoice_send_model_v2.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_model.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_rent_model.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_rent_request.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/accept_reject_offer_model.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/accept_reject_offer_response.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/cancel_request_send_model.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/update_guests_request_response.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/update_guests_request_send_model.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/update_request_date_send_model.dart';
import 'package:vivas/apis/models/apartment_requests/update_request/update_request_response.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/apis/models/booking/booking_list_model.dart';
import 'package:vivas/apis/models/booking/change_check_out_date_model.dart';
import 'package:vivas/apis/models/booking/extend_contract_model.dart';
import 'package:vivas/apis/models/booking/qr_request_model.dart';
import 'package:vivas/apis/models/booking/selfie_request_model.dart';
import 'package:vivas/apis/models/checkout/review/review_response_model.dart';
import 'package:vivas/apis/models/checkout/review/review_send_model.dart';
import 'package:vivas/feature/arriving_details/Models/arriving_details_request_model.dart';
import 'package:flutter/material.dart';
import '../models/contract/sign_contract/sign_contract_send_model_v2.dart';
import '../models/contract/sign_contract/sign_contract_successfully_response.dart';

class ApartmentRequestsApiManger {
  final DioApiManager dioApiManager;
  final BuildContext context;

  ApartmentRequestsApiManger(this.dioApiManager, this.context);

  Future<void> createRequestsApi(
      ApartmentRequestsSendModel apartmentRequestsSendModel,
      void Function(MakeRequestResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.createRequestsUrl,
            data: apartmentRequestsSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      MakeRequestResponse wrapper = MakeRequestResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> createRequestsApiV2(
      ApartmentRequestsSendModelV2 apartmentRequestsSendModel,
      void Function(MakeRequestResponseV2) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.createRequestsV2Url,
            data: apartmentRequestsSendModel.toJson())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      MakeRequestResponseV2 wrapper =
          MakeRequestResponseV2.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getRequestsListApi(
      GetRequestsSendModel getRequestsSendModel,
      void Function(ApartmentRequestListWrapper) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getRequestsUrl,
            queryParameters: getRequestsSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ApartmentRequestListWrapper wrapper =
          ApartmentRequestListWrapper.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getRequestsListApiV2(
      GetRequestsSendModelV2 getRequestsSendModel,
      void Function(BookingListModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getBookingList,
            queryParameters: getRequestsSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      BookingListModel wrapper = BookingListModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getRequestsDetailsApi(
      String requestsId,
      void Function(ApartmentRequestsApiModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.getRequestDetailsUrl,
        queryParameters: {"Req_ID": requestsId}).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ApartmentRequestsApiModel wrapper =
          ApartmentRequestsApiModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getRequestsDetailsApiV2(
      String requestsId,
      void Function(BookingDetailsModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio.get(ApiKeys.getBookingDetails,
        queryParameters: {"Booking_ID": requestsId}).then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      BookingDetailsModel wrapper = BookingDetailsModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getRequestInvoiceApi(
      GetRequestInvoiceSendModel getRequestInvoiceSendModel,
      void Function(InvoiceApiModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getRequestInvoiceUrl,
            queryParameters: getRequestInvoiceSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      InvoiceApiModel wrapper = InvoiceApiModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getRequestInvoiceApiV2(
      GetRequestInvoiceSendModelV2 getRequestInvoiceSendModel,
      void Function(InvoiceModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(ApiKeys.getSecurityDepositInvoiceUrl,
            queryParameters: getRequestInvoiceSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      InvoiceModel wrapper = InvoiceModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getRequestInvoicePayRentApiV2(
      InvoiceRentRequest getRequestInvoiceSendModel,
      void Function(InvoiceRentModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.getNewBookingInvoices,
            queryParameters: getRequestInvoiceSendModel.toParameters(),
            data: getRequestInvoiceSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      InvoiceRentModel wrapper = InvoiceRentModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> updateRequestPassportsApi(
      UpdateGuestsRequestSendModel updateGuestsRequestSendModel,
      void Function(UpdateGuestsRequestResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .put(ApiKeys.updateRequestPassportsUrl,
            queryParameters: updateGuestsRequestSendModel.toParameters(),
            data: updateGuestsRequestSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateGuestsRequestResponse wrapper =
          UpdateGuestsRequestResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> updateRequestPassportsApiV2(
      UploadRequestModel uploadRequestModel,
      void Function() success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.sendUploadPassport,
            queryParameters: uploadRequestModel.toParameters(),
            data: uploadRequestModel.toMap())
        .then((response) async {
      // Map<String, dynamic> extractedData =
      // response.data as Map<String, dynamic>;

      success();
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> updateRequestDatesApi(
      UpdateRequestDateSendModel updateRequestDateSendModel,
      void Function(UpdateRequestResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .put(ApiKeys.updateRequestDatesUrl,
            queryParameters: updateRequestDateSendModel.toParameters())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateRequestResponse wrapper =
          UpdateRequestResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> approveRejectOffer(
      AcceptRejectOfferSendModel acceptRejectOfferSendModel,
      void Function(AcceptRejectOfferResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.approveRejectOfferUrl,
            queryParameters: acceptRejectOfferSendModel.toParameters())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      AcceptRejectOfferResponse wrapper =
          AcceptRejectOfferResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> cancelRequestApi(
      CancelRequestSendModel cancelRequestSendModel,
      void Function(UpdateRequestResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .put(
      ApiKeys.cancelRequestUrl,
      queryParameters: cancelRequestSendModel.toParameters(),
    )
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateRequestResponse wrapper =
          UpdateRequestResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> sendReviewApi(
      ReviewSendModel reviewSendModel,
      void Function(ReviewResponseModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(
      ApiKeys.addReview,
      data: reviewSendModel.toMap(),
    )
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      ReviewResponseModel wrapper = ReviewResponseModel.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> createWaitingRequestsApi(
      WaitingRequestsSendModel waitingRequestsSendModel,
      void Function(WaitingRequestResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.makeWaitingRequestUrl,
            data: waitingRequestsSendModel.toMap())
        .then((response) async {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      WaitingRequestResponse wrapper =
          WaitingRequestResponse.fromJson(extractedData);
      success(wrapper);
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> sendArrivingDetails(
      ArrivingDetailsRequestModel arrivingDetailsRequestModel,
      void Function() success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.sendArrivingDetails,
            data: arrivingDetailsRequestModel.toJson())
        .then((response) async {
      if (response.statusCode == 200) {
        success();
      } else {
        fail(ErrorApiModel.identifyError(
            error: "UnExpected Error", context: context));
      }
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> scanQrBed(QrRequestModel qrRequestModel, void Function() success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.qrScannerV2, queryParameters: qrRequestModel.toJson())
        .then((response) async {
      if (response.statusCode == 200) {
        success();
      } else {
        fail(ErrorApiModel.identifyError(
            error: "UnExpected Error", context: context));
      }
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> sendSelfieImage(SelfieRequestModel selfieRequestModel,
      void Function() success, void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.selfieImageV2,
            queryParameters: selfieRequestModel.toMap(),
            data: await selfieRequestModel.mapSignatureImage())
        .then((response) async {
      if (response.statusCode == 200) {
        success();
      } else {
        fail(ErrorApiModel.identifyError(
            error: "UnExpected Error", context: context));
      }
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getHandoverProtocols(
      HandoverProtocolsRequest handoverProtocolsRequest,
      void Function(HandoverProtocolsResponseModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(
      ApiKeys.getHandoverProtocolsV2,
      queryParameters: handoverProtocolsRequest.toMap(),
    )
        .then((response) async {
      if (response.statusCode == 200) {
        success(HandoverProtocolsResponseModel.fromJson(response.data));
      } else {
        fail(ErrorApiModel.identifyError(
            error: "UnExpected Error", context: context));
      }
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> getApartmentRules(
      ApartmentRulesRequest apartmentRulesRequest,
      void Function(ApartmentRulesResponseModel) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .get(
      ApiKeys.getApartmentRulesV2,
      queryParameters: apartmentRulesRequest.toMap(),
    )
        .then((response) async {
      if (response.statusCode == 200) {
        success(ApartmentRulesResponseModel.fromJson(response.data));
      } else {
        fail(ErrorApiModel.identifyError(
            error: "UnExpected Error", context: context));
      }
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> signHandoverProtocols(
      SignContractSendModelV2 signContractSendModel,
      void Function(SignContractSuccessfullyResponse) success,
      void Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(ApiKeys.signContractV2,
            //   queryParameters: signContractSendModel.toMap(),
            data: await signContractSendModel.mapSignatureImage())
        .then((response) async {
      if (response.statusCode == 200) {
        success(SignContractSuccessfullyResponse.fromJson(response.data));
      } else {
        fail(ErrorApiModel.identifyError(
            error: "UnExpected Error", context: context));
      }
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> extendContract(
      ExtendContractModel extendContractModel,
      Function(Map<String, dynamic>) success,
      Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(
      ApiKeys.extendContractUrl,
      queryParameters: extendContractModel.toMap(),
    )
        .then((response) async {
      if (response.statusCode == 200) {
        success(response.data);
      } else {
        fail(ErrorApiModel.identifyError(
            error: "UnExpected Error", context: context));
      }
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error, context: context));
    });
  }

  Future<void> changeCheckOutDate(
      ChangeCheckOutDateModel model,
      Function(Map<String, dynamic>) success,
      Function(ErrorApiModel) fail) async {
    await dioApiManager.dio
        .post(
      ApiKeys.changeCheckOutDate,
      queryParameters: model.toMap(),
    )
        .then((response) async {
      if (response.statusCode == 200) {
        success(response.data);
      } else {
        fail(ErrorApiModel.identifyError(
            error: "UnExpected Error", ));
      }
    }).catchError((error) {
      fail(ErrorApiModel.identifyError(error: error,));
    });
  }
}
