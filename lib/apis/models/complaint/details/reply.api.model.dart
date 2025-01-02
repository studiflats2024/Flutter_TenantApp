class ReplyComplaintApiModel {
  final String replyUser;
  final String dateTime;
  final String replyProvider;
  final String replyDesc;
  final String replyAttach;

  ReplyComplaintApiModel({
    required this.replyUser,
    required this.dateTime,
    required this.replyProvider,
    required this.replyDesc,
    required this.replyAttach,
  });

  factory ReplyComplaintApiModel.fromJson(Map<String, dynamic> json) =>
      ReplyComplaintApiModel(
        replyUser: json['reply_User'] as String,
        dateTime: json['date_Time'] as String,
        replyProvider: json['reply_Provider'] as String,
        replyDesc: json['reply_Desc'] as String,
        replyAttach: json['reply_Attach'] as String? ?? "",
      );
}
