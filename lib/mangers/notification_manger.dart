import 'package:get_it/get_it.dart';
import 'package:vivas/apis/models/notifications_list/notification_item_api_model.dart';
import 'package:vivas/app_route.dart';
import 'package:vivas/feature/complaints/screen/complaints_details_screen.dart';
import 'package:vivas/feature/contact_support/screen/chat_screen.dart';
import 'package:vivas/feature/invoices/screen/invoices_details_screen.dart';
import 'package:vivas/feature/problem/screen/problem_details_screen.dart';
import 'package:vivas/feature/request_details/request_details/screen/request_details_screen.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';

import 'package:vivas/preferences/preferences_manager.dart';

import '../feature/request_details/request_details/screen/request_details_screen_v2.dart';

class NotificationManager {
  NotificationData? _notificationData;

  NotificationManager();
  NotificationData? get notificationData {
    return _notificationData;
  }

  bool _canOpen = false;
  bool get canOpenNotification {
    return _canOpen;
  }

  void notificationDataInfo(NotificationData model) {
    _notificationData = model;
    _canOpen = true;
  }

  void clearModel() {
    _notificationData = null;
    _canOpen = false;
  }

  Future<void> openNotification() async {
    if (_notificationData != null) {
      switch (_notificationData!.type) {
        case "Booking":
          _canOpen = false;
          await RequestDetailsScreenV2.open(
              AppRoute.mainNavigatorKey.currentContext!,
              _notificationData!.keyUUID);
          break;
        case "Issue":
          _canOpen = false;
          await ProblemDetailsScreen.open(
              AppRoute.mainNavigatorKey.currentContext!,
              _notificationData!.keyUUID);
          break;
        case "Invoice":
          _canOpen = false;
          InvoicesDetailsScreen.open(AppRoute.mainNavigatorKey.currentContext!,
              _notificationData!.keyUUID);
          break;
        case "Ticket":
          _canOpen = false;
          await ComplaintsDetailsScreen.open(
              AppRoute.mainNavigatorKey.currentContext!,
              _notificationData!.keyUUID);
          break;
        case "Chats":
          _canOpen = false;
          await ChatScreen.open(AppRoute.mainNavigatorKey.currentContext!,
              chatUUID: _notificationData!.keyUUID);
          break;
        case "Apartments":
          _canOpen = false;
          await UnitDetailsScreen.open(
              AppRoute.mainNavigatorKey.currentContext!,
              _notificationData!.keyUUID);
          break;
      }
    }
    clearModel();
  }

  Future<bool> get isLoggedIn async =>
      await GetIt.I<PreferencesManager>().isLoggedIn();
}

class NotificationData {
  final String type;
  final String keyUUID;

  NotificationData({
    required this.type,
    required this.keyUUID,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        type: json['Module'] as String,
        keyUUID: json['Key_UUID'] as String,
      );
  factory NotificationData.fromNotificationApiModel(
          NotificationItemApiModel notificationItemApiModel) =>
      NotificationData(
        type: notificationItemApiModel.module,
        keyUUID: notificationItemApiModel.keyUUID,
      );
}
