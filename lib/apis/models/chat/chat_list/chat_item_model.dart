class ChatItemModel {
  final String chatID;
  final String chatCode;
  final String status;
  final String aptName;
  final bool readed;

  ChatItemModel({
    required this.chatID,
    required this.chatCode,
    required this.status,
    required this.aptName,
    required this.readed,
  });

  factory ChatItemModel.fromJson(Map<String, dynamic> json) => ChatItemModel(
        chatID: json['chat_ID'] as String,
        chatCode: json['chat_Code'] as String,
        status: json['status'] as String,
        readed: json['readed'] as bool,
        aptName: json['apt_Name'] as String,
      );

  bool get isOpen => status == "Opened";
}
