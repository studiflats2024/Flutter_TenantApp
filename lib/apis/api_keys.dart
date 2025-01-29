import 'package:vivas/utils/build_type/build_type.dart';

class ApiKeys {
  /// KEYs
  static const clientId = "2";
  static const clientSecret = "xCRM0X5S76iPnFEADzMVfLhyu7o1ZQVHKmh1pnhO";
  static const grantTypeLogin = "password";
  static const grantTypeRefreshToken = "refresh_token";
  static const authorization = "Authorization";
  static const devToken = "devtoken";
  static const guestToken = "guest_token";
  static const accept = "Accept";
  static const applicationJson = "application/json";
  static const locale = "Accept-Language";
  static const contentType = "Content-Type";
  static const keyBearer = "Bearer";
  static const keyType = "device-type";

  /// URLs
  static const baseDevUrl = "https://devapi.studiflats.com";
  static const baseStagingUrl = "https://stageapi.studiflats.com";
  static const baseProductionUrl = "https://api.studiflats.com";

  static final currentEnvironment = isDevMode() ? baseDevUrl : baseProductionUrl;

  static const apiKeyUrl = "api";
  static const baseApiUrl = '/$apiKeyUrl';

  static const wATokenUrl = '$baseApiUrl/Users/WAToken';
  static const refreshOtpUrl = '$baseApiUrl/Users/Refresh_Otp';
  static const checkOtpUrl = '$baseApiUrl/Users/Check_Otp';
  static const createAccountUrl = '$baseApiUrl/Users/Create_Account';
  static const finishAccountUrl = '$baseApiUrl/Users/Finish_Profile';
  static const loginUrl = '$baseApiUrl/Users/Login';
  static const socialSignUrl = '$baseApiUrl/Users/SocialSign';
  static const forgetPasswordUrl = '$baseApiUrl/Users/Forget_Password';
  static const resetPasswordUrl = '$baseApiUrl/Users/ResetPassword';

  static const refreshTokenUrl = '$baseApiUrl/Users/refresh-token';

  static const getApartmentUrl = '$baseApiUrl/Apartment';
  static const areaUrl = '$baseApiUrl/Area';
  static const cityUrl = '$baseApiUrl/Basics/GetAreasandCities';
  static const getSearchApartmentUrl = '$baseApiUrl/Basics/AdvancedSearch';
  static const getApartmentByIdUrl = '$baseApiUrl/Requests/GetApartment';

  static const uploadFileUrl = '$baseApiUrl/Basics/UploadSingleFile';

  static const getWishListUrl = '$baseApiUrl/Basics/GetWishList';
  static const addWishListUrl = '$baseApiUrl/Basics/AddWishList';
  static const removeWishListUrl = '$baseApiUrl/Basics/RemoveWishList';

  /// Apartment Requests

  static const createRequestsUrl = '$baseApiUrl/Requests/CreateRequest';
  static const approveRejectOfferUrl = '$baseApiUrl/Requests/OfferApproval';

  static const getRequestsUrl = '$baseApiUrl/Requests/GetUserRequests';
  static const getRequestDetailsUrl = '$baseApiUrl/Requests/GetRequestDetails';
  static const updateRequestPassportsUrl =
      '$baseApiUrl/Requests/UpdateRequestPassports';
  static const updateRequestDatesUrl =
      '$baseApiUrl/Requests/UpdateRequestDates';
  static const cancelRequestUrl = '$baseApiUrl/Requests/CancelRequest';
  static const getRequestInvoiceUrl = '$baseApiUrl/Requests/GetRequestInvoice';

  static const getProfileUrl = '$baseApiUrl/Users/GetProfile';
  static const updateBasicDataUrl = '$baseApiUrl/Users/UpdateBasicData';
  static const updateProfileImageUrl = '$baseApiUrl/Users/UpdateProfileImg';
  static const updateEmailUrl = '$baseApiUrl/Users/UpdateMail';
  static const updatePhoneNumberUrl = '$baseApiUrl/Users/UpdateMobile';
  static const logoutUrl = '$baseApiUrl/Users/Logout';
  static const deleteAccount = '$baseApiUrl/Users/DeleteAccount';

  /// Notifications API

  static const getNotificationUrl =
      '$baseApiUrl/Notification/GetAllNotification';
  static const notificationMarkReadUrl = '$baseApiUrl/Notification/MarkRead';
  static const getDocumentsUrl = '$baseApiUrl/Basics/GetDocs';
  static const getInvoiceListUrl = '$baseApiUrl/Accounting/GetInoviceList';
  static const getInvoiceDetailsUrl =
      '$baseApiUrl/Accounting/GetInvoiceDetails';
  static const getProblemsListUrl = '$baseApiUrl/Issues/GetAllIssueByUser';
  static const getUserApartmentsUrl = '$baseApiUrl/Issues/GetUserApartments';
  static const addProblemUrl = '$baseApiUrl/Issues/PostIssue';
  static const editProblemUrl = '$baseApiUrl/Issues/UpdateIssueDesc';
  static const getIssueDetailsUrl = '$baseApiUrl/Issues/GetIssueDetails_Mobile';
  static const paymentUrl = '$baseApiUrl/Accounting/Checkout';

  ///contract Api
  static const getContract = '$baseApiUrl/Requests/GetContract';
  static const signContract = '$baseApiUrl/Requests/SignContract';
  static const postCheckInDetailsUrl =
      '$baseApiUrl/Requests/PostCheckInDetails';
  static const getCheckInDetailsUrl = '$baseApiUrl/Requests/GetCheckInDetails';

  ///Tickets Api
  static const getComplaintsListUrl = '$baseApiUrl/Tickets/MobileTickets';
  static const getComplaintsDetailsUrl = '$baseApiUrl/Tickets/GetTicketDetails';
  static const createComplaintsUrl = '$baseApiUrl/Tickets/CreateTicket';
  static const replyComplaintsUrl = '$baseApiUrl/Tickets/ReplyMobile';
  static const getTicketsTypesUrl = '$baseApiUrl/Tickets/GetTicketsTypes';

  // general Pages
  static const privacyPrivacyUrl = '$baseApiUrl/Basics/GetPrivacy';
  static const termsConditionsUrl = '$baseApiUrl/Basics/GetTerms';
  static const getAdsUrl = '$baseApiUrl/Basics/GetAds';
  static const getFAQUrl = '$baseApiUrl/Basics/GetFAQ';
  static const getCountsUrl = '$baseApiUrl/Basics/GetCounts';
  static const addReview = '$baseApiUrl/Requests/ReviewRequest';
  static const checkoutSheet = '$baseApiUrl/Requests/GetCheckoutSheet';
  static const postBankDetails = '$baseApiUrl/Requests/PostBankDetails';

  static const makeWaitingRequestUrl = '$baseApiUrl/Basics/SetInWaiting';

  // contact support  screen
  static const getChatFAQUrl = '$baseApiUrl/Chat/GetFAQ';
  static const getChatListUrl = '$baseApiUrl/Chat/ListChat';
  static const getChatMessagesUrl = '$baseApiUrl/Chat/GetChatMessages';
  static const getChatBootQuestUrl = '$baseApiUrl/Chat/GetChatBootQuest';
  static const sendMessagesChatUrl = '$baseApiUrl/Chat/SendMsg';
  static const startNewChatUrl = '$baseApiUrl/Chat/StartNewChat';

  //////////////////////////////////////////////////
  //////////////// Apartment V2 ///////////////////
  ////////////////////////////////////////////////
  static const getApartmentV2Url = '$baseApiUrl/ApartmentV2/GetListApartments';
  static const getApartmentByIdV2Url =
      '$baseApiUrl/ApartmentV2/GetApartmentDetails';
  static const createRequestsV2Url =
      '$baseApiUrl/ApartmentV2/Apartment_New_Booking';
  static const getBookingList = '$baseApiUrl/ApartmentV2/GetBookingList';
  static const getBookingDetails =
      '$baseApiUrl/ApartmentV2/Booking_Details_Mobile';
  static const sendUploadPassport = '$baseApiUrl/ApartmentV2/UploadPassports';
  static const sendArrivingDetails =
      '$baseApiUrl/ApartmentV2/Post_ArrivingDetails';
  static const getSecurityDepositInvoiceUrl =
      '$baseApiUrl/ApartmentV2/Get_Secuirty_Deposit_Invoice';
  static const getNewBookingInvoices =
      '$baseApiUrl/ApartmentV2/GetNewBooking_Invoices';
  static const getContractV2 = '$baseApiUrl/ApartmentV2/Get_Contract';
  static const signContractV2 = '$baseApiUrl/ApartmentV2/SignFiles';
  static const qrScannerV2 = '$baseApiUrl/ApartmentV2/Scan_QR';
  static const selfieImageV2 = '$baseApiUrl/ApartmentV2/Selfie_Verification';
  static const getHandoverProtocolsV2 =
      '$baseApiUrl/ApartmentV2/GetHandoverProtocol';
  static const getApartmentRulesV2 = '$baseApiUrl/ApartmentV2/Get_Rental_Rules';
  static const paymentUrlV2 = '$baseApiUrl/ApartmentV2/GetStripeCheckout';
  static const resetPasswordUrlV2 = '$baseApiUrl/ApartmentV2/Change_Password';
  static const getQrDetailsUrl = '$baseApiUrl/ApartmentV2/GetQr_Details';
  static const extendContractUrl = '$baseApiUrl/ApartmentV2/Extend_Contract';
  static const gVersionUrl = '$baseApiUrl/Basics/GetAppVersion';
  static const ssoLoginUrl = '$baseApiUrl/Users/sso-login';
  static const getExtendContract = '$baseApiUrl/ApartmentV2/Get_Extend_Booking_Contract';
  static const signExtendContract = '$baseApiUrl/ApartmentV2/Sign_Extend_Request_Contract';
  static const changeCheckOutDate = '$baseApiUrl/ApartmentV2/UpdateCheckout_Date';

  //================================== Community ===============================
  static const getCommunityMonthlyActivities = '$baseApiUrl/Gateway/GetMonthly_Activites';
  static const getCommunityPaginatedActivities = '$baseApiUrl/Gateway/GetPaginatedActivites';
  static const getCommunitySubscriptionsPlan = '$baseApiUrl/Gateway/GetSubscriptionPlans';
  static const getCommunityQr = '$baseApiUrl/Gateway/GetMyQr';
}
