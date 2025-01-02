class ChatBootQuestionModel {
  final String id;
  final String quest;
  final String questAnswer;
  final String? questModule;

  ChatBootQuestionModel({
    required this.id,
    required this.quest,
    required this.questAnswer,
    required this.questModule,
  });

  factory ChatBootQuestionModel.fromJson(Map<String, dynamic> json) =>
      ChatBootQuestionModel(
        id: json['id'] as String,
        quest: json['quest'] as String,
        questAnswer: json['quest_Answ'] as String,
        questModule: json['quest_Module'] as String?,
      );
}
