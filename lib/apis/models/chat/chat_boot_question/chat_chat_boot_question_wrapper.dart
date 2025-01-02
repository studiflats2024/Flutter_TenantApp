import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/chat/chat_boot_question/chat_boot_question_model.dart';

class ChatChatBootQuestionWrapper extends Equatable {
  final List<ChatBootQuestionModel> data;

  const ChatChatBootQuestionWrapper({
    required this.data,
  });

  factory ChatChatBootQuestionWrapper.fromJson(List<dynamic> json) =>
      ChatChatBootQuestionWrapper(
        data: json
            .map((e) =>
                ChatBootQuestionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props {
    return [data];
  }
}
