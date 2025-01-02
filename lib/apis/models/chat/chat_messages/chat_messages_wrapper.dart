import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/chat/chat_messages/chat_message_api_model.dart';

class ChatMessagesWrapper extends Equatable {
  final List<ChatMessageApiModel> data;

  const ChatMessagesWrapper({
    required this.data,
  });

  factory ChatMessagesWrapper.fromJson(List<dynamic> json) =>
      ChatMessagesWrapper(
        data: json
            .map((e) => ChatMessageApiModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props {
    return [data];
  }
}
