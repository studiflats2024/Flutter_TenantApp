import 'package:vivas/utils/format/app_date_format.dart';

class ChatMessageApiModel {
  final String messageId;
  final String? userName;
  final String? userPhoto;

  final String? msgBody;
  final String? msgAttachment;
  final DateTime sendTime;
  final bool isRead;
  final bool isMobile;
  final bool isDash;

  ChatMessageApiModel({
    required this.messageId,
    required this.userName,
    required this.userPhoto,
    required this.msgBody,
    required this.msgAttachment,
    required this.sendTime,
    required this.isRead,
    required this.isMobile,
    required this.isDash,
  });

  factory ChatMessageApiModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageApiModel(
        messageId: json['chat_Message_ID'] as String,
        userName: json['user_Name'] as String?,
        userPhoto: json['user_Photo'] as String?,
        msgBody: json['msg_Body'] as String?,
        msgAttachment: json['msg_Attachement'] as String?,
        sendTime: AppDateFormat.formattingApiDateFromString(
            json['send_Time'] as String),
        isRead: json['is_Readed'] as bool,
        isMobile: json['is_Mobile'] as bool,
        isDash: json['is_Dash'] as bool,
      );
}
