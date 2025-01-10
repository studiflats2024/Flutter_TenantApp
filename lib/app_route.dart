import 'package:flutter/material.dart';
import 'package:vivas/feature/app_pages/screen/faq_list_screen.dart';
import 'package:vivas/feature/app_pages/screen/privacy_privacy_screen.dart';
import 'package:vivas/feature/app_pages/screen/terms_conditions_screen.dart';
import 'package:vivas/feature/arriving_details/Screen/arriving_details.dart';
import 'package:vivas/feature/auth/completed_profile/screen/completed_profile_screen.dart';
import 'package:vivas/feature/auth/forget_password/screen/forget_password_screen.dart';
import 'package:vivas/feature/auth/forget_password/screen/rest_password_screen.dart';
import 'package:vivas/feature/auth/forget_password/screen/rest_password_screen_v2.dart';
import 'package:vivas/feature/auth/login/screen/login_screen.dart';
import 'package:vivas/feature/auth/otp/screen/otp_screen.dart';
import 'package:vivas/feature/auth/sign_up/screen/sign_up_screen.dart';
import 'package:vivas/feature/bookings/screen/apartment_rules.dart';
import 'package:vivas/feature/bookings/screen/booking_details_screen.dart';
import 'package:vivas/feature/bookings/screen/booking_id.dart';
import 'package:vivas/feature/bookings/screen/booking_pay_rent.dart';
import 'package:vivas/feature/bookings/screen/booking_scan_qr.dart';
import 'package:vivas/feature/bookings/screen/booking_select_name.dart';
import 'package:vivas/feature/bookings/screen/booking_summry.dart';
import 'package:vivas/feature/bookings/screen/congratulations_screen.dart';
import 'package:vivas/feature/bookings/screen/hand_over_screen.dart';
import 'package:vivas/feature/bookings/screen/qr_scanner_screen.dart';
import 'package:vivas/feature/bookings/screen/select_tenant_for_paid.dart';
import 'package:vivas/feature/bookings/screen/selfie_screen.dart';
import 'package:vivas/feature/bookings/screen/sign_contract_v2.dart';
import 'package:vivas/feature/bookings/screen/take_image_for_profile.dart';
import 'package:vivas/feature/bookings/screen/welcome.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:vivas/feature/checkout/checkout_details/screen/checkout_details_screen.dart';
import 'package:vivas/feature/checkout/credit_card_info/screen/credit_card_info_screen.dart';
import 'package:vivas/feature/complaints/screen/complaints_details_screen.dart';
import 'package:vivas/feature/complaints/screen/complaints_list_screen.dart';
import 'package:vivas/feature/complaints/screen/send_complaints_screen.dart';
import 'package:vivas/feature/contact_support/screen/chat_history_screen.dart';
import 'package:vivas/feature/contact_support/screen/chat_screen.dart';
import 'package:vivas/feature/contact_support/screen/contact_support_screen.dart';
import 'package:vivas/feature/contract/prepare_check_in/screen/prepare_check_in_screen.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/screen/check_in_details_screen.dart';
import 'package:vivas/feature/contract/sign_contract/screen/sign_contract_screen.dart';
import 'package:vivas/feature/contract/sign_contract/screen/sign_contract_screen_v2.dart';
import 'package:vivas/feature/contract/sign_contract/screen/sign_extend_contract.dart';
import 'package:vivas/feature/home/screen/apartment_qr_code_details.dart';
import 'package:vivas/feature/invoices/screen/invoices_details_screen.dart';
import 'package:vivas/feature/invoices/screen/invoices_screen.dart';
import 'package:vivas/feature/make_request/screen/make_request_screen.dart';
import 'package:vivas/feature/make_request/screen/make_request_screen_v2.dart';
import 'package:vivas/feature/make_waiting_request/screen/make_waiting_request_screen.dart';
import 'package:vivas/feature/make_request/screen/apartment_request_view.dart';
import 'package:vivas/feature/my_documents/screen/my_documents_screen.dart';
import 'package:vivas/feature/notification_list/screen/notification_list_screen.dart';
import 'package:vivas/feature/payment/screen/payment_screen.dart';
import 'package:vivas/feature/payment/screen/payment_screen_v2.dart';
import 'package:vivas/feature/payment/screen/success_payment_screen.dart';
import 'package:vivas/feature/payments_invoices/screen/payments_invoices_screen.dart';
import 'package:vivas/feature/problem/screen/problem_details_screen.dart';
import 'package:vivas/feature/problem/screen/report_apartment_screen.dart';
import 'package:vivas/feature/problem/screen/my_problem_screen.dart';
import 'package:vivas/feature/problem/screen/select_apartment_problem_screen.dart';
import 'package:vivas/feature/profile/profile_screen/widget/profile_view.dart';
import 'package:vivas/feature/request_details/request_details/screen/complete_your_booking_screen.dart';
import 'package:vivas/feature/request_details/request_details/screen/invoice_pay_rent_screen_v2.dart';
import 'package:vivas/feature/request_details/request_details/screen/invoice_screen.dart';
import 'package:vivas/feature/request_details/request_details/screen/invoice_screen_v2.dart';
import 'package:vivas/feature/request_details/request_details/screen/request_details_screen.dart';
import 'package:vivas/feature/request_details/request_details/screen/request_details_screen_v2.dart';
import 'package:vivas/feature/request_details/request_details/screen/security_deposit_payment_screen.dart';
import 'package:vivas/feature/request_details/request_details/screen/security_deposit_screen.dart';
import 'package:vivas/feature/request_details/request_passport/screen/request_passport_screen.dart';
import 'package:vivas/feature/profile/edit_personal_information/edit_personal_info_screen.dart';
import 'package:vivas/feature/request_details/request_passport/screen/request_passport_screen_v2.dart';
import 'package:vivas/feature/saved_card/saved_card_screen.dart';
import 'package:vivas/feature/splash/splash_screen.dart';
import 'package:vivas/feature/unit_details/screen/apartment_contents_screen.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';
import 'package:vivas/feature/unit_list/screen/unit_list_screen.dart';
import 'package:vivas/feature/widgets/MaintenanceApp/maintenance_app.dart';
import 'package:vivas/welcome_screen.dart';

import 'feature/payment/screen/success_payment_screen_v2.dart';
import 'feature/profile/edit_personal_information/otp/profile_otp_screen.dart';

class AppRoute {
  static final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();

  static final Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.routeName: (ctx) => SplashScreen(),
    LoginScreen.routeName: (ctx) => LoginScreen(),
    SignUpScreen.routeName: (ctx) => SignUpScreen(),
    ForgetPasswordScreen.routeName: (ctx) => ForgetPasswordScreen(),
    OtpScreen.routeName: (ctx) => OtpScreen(),
    RestPasswordScreen.routeName: (ctx) => RestPasswordScreen(),
    CompletedProfileScreen.routeName: (ctx) => CompletedProfileScreen(),
    BottomNavigationScreen.routeName: (ctx) => const BottomNavigationScreen(),
    WelcomeAuthScreen.routeName: (ctx) => const WelcomeAuthScreen(),
    UnitListScreen.routeName: (ctx) => UnitListScreen(),
    UnitDetailsScreen.routeName: (ctx) => UnitDetailsScreen(),
    ApartmentContentsScreen.routeName: (ctx) => ApartmentContentsScreen(),
    MakeRequestScreen.routeName: (ctx) => MakeRequestScreen(),
    RequestPassportScreen.routeName: (ctx) => RequestPassportScreen(),
    RequestDetailsScreen.routeName: (ctx) => RequestDetailsScreen(),
    SecurityDepositPaymentScreen.routeName: (ctx) =>
        SecurityDepositPaymentScreen(),
    CompleteYourBookingScreen.routeName: (ctx) => CompleteYourBookingScreen(),
    SecurityDepositScreen.routeName: (ctx) => SecurityDepositScreen(),
    InvoiceScreen.routeName: (ctx) => InvoiceScreen(),
    EditPersonalInformationScreen.routeName: (ctx) =>
        const EditPersonalInformationScreen(),
    ProfileOtpScreen.routeName: (ctx) => ProfileOtpScreen(),
    NotificationListScreen.routeName: (ctx) => NotificationListScreen(),
    PaymentsInvoicesScreen.routeName: (ctx) => const PaymentsInvoicesScreen(),
    InvoicesScreen.routeName: (ctx) => InvoicesScreen(),
    InvoicesDetailsScreen.routeName: (ctx) => InvoicesDetailsScreen(),
    SavedCardScreen.routeName: (ctx) => const SavedCardScreen(),
    MyDocumentsScreen.routeName: (ctx) => MyDocumentsScreen(),
    MyProblemScreen.routeName: (ctx) => MyProblemScreen(),
    SelectApartmentProblemScreen.routeName: (ctx) =>
        SelectApartmentProblemScreen(),
    ReportApartmentScreen.routeName: (ctx) => ReportApartmentScreen(),
    PaymentScreen.routeName: (ctx) => PaymentScreen(),
    PaymentSuccessfullyScreen.routeName: (ctx) => PaymentSuccessfullyScreen(),
    SignContractScreen.routeName: (ctx) => SignContractScreen(),
    PrepareCheckInScreen.routeName: (ctx) => PrepareCheckInScreen(),
    CheckInDetailsScreen.routeName: (ctx) => CheckInDetailsScreen(),
    ProblemDetailsScreen.routeName: (ctx) => ProblemDetailsScreen(),
    ComplaintsListScreen.routeName: (ctx) => ComplaintsListScreen(),
    ComplaintsDetailsScreen.routeName: (ctx) => ComplaintsDetailsScreen(),
    SendComplaintsScreen.routeName: (ctx) => SendComplaintsScreen(),
    PrivacyPrivacyScreen.routeName: (ctx) => PrivacyPrivacyScreen(),
    TermsConditionsScreen.routeName: (ctx) => TermsConditionsScreen(),
    FaqListScreen.routeName: (ctx) => FaqListScreen(),
    CheckoutDetailsScreen.routeName: (ctx) => CheckoutDetailsScreen(),
    CreditCardInfoScreen.routeName: (ctx) => CreditCardInfoScreen(),
    MakeWaitingRequestScreen.routeName: (ctx) => MakeWaitingRequestScreen(),
    ContactSupportScreen.routeName: (ctx) => ContactSupportScreen(),
    ChatHistoryScreen.routeName: (ctx) => ChatHistoryScreen(),
    ChatScreen.routeName: (ctx) => ChatScreen(),
    //Momo Added :
    MakeRequestScreenV2.routeName: (ctx) => MakeRequestScreenV2(),
    ApartmentRequestView.routeName: (ctx) => ApartmentRequestView(),
    ApartmentContentsScreenV2.routeName: (ctx) => ApartmentContentsScreenV2(),
    BookingId.routeName: (ctx) => const BookingId(),
    BookingSelectName.routeName: (ctx) => const BookingSelectName(),
    BookingSummary.routeName: (ctx) => const BookingSummary(),
    BookingScanQr.routeName: (ctx) => BookingScanQr(),
    WelcomeScreen.routeName: (ctx) => const WelcomeScreen(),
    SelfieScreen.routeName: (ctx) => SelfieScreen(),
    BookingPayRent.routeName: (ctx) => const BookingPayRent(),
    SignContractV2Screen.routeName: (ctx) => const SignContractV2Screen(),
    HandoverProtocolsScreen.routeName: (ctx) => HandoverProtocolsScreen(),
    ApartmentRulesScreen.routeName: (ctx) => ApartmentRulesScreen(),
    BookingDetailsScreen.routeName: (ctx) => const BookingDetailsScreen(),
    ArrivingDetails.routeName: (ctx) => ArrivingDetails(),
    PersonalInformation.routeName: (ctx) => const PersonalInformation(),
    RequestDetailsScreenV2.routeName: (ctx) => RequestDetailsScreenV2(),
    RequestPassportScreenV2.routeName: (ctx) => RequestPassportScreenV2(),
    InvoiceScreenV2.routeName: (ctx) => InvoiceScreenV2(),
    SignContractScreenV2.routeName: (ctx) => SignContractScreenV2(),
    PaymentScreenV2.routeName: (ctx) => PaymentScreenV2(),
    QrScannerScreen.routeName: (ctx) => const QrScannerScreen(),
    CongratulationsScreen.routeName: (ctx) => const CongratulationsScreen(),
    SelectTenantForPay.routeName: (ctx) => SelectTenantForPay(),
    InvoicePayRentScreenV2.routeName: (ctx) => InvoicePayRentScreenV2(),
    PaymentSuccessfullyScreenV2.routeName: (ctx) =>
        PaymentSuccessfullyScreenV2(),
    ResetPasswordScreenV2.routeName: (ctx) => ResetPasswordScreenV2(),
    ApartmentQrCodeDetails.routeName: (ctx) => ApartmentQrCodeDetails(),
    TakeSelfieScreen.routeName: (ctx) => TakeSelfieScreen(),
    MaintenanceApp.routeName: (ctx) => MaintenanceApp(),
    SignExtendContractScreen.routeName: (ctx) => SignExtendContractScreen()
  };
}
