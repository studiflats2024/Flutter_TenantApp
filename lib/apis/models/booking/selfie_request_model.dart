import 'package:dio/dio.dart';

class SelfieRequestModel {
  final String requestId;
  final String bedID;
  final String imagePath;

  SelfieRequestModel({required this.requestId,required this.bedID , required this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      "Booking_ID": requestId,
      "Bed_ID": bedID,
    };
  }

  Future<FormData> mapSignatureImage() async {
    return FormData.fromMap({
      "Selfe_Image": await MultipartFile.fromFile(imagePath,
          filename: imagePath.split('/').last)
    });
  }
}
