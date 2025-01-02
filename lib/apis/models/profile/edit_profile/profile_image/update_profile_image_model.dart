import 'package:dio/dio.dart';

class UpdateProfileImageSendModel {
  final String imagePath;

  UpdateProfileImageSendModel({required this.imagePath});

  Future<FormData> toMap() async {
    return FormData.fromMap({
      "Image_File": await MultipartFile.fromFile(imagePath,
          filename: imagePath..split('/').last)
    });
  }
}
