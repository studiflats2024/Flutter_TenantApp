import 'package:equatable/equatable.dart';

class ProblemApiModel extends Equatable {
  final String issueId;
  final DateTime createdAt;
  final String statusString;
  final String statusKey;
  final num issueCost;
  final String issueCode;
  final String aptName;
  final String resolveDescription;

  const ProblemApiModel({
    required this.issueId,
    required this.createdAt,
    required this.statusString,
    required this.statusKey,
    required this.issueCost,
    required this.issueCode,
    required this.aptName,
    required this.resolveDescription,
  });

  factory ProblemApiModel.fromJson(Map<String, dynamic> json) =>
      ProblemApiModel(
        issueId: json['issue_ID'] as String,
        createdAt: DateTime.parse(json['created_At'] as String),
        statusString: json['statusString'] as String,
        statusKey: json['issue_status'] as String,
        issueCost: json['issue_Cost'] as num,
        issueCode: json['issue_Code'] as String? ?? "",
        aptName: json['apt_Name'] as String? ?? "",
        resolveDescription: json['solve_Desc'] as String? ?? "",
      );

  @override
  List<Object> get props => [
        issueId,
        createdAt,
        statusString,
        statusKey,
        issueCost,
        issueCode,
        aptName,
      ];
}
