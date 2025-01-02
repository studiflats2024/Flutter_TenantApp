import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class EditProblemEndModel extends Equatable {
  final String problemId;
  final String newDescription;

  const EditProblemEndModel({
    required this.problemId,
    required this.newDescription,
  });

  @override
  List<Object?> get props => [
        problemId,
        newDescription,
      ];

  Map<String, dynamic> toMap() {
    return {
      'issue_ID': problemId,
      'issue_Desc': newDescription,
    };
  }
}
