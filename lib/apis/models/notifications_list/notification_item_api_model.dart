import 'package:equatable/equatable.dart';
import 'package:vivas/utils/format/app_date_format.dart';

// ignore: must_be_immutable
class NotificationItemApiModel extends Equatable {
  final String notificationId;
  final String title;
  final String description;
  final String module;
  final String keyUUID;
  final DateTime createAt;
  final bool isRead;

  const NotificationItemApiModel({
    required this.notificationId,
    required this.title,
    required this.description,
    required this.module,
    required this.keyUUID,
    required this.createAt,
    required this.isRead,
  });

  factory NotificationItemApiModel.fromJson(Map<String, dynamic> json) =>
      NotificationItemApiModel(
        notificationId: json['uuid'] as String,
        title: json['noti_Title'] as String,
        description: json['noti_Desc'] as String,
        module: json['module'] as String,
        keyUUID: json['key_UUID'] as String,
        isRead: json['noti_Readed'] as bool,
        createAt:
            AppDateFormat.appDateFormApiParse(json['noti_Date'] as String),
      );

  @override
  List<Object?> get props {
    return [
      notificationId,
      title,
      createAt,
    ];
  }
}
