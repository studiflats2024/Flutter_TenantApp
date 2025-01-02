import 'package:dio/dio.dart';

class SendUploadFileModel {
  final String imagePath;

  const SendUploadFileModel({
    required this.imagePath,
  });
  Future<FormData> toMap() async {
    return FormData.fromMap({
      "fileData": await MultipartFile.fromFile(imagePath,
          filename: imagePath..split('/').last)
    });
  }
}
