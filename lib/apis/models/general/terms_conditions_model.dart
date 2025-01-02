import 'package:equatable/equatable.dart';

class TermsConditionsModel extends Equatable {
  final String content;

  const TermsConditionsModel({required this.content});

  factory TermsConditionsModel.fromJson(String? json) => TermsConditionsModel(
        content: json ?? "",
      );

  @override
  List<Object?> get props => [content];
}
