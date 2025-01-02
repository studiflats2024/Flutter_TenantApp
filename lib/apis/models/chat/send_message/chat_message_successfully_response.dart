import 'package:vivas/apis/models/chat/chat_messages/chat_message_api_model.dart';

class ChatMessageSuccessfullyResponse {
  final ChatMessageApiModel chatMessageApiModel;

  ChatMessageSuccessfullyResponse(
    this.chatMessageApiModel,
  );

  ChatMessageSuccessfullyResponse.fromJson(Map<String, dynamic> json)
      : chatMessageApiModel = ChatMessageApiModel.fromJson(json);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['chatMessageApiModel'] = chatMessageApiModel;

    return map;
  }
}
