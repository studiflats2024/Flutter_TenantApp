import 'package:equatable/equatable.dart';

import 'guests_request_model.dart';

class ApartmentRequestsApiModel {
  final String requestId;
  final String requestCode;
  final String aptName;
  final String unitId;
  final String thumbImg;
  final int aptGuestsNo;
  final int aptBeds;
  final num aptSecDeposit;
  final String reqStatusKey;
  final DateTime startDate;
  final DateTime endDate;
  final String aptAddress;
  final String requestStatus;
  final num totalAmount;
  final num paid;
  final num remain;
  DateTime expireReq;
  final List<GuestsRequestModel> guestsReq;
  final int coveredPercentage;
  final int coveredRemainPercentage;
  final bool fullPaid;
  final bool createdContract;
  final bool signedContract;
  final bool checked;
  final bool rejected;
  final bool isCashed;
  final bool isOffered;
  final String rejectReason;
  final bool canPayCash;
  final bool canPayOnline;

  final NextInvoiceModel? nextInvoiceModel;

  final bool isReadyCheck;
  final bool isCheckedout;
  final bool isReviewd;
  final bool isCashDeposit;
  final bool isWaitingRefund;
  final bool isRefunded;
  final bool terminationRequest;
  final String? refundID;
  final bool isCheckoutSheetReady;
  bool get canContinue {
    /* if (rejected) {
      return true;
    } else if (!hasuploadedImg && haveInvaliPassport) {
      return true;
    } else if (hasuploadedImg && !haveInvaliPassport) {
      return true;
    } else if (fullPaid && !createdContract) {
      return false;
    } else if (isCashed && !fullPaid) {
      return false;
    } else if (isWaitingRefund) {
      return false;
    } else if (isCheckoutSheetReady) {
      return true;
    } else if (!isCheckoutSheetReady) {
      return false;
    } else if (hasuploadedImg && haveInvaliPassport) {
      debugPrint("Eslam Magdy Ramadan :$haveInvaliPassport");
      return false;
    } */

    if (rejected) {
      return true;
    } else if (hasUploadedImg && haveInvaliPassport) {
      return false;
    } else if (!hasUploadedImg && !haveInvaliPassport) {
      return false;
    } else if (fullPaid && !createdContract) {
      return false;
    } else if (isCashed && !fullPaid) {
      return false;
    } else if (isReviewd && !isCheckoutSheetReady) {
      return false;
    } else if (terminationRequest && !isReadyCheck) {
      return false;
    } /* else if (isCheckoutSheetReady && !isWaitingRefund) {
      return false;
    } */
    else if (isWaitingRefund && isCheckoutSheetReady) {
      return false;
    } /* else if (isCheckoutSheetReady == false) {
      return false;
    } */

    /* else if (checked) {
      return true;
    } */

    return reqStatusKey == "Approved";
  }

  bool get canCancel =>
      (!isReadyCheck || reqStatusKey != "Cancelled") && !terminationRequest;
  bool get canEdit => reqStatusKey == "Pending";
  bool get showPendingText => reqStatusKey == "Pending";
  bool get changeCheckIn => startDate.isAfter(DateTime.now());
  bool get haveInvalidData => guestsReq.any((element) => element.isInValidData);
  bool get haveInvaliPassport =>
      guestsReq.any((element) => element.isInvalidPassport);
  bool get hasUploadedImg => guestsReq.any((element) => element.imageUploaded);

  bool get cancelAsTermination => coveredPercentage > 1;

  ApartmentRequestsApiModel(
      {required this.requestId,
      required this.requestCode,
      required this.unitId,
      required this.aptName,
      required this.thumbImg,
      required this.aptGuestsNo,
      required this.aptBeds,
      required this.aptSecDeposit,
      required this.reqStatusKey,
      required this.paid,
      required this.remain,
      required this.expireReq,
      required this.startDate,
      required this.endDate,
      required this.aptAddress,
      required this.requestStatus,
      required this.totalAmount,
      required this.guestsReq,
      required this.coveredPercentage,
      required this.coveredRemainPercentage,
      required this.fullPaid,
      required this.createdContract,
      required this.signedContract,
      required this.checked,
      required this.nextInvoiceModel,
      required this.rejected,
      required this.rejectReason,
      required this.isCashed,
      required this.isOffered,
      required this.canPayCash,
      required this.canPayOnline,
      required this.isCashDeposit,
      required this.isCheckedout,
      required this.isReadyCheck,
      required this.isReviewd,
      required this.isWaitingRefund,
      required this.isRefunded,
      required this.refundID,
      required this.terminationRequest,
      required this.isCheckoutSheetReady});

  factory ApartmentRequestsApiModel.fromJson(Map<String, dynamic> json) =>
      ApartmentRequestsApiModel(
          requestId: json['request_ID'] as String,
          unitId: json['apt_UUID'] as String,
          requestCode: json['request_Code'] as String,
          aptName: json['apt_Name'] as String,
          thumbImg: json['thumb_Img'] as String,
          aptGuestsNo: json['apt_Guests_No'] as int,
          aptBeds: json['apt_Beds'] as int,
          aptSecDeposit: json['apt_SecDeposit'] as num,
          startDate: DateTime.parse(json['start_Date'] as String),
          endDate: DateTime.parse(json['end_Date'] as String),
          aptAddress: json['apt_Address'] as String,
          requestStatus: json['request_Status'] as String,
          totalAmount: json['total_Amount'] as num? ?? 0,
          paid: json['paid'] as num? ?? 0,
          remain: json['remain'] as num? ?? 0,
          expireReq: DateTime.parse(json['expire_Req'] as String),
          guestsReq: json['guests_Req'] != null
              ? (json['guests_Req'] as List<dynamic>)
                  .map((e) =>
                      GuestsRequestModel.fromJson(e as Map<String, dynamic>))
                  .toList()
              : [],
          reqStatusKey: json['req_Status_Key'] as String,
          coveredPercentage: (json['covered'] as num? ?? 0).toInt(),
          coveredRemainPercentage:
              (json['covered_Remain'] as num? ?? 100).toInt(),
          fullPaid: json['full_Paid'] as bool? ?? false,
          createdContract: json['createdcontract'] as bool? ?? false,
          signedContract: json['signedcontract'] as bool? ?? false,
          checked: json['checked'] as bool? ?? false,
          isCashed: json['is_cashed'] as bool? ?? false,
          isOffered: json['is_offered'] as bool? ?? false,
          rejected: json['rejected'] as bool? ?? false,
          canPayCash: json['cash'] as bool? ?? false,
          canPayOnline: json['online'] as bool? ?? false,
          isCashDeposit: json['is_Cash_Deposit'] as bool? ?? false,
          isCheckedout: json['is_Checkedout'] as bool? ?? false,
          isReadyCheck: json['is_ReadyCheck'] as bool? ?? false,
          isCheckoutSheetReady:
              json['is_Waiting_CheckoutSheet'] as bool? ?? false,
          isReviewd: json['is_Reviewd'] as bool? ?? false,
          isWaitingRefund: json['waiting_Refund'] as bool? ?? false,
          isRefunded: json['refunded'] as bool? ?? false,
          terminationRequest: json['termination_Request'] as bool? ?? false,
          refundID: json['refund_ID'] as String?,
          rejectReason: json['reject_Reason'] as String? ?? "",
          nextInvoiceModel: json['next_inv'] != null
              ? (json['next_inv'] as List<dynamic>).isNotEmpty
                  ? NextInvoiceModel.fromJson(json["next_inv"][0])
                  : null
              : null);

  Map<String, dynamic> toJson() => {
        'request_ID': requestId,
        'request_Code': requestCode,
        'apt_Name': aptName,
        'thumb_Img': thumbImg,
        'apt_Guests_No': aptGuestsNo,
        'apt_Beds': aptBeds,
        'apt_SecDeposit': aptSecDeposit,
        'start_Date': startDate.toIso8601String(),
        'end_Date': endDate.toIso8601String(),
        'apt_Address': aptAddress,
        'request_Status': requestStatus,
        'total_Amount': totalAmount,
        'paid': paid,
        'remain': remain,
        'expire_Req': expireReq.toIso8601String(),
        'guests_Req': guestsReq.map((e) => e.toJson()).toList(),
        'req_Status_Key': reqStatusKey,
        'online': canPayOnline,
        'cash': canPayCash,
        'is_Cash_Deposit': isCashDeposit,
        'is_Checkedout': isCheckedout,
        'is_ReadyCheck': isReadyCheck,
        'is_Reviewd': isReviewd,
        'waiting_Refund': isWaitingRefund,
        'refunded': isRefunded,
        'refund_ID': refundID,
        'is_Waiting_CheckoutSheet': isCheckoutSheetReady
      };
}

// ignore: must_be_immutable
class NextInvoiceModel extends Equatable {
  String monthInvID;
  DateTime invDate;
  double invTotal;
  bool isCashed;

  NextInvoiceModel(
      {required this.monthInvID,
      required this.invDate,
      required this.invTotal,
      required this.isCashed});

  factory NextInvoiceModel.fromJson(Map<String, dynamic> json) =>
      NextInvoiceModel(
          monthInvID: json['month_Inv_ID'] as String,
          invDate: DateTime.parse(json['inv_Date'] as String),
          invTotal: (json['inv_Total'] as num).toDouble(),
          isCashed: (json['isCashed'] as bool));

  @override
  List<Object> get props => [monthInvID, invDate, invTotal, isCashed];
}
