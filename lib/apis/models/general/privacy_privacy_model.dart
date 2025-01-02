import 'package:equatable/equatable.dart';

class PrivacyPrivacyModel extends Equatable {
  final String content;

  const PrivacyPrivacyModel({required this.content});

  factory PrivacyPrivacyModel.fromJson(String? json) => PrivacyPrivacyModel(
        content: json ?? "",
      );

  @override
  List<Object?> get props => [content];
}
