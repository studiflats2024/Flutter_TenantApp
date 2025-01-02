import 'package:equatable/equatable.dart';
import 'package:vivas/apis/models/my_documents/document_api_model.dart';

class MyDocumentsListWrapper extends Equatable {
  final List<DocumentApiModel> data;

  const MyDocumentsListWrapper({
    required this.data,
  });

  factory MyDocumentsListWrapper.fromJson(List<dynamic> json) =>
      MyDocumentsListWrapper(
        data: (json)
            .map((e) => DocumentApiModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props {
    return [
      data,
    ];
  }
}
