// To parse this JSON data, do
//
//     final bookingDetailsModel = bookingDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:dartz/dartz_unsafe.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:vivas/apis/models/contract/check_in_details/check_in_details_response.dart';
import 'package:vivas/utils/format/app_date_format.dart';

import '../../../preferences/preferences_manager.dart';

BookingDetailsModel bookingDetailsModelFromJson(String str) =>
    BookingDetailsModel.fromJson(json.decode(str));

String bookingDetailsModelToJson(BookingDetailsModel data) =>
    json.encode(data.toJson());

class BookingDetailsModel {
  String? bookingId;
  String? apartmentId;
  String? bookingStatus;
  String? uuid;
  String? bedId;
  String? roomId;
  String? checkIn;
  String? checkOut;
  String? apartmentCode;
  String? apartmentName;
  String? apartmentLocation;
  String? apartmentMapLink;
  String? apartmentShareStatus;
  String? apartmentPicture;
  String? bookingCode;
  String? rejectReason;
  List<Guest>? guests;
  bool? fullBooking;
  int? payOption;
  int? bookingGuestsNo;
  bool? hasExtendRequest;
  bool? isOffered;
  double? fullRent;
  double? fullService;
  double? fullSecurity;

  CheckInDetailsResponse? checkInDetailsResponse;

  BookingDetailsModel(
      {this.bookingId,
      this.apartmentId,
      this.bookingStatus,
      this.bedId,
      this.roomId,
      this.checkIn,
      this.checkOut,
      this.apartmentCode,
      this.apartmentName,
      this.apartmentLocation,
      this.apartmentMapLink,
      this.apartmentShareStatus,
      this.checkInDetailsResponse,
      this.apartmentPicture,
      this.bookingCode,
      this.rejectReason,
      this.guests,
      this.fullBooking,
      this.bookingGuestsNo,
      this.isOffered,
      this.hasExtendRequest,
      this.fullRent,
      this.fullSecurity,
      this.fullService});

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) =>
      BookingDetailsModel(
        bookingId: json["booking_ID"],
        apartmentId: json["apartment_ID"],
        bookingStatus: json["booking_Status"],
        bedId: json["bed_ID"],
        roomId: json["room_ID"],
        checkIn: json["check_In"],
        checkOut: json["check_Out"],
        apartmentCode: json["apartment_Code"],
        apartmentName: json["apartment_Name"],
        apartmentLocation: json["apartment_Location"],
        apartmentMapLink: json["apartment_MapLink"],
        apartmentShareStatus: json["apartment_Share_Status"],
        apartmentPicture: json["apartment_Picture"],
        bookingCode: json["booking_Code"],
        rejectReason: json["reject_Reason"],
        guests: json["guests"] == null
            ? []
            : List<Guest>.from(json["guests"]!.map((x) => Guest.fromJson(x))),
        checkInDetailsResponse:
            CheckInDetailsResponse.fromJson(json["checkin_Details"]),
        fullBooking: json["full_Booking"] ?? false,
        bookingGuestsNo: json["booking_Guests_No"] ?? 0,
        isOffered: json["is_Offered"] ?? false,
        hasExtendRequest: json["has_Extend_Request"] ?? false,
        fullRent: json["full_Rent"],
        fullService: json["full_Service"],
        fullSecurity: json["full_Secuirty"],
      );

  Map<String, dynamic> toJson() => {
        "booking_ID": bookingId,
        "apartment_ID": apartmentId,
        "booking_Status": bookingStatus,
        "bed_ID": bedId,
        "room_ID": roomId,
        "check_In": checkIn,
        "check_Out": checkOut,
        "apartment_Code": apartmentCode,
        "apartment_Name": apartmentName,
        "apartment_Location": apartmentLocation,
        "apartment_MapLink": apartmentMapLink,
        "apartment_Share_Status": apartmentShareStatus,
        "apartment_Picture": apartmentPicture,
        "booking_Code": bookingCode,
        "reject_Reason": rejectReason,
        "guests": guests == null
            ? []
            : List<dynamic>.from(guests!.map((x) => x.toJson())),
        "is_Offered": isOffered,
      };

  int get guestIndex {
    // return guests!.indexWhere((element) => element.guestId! == uuid);
    return 0;
  }

  bool get canSeeExtend {
    if (canResumeBookingAsMainTenant &&
        canResumeBookingProcess &&
        rentalRulesSigned) {
      if (haveExtend) {
        return true;
      } else {
        Duration difference =
            AppDateFormat.appDateFormApiParse(bookingCheckOut ?? "")
                .difference(DateTime.now());
        if (difference.inDays > 31) {
          return false;
        } else {
          return true;
        }
      }
    } else {
      return false;
    }
  }

  bool get canChangeCheckout {
    if (canResumeBookingAsMainTenant &&
        canResumeBookingProcess &&
        rentalRulesSigned) {
      Duration difference =
          AppDateFormat.appDateFormApiParse(bookingCheckOut ?? "")
              .difference(DateTime.now());
      if (difference.inDays > 31) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  bool get isSingleGuest {
    return (guests?.isNotEmpty ?? false) && guests!.length == 1 ? true : false;
  }

  bool get isTwoGuest {
    return (guests?.isNotEmpty ?? false) && guests!.length == 2 ? true : false;
  }

  bool get needToUploadPassport {
    bool uploadPassport = false;
    for (int x = 0; x < (guests?.length ?? 0); x++) {
      if (guests![x].passportStatus == "Uploading") {
        uploadPassport = true;
        break;
      }
    }
    return uploadPassport;
  }

  bool get haveRejectPassport {
    bool uploadPassport = false;
    for (int x = 0; x < (guests?.length ?? 0); x++) {
      if (guests![x].passportStatus == "Rejected") {
        uploadPassport = true;
        break;
      }
    }
    return uploadPassport;
  }

  bool get haveMonthlyInvoice {
    return (guests?.isNotEmpty ?? false) &&
        guests?[guestIndex].monthlyInvoice != null;
  }

  bool get passportInReview {
    bool passportInReview = false;
    for (int x = 0; x < (guests?.length ?? 0); x++) {
      if (guests![x].passportStatus == "InReview") {
        passportInReview = true;
        break;
      }
    }
    return passportInReview;
  }

  bool get paidSecurityDeposit {
    if ((guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].hasInvoiceSecurityPaid ?? false)) {
      if ((guests?[guestIndex].secuirtyPaid ?? false) &&
          !(guests?[guestIndex].payLater ?? false)) {
        return true;
      } else if (!(guests?[guestIndex].secuirtyPaid ?? false) &&
          (guests?[guestIndex].payLater ?? false)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool get signContract {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].contractSigned ?? false);
  }

  bool get goToArrivingDetails {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].hasArrived ?? false);
  }

  bool get scannedQR {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].qRScanned ?? false);
  }

  bool get isSelfie {
    return (guests?.isNotEmpty ?? false) &&
        guests?[guestIndex].identityStatus != "Rejected" && guests?[guestIndex].identityStatus != "Approved";
  }

  bool get paidRent {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].hasRent ?? false) &&
        (guests?[guestIndex].payRent ?? false);
  }

  bool get handOverSigned {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].handoverSigned ?? false);
  }

  bool get rentalRulesSigned {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].rentalRulesSigned ?? false);
  }

  bool get canContinue {
    return (guests?.isNotEmpty ?? false) && canResumeBookingProcess;
  }

  bool get canCancel =>
      bookingStatus != "Cancelled" &&
      bookingStatus != "Rejected" &&
      !paidSecurityDeposit;

  bool get canEdit => bookingStatus == "Pending";

  bool get bookingCancelledOrRejected =>
      bookingStatus == "Cancelled" || bookingStatus == "Rejected";

  bool get canResumeBookingProcess => bookingStatus == "Approved";

  double get totalGuestsPaid {
    double total = 0.0;
    for (int i = 0; i < guests!.length; i++) {
      if ((guests![i].payRent ?? false) && (guests![i].secuirtyPaid ?? false)) {
      } else {
        total += guests![i].totalGuestPaid;
      }
    }
    return total;
  }

  double get subTotalGuestsPaid {
    double total = 0.0;
    if (payOption == 0) {
      total += guests![guestIndex].totalGuestPaid;
    } else if (payOption == 1) {
      total += totalGuestsPaid;
    } else {
      for (int i = 0; i < guests!.length; i++) {
        if (guests![i].isSelected) {
          total += guests![i].totalGuestPaid;
        }
      }
    }

    return total;
  }

  bool get allTenantsSelected {
    bool selectedAllTenant = true;
    for (int x = 0; x < guests!.length; x++) {
      if (!guests![x].isSelected) {
        selectedAllTenant = false;
        break;
      }
    }
    return selectedAllTenant;
  }

  List<String> get tenantsSelected {
    List<String> tenants = [];
    if (isSingleGuest) {
      tenants.add(guests![0].guestId ?? "");
    } else if ((fullBooking ?? false) && bookingGuestsNo == guests!.length) {
      for (var tenant in guests!) {
        tenants.add(tenant.guestId!);
      }
    } else {
      if (payOption == 0) {
        tenants.add(guests![guestIndex].guestId!);
      } else if (payOption == 1) {
        for (var tenant in guests!) {
          tenants.add(tenant.guestId!);
        }
      } else {
        for (var tenant in guests!) {
          if (tenant.isSelected) {
            tenants.add(tenant.guestId!);
          }
        }
      }
    }
    return tenants;
  }

  List<String> get tenantsMonthlyInvoicesSelected {
    List<String> tenants = [];
    if ((fullBooking ?? false) && bookingGuestsNo == guests!.length) {
      for (var tenant in guests!) {
        tenants.add(tenant.guestId!);
      }
    } else {
      tenants.add(guests![guestIndex].guestId!);
    }
    return tenants;
  }

  bool get readyToPaySecurityDeposit {
    return canResumeBookingProcess &&
        !paidSecurityDeposit &&
        canResumeBookingAsMainTenant;
  }

  bool get readyToSignContract {
    return canResumeBookingProcess &&
        !signContract &&
        canResumeBookingAsMainTenant;
  }

  bool get putArrivingDetails {
    return (canResumeBookingProcess ?? false) &&
        !(goToArrivingDetails ?? false);
  }

  bool get waitingForCheckIn {
    return canResumeBookingProcess &&
        goToArrivingDetails &&
        DateFormat("MM/dd/yyyy").parse(checkIn ?? "").isAfter(DateTime.now());
  }

  bool get readyForCheckIn {
    return canResumeBookingProcess &&
        (goToArrivingDetails ?? false) &&
        !DateFormat("MM/dd/yyyy")
            .parse(checkIn ?? "")
            .isAfter(DateTime.now()) &&
        !scannedQR;
  }

  bool get continueForCheckIn {
    return canResumeBookingProcess &&
        (goToArrivingDetails ?? false) &&
        !DateFormat("MM/dd/yyyy")
            .parse(checkIn ?? "")
            .isAfter(DateTime.now()) &&
        scannedQR;
  }

  bool get readyToVerifyIdentity {
    return continueForCheckIn && !isSelfie;
  }

  bool get shouldPayRent {
    return monthlyInvoiceIsCash
        ? false
        : continueForCheckIn && !paidRent && canResumeBookingAsMainTenant;
  }

  bool get readyToSignHandOver {
    return continueForCheckIn &&
        !handOverSigned &&
        canResumeBookingAsMainTenant;
  }

  bool get readyToSignApartmentRules {
    return continueForCheckIn &&
        !rentalRulesSigned &&
        canResumeBookingAsMainTenant;
  }

  MonthlyInvoice? get getMonthlyInvoice {
    return (guests?.isNotEmpty ?? false)
        ? (guests?[guestIndex].monthlyInvoice)
        : null;
  }

  bool get monthlyInvoiceIsCash {
    return getMonthlyInvoice != null &&
        (getMonthlyInvoice!.isCashed ?? false) &&
        DateFormat("MM/dd/yyyy").parse(checkIn ?? "").month ==
            DateTime.now().month &&
        canResumeBookingAsMainTenant;
  }

  bool get waitingToConfirmPayRent {
    return !paidRent && handOverSigned && canResumeBookingAsMainTenant;
  }

  bool get canResumeBookingAsMainTenant {
    if ((guests?.isNotEmpty ?? false) && (fullBooking ?? false)) {
      return bookingGuestsNo == guests!.length;
    } else {
      return true;
    }
  }

  bool get guestNeedToUploadProfileImage {
    return (guests?.isNotEmpty ?? false) &&
        !(guests?[guestIndex].guestImageUploaded ?? true);
  }

  bool get readyToCheckout {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].isReadyCheck ?? false);
  }

  bool get isCheckedOut {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].isCheckedout ?? false);
  }

  bool get isReviewed {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].isReviewd ?? false);
  }

  bool get refunded {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].isRefunded ?? false);
  }

  bool get waitingToRefunded {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].isWaitingRefund ?? false);
  }

  bool get checkOutSheetIsReady {
    return (guests?.isNotEmpty ?? false) &&
        !(guests?[guestIndex].isCheckoutSheetReady ?? false);
  }

  bool get cashDeposit {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].isCashDeposit ?? false);
  }

  bool get haveExtend {
    return (guests?.isNotEmpty ?? false) &&
        (guests?[guestIndex].extendID != "00000000-0000-0000-0000-000000000000");
  }

  bool get extendAccepted {
    return (guests?[guestIndex].extendingStatus == "Approved");
  }

  bool get extendReadyForSign {
    return extendAccepted &&
        !(guests?[guestIndex].extendContractSigned ?? true);
  }

  String get extendStatus {
    return (guests?[guestIndex].extendingStatus ?? "");
  }

  String? get bookingCheckOut {
    if (haveExtend &&
        extendAccepted &&
        (guests?[guestIndex].extendContractSigned ?? false)) {
      return guests?[guestIndex].extendedTo;
    } else {
      return checkOut;
    }
  }
}

class Guest {
  String? bedId;
  String? roomId;
  String? guestId;
  String? guestName;
  String? bedName;
  String? roomType;
  String? roomName;
  double? bedPrice;
  double? securityDeposit;
  double? serviceFee;
  String? qRCode;
  String? qrCodeImg;
  String? passportStatus;
  String? guestPassport;
  String? guestImageProfile;
  bool? secuirtyPaid;
  bool? payLater;
  bool? hasInvoiceSecurityPaid;
  bool? qRScanned;
  bool? guestImageUploaded;
  String? identityStatus;
  bool? hasArrived;
  bool? contractSigned;
  bool? enterArrivingDetails;
  bool? rentalRulesSigned;
  bool? handoverSigned;
  String? passportRejectReason;
  bool isSelected;
  bool? hasRent;
  bool? payRent;
  MonthlyInvoice? monthlyInvoice;
  final bool? isReadyCheck;
  final bool? isCheckedout;
  final bool? isReviewd;
  final bool? isCashDeposit;
  final bool? isWaitingRefund;
  final bool? isRefunded;
  final String? refundID;
  final String? extendingStatus;
  final String? extendID;
  final String? extendingRejectReason;
  final String? extendContract;
  final String? extendContractSignature;
  final String? extendContractSignedAt;
  final String? extendedFrom;
  final String? extendedTo;
  final bool? extendContractSigned;
  final bool? isCheckoutSheetReady;
  final String? checkoutDate;

  /*


  "guest_Image_Profile": "string",
      "guest_Image_Uploaded": true,
   */
  Guest(
      {this.bedId,
      this.roomId,
      this.guestId,
      this.guestName,
      this.bedName,
      this.roomType,
      this.roomName,
      this.bedPrice,
      this.securityDeposit,
      this.serviceFee,
      this.qRCode,
      this.qrCodeImg,
      this.passportStatus,
      this.guestPassport,
      this.secuirtyPaid,
      this.payLater,
      this.hasInvoiceSecurityPaid,
      this.qRScanned,
      this.identityStatus,
      this.hasArrived,
      this.contractSigned,
      this.enterArrivingDetails,
      this.rentalRulesSigned,
      this.handoverSigned,
      this.passportRejectReason,
      this.payRent,
      this.hasRent,
      this.monthlyInvoice,
      this.guestImageProfile,
      this.guestImageUploaded,
      this.isReadyCheck,
      this.isCheckedout,
      this.isReviewd,
      this.isCashDeposit,
      this.isWaitingRefund,
      this.isRefunded,
      this.refundID,
      this.isCheckoutSheetReady,
      this.checkoutDate,
      this.extendingStatus,
      this.extendingRejectReason,
      this.extendID,
      this.extendContract,
      this.extendContractSignature,
      this.extendContractSigned,
      this.extendContractSignedAt,
      this.extendedFrom,
      this.extendedTo,
      this.isSelected = false});

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
        bedId: json["bed_ID"],
        roomId: json["room_ID"],
        guestId: json["guest_ID"],
        guestName: json["guest_Name"],
        bedName: json["bed_Name"],
        roomType: json["room_Type"],
        roomName: json["room_Name"],
        bedPrice: json["bed_Price"] is int
            ? json["bed_Price"].toDouble()
            : json["bed_Price"],
        securityDeposit: json["secuirty_Deposit"] is int
            ? json["secuirty_Deposit"].toDouble()
            : json["secuirty_Deposit"],
        serviceFee: json["service_Fee"] is int
            ? json["service_Fee"].toDouble()
            : json["service_Fee"],
        qRCode: json["qR_Code"],
        qrCodeImg: json["qr_Code_Img"],
        passportStatus: json["passport_Status"],
        guestPassport: json["guest_Passport"],
        secuirtyPaid: json["secuirty_Paid"],
        payLater: json["pay_Later"],
        hasInvoiceSecurityPaid: json["has_Secuirty_Invoice"],
        qRScanned: json["qR_Scanned"],
        identityStatus: json["identity_Status"],
        hasArrived: json["has_Arrived"],
        contractSigned: json["contract_Signed"],
        enterArrivingDetails: json["enter_ArrivingDetails"] ?? true,
        rentalRulesSigned: json["rental_Rules_Signed"],
        handoverSigned: json["handover_Signed"],
        passportRejectReason: json["passport_Reject_Reason"],
        hasRent: json["hasRent"],
        payRent: json["payRent"],
        monthlyInvoice: json["monthly_Invoice"] == null
            ? null
            : MonthlyInvoice.fromJson(json["monthly_Invoice"]),
        guestImageProfile: json["guest_Image_Profile"],
        guestImageUploaded: json["guest_Image_Uploaded"],
        isCashDeposit: json['is_Cash_Deposit'] as bool? ?? false,
        isCheckedout: json['is_Checkedout'] as bool? ?? false,
        isReadyCheck: json['is_ReadyCheck'] as bool? ?? false,
        isCheckoutSheetReady:
            json['is_Waiting_CheckoutSheet'] as bool? ?? false,
        isReviewd: json['is_Reviewd'] as bool? ?? false,
        isWaitingRefund: json['waiting_Refund'] as bool? ?? false,
        isRefunded: json['refunded'] as bool? ?? false,
        refundID: json['refund_ID'] as String?,
        checkoutDate: json['checkout_Date'] as String?,
        extendingStatus: json['extending_Status'] as String?,
        extendID: json['extend_ID'] as String?,
        extendingRejectReason: json['extending_Reject_Reason'] as String?,
        extendContract: json['extend_Contract'] as String?,
        extendContractSignature: json['extend_Contract_Signature'] as String?,
        extendContractSignedAt: json['extend_Contract_Signed_At'] as String?,
        extendContractSigned: json['extend_Contract_Signed'] as bool?,
        extendedFrom: json['extended_From'] as String?,
        extendedTo: json['extended_To'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "bed_ID": bedId,
        "room_ID": roomId,
        "guest_ID": guestId,
        "guest_Name": guestName,
        "bed_Name": bedName,
        "room_Type": roomType,
        "room_Name": roomName,
        "bed_Price": bedPrice,
        "secuirty_Deposit": securityDeposit,
        "service_Fee": serviceFee,
        "qR_Code": qRCode,
        "qr_Code_Img": qrCodeImg,
        "passport_Status": passportStatus,
        "secuirty_Paid": secuirtyPaid,
        "pay_Later": payLater,
        "has_Secuirty_Invoice": hasInvoiceSecurityPaid,
        "qR_Scanned": qRScanned,
        "identity_Status": identityStatus,
        "has_Arrived": hasArrived,
        "contract_Signed": contractSigned,
        "enter_ArrivingDetails": enterArrivingDetails,
        "rental_Rules_Signed": rentalRulesSigned,
        "handover_Signed": handoverSigned,
        "passport_Reject_Reason": passportRejectReason,
        "monthly_Invoice": monthlyInvoice?.toJson(),
        "guest_Image_Profile": guestImageProfile,
        "guest_Image_Uploaded": guestImageUploaded,
      };

  double get totalGuestPaid {
    if ((hasInvoiceSecurityPaid ?? false)) {
      if ((secuirtyPaid ?? false) && !(payLater ?? false)) {
        return bedPrice ?? 0.0;
      } else if (!(secuirtyPaid ?? false) && (payLater ?? false)) {
        return ((securityDeposit ?? 0.0) +
            (serviceFee ?? 0.0) +
            (bedPrice ?? 0.0));
      } else {
        return ((securityDeposit ?? 0.0) +
            (serviceFee ?? 0.0) +
            (bedPrice ?? 0.0));
      }
    } else {
      return ((securityDeposit ?? 0.0) +
          (serviceFee ?? 0.0) +
          (bedPrice ?? 0.0));
    }
  }
}

class ExContractModel {
  String? id;
  String? bookingId;
  String? guestId;
  DateTime? extendingFrom;
  DateTime? extendingTo;
  String? extendingStatus;
  String? extendingRejectReason;
  String? extendContract;
  String? extendContractSignature;
  DateTime? extendContractSignedAt;
  bool? extendContractSigned;

  ExContractModel({
    this.id,
    this.bookingId,
    this.guestId,
    this.extendingFrom,
    this.extendingTo,
    this.extendingStatus,
    this.extendingRejectReason,
    this.extendContract,
    this.extendContractSignature,
    this.extendContractSignedAt,
    this.extendContractSigned,
  });

  factory ExContractModel.fromJson(Map<String, dynamic> json) =>
      ExContractModel(
        id: json["id"],
        bookingId: json["booking_ID"],
        guestId: json["guest_ID"],
        extendingFrom: json["extending_From"] == null
            ? null
            : DateTime.parse(json["extending_From"]),
        extendingTo: json["extending_To"] == null
            ? null
            : DateTime.parse(json["extending_To"]),
        extendingStatus: json["extending_Status"],
        extendingRejectReason: json["extending_Reject_Reason"],
        extendContract: json["extend_Contract"],
        extendContractSignature: json["extend_Contract_Signature"],
        extendContractSignedAt: json["extend_Contract_Signed_At"] == null
            ? null
            : DateTime.parse(json["extend_Contract_Signed_At"]),
        extendContractSigned: json["extend_Contract_Signed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "booking_ID": bookingId,
        "guest_ID": guestId,
        "extending_From": extendingFrom?.toIso8601String(),
        "extending_To": extendingTo?.toIso8601String(),
        "extending_Status": extendingStatus,
        "extending_Reject_Reason": extendingRejectReason,
        "extend_Contract": extendContract,
        "extend_Contract_Signature": extendContractSignature,
        "extend_Contract_Signed_At": extendContractSignedAt?.toIso8601String(),
        "extend_Contract_Signed": extendContractSigned,
      };
}

class MonthlyInvoice {
  String? monthInvId;
  DateTime? invDate;
  double? invTotal;
  bool? isCashed;
  String? invCode;

  MonthlyInvoice({
    this.monthInvId,
    this.invDate,
    this.invTotal,
    this.isCashed,
    this.invCode,
  });

  factory MonthlyInvoice.fromJson(Map<String, dynamic> json) => MonthlyInvoice(
        monthInvId: json["month_Inv_ID"],
        invDate:
            json["inv_Date"] == null ? null : DateTime.parse(json["inv_Date"]),
        invTotal: json["inv_Total"],
        isCashed: json["isCashed"],
        invCode: json["inv_Code"],
      );

  Map<String, dynamic> toJson() => {
        "month_Inv_ID": monthInvId,
        "inv_Date": invDate?.toIso8601String(),
        "inv_Total": invTotal,
        "isCashed": isCashed,
        "inv_Code": invCode,
      };
}
