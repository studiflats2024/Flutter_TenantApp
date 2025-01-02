class ChatMessageSendModel {
  final String chatID;
  final String? msgText;
  final String? attachment;

  ChatMessageSendModel({
    required this.chatID,
    this.msgText,
    this.attachment,
  });

  Map<String, dynamic> toMap() {
    return {
      "chat_ID": chatID,
      if (msgText != null) "msg_Body": msgText,
      if (attachment != null) "msg_Attachement": attachment,
    };
  }
}
