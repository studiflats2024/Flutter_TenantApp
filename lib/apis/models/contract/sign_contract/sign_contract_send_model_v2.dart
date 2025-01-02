import 'package:dio/dio.dart';

class SignContractSendModelV2 {
  final String requestId;
  final String contractID;
  final String signaturePath;

  SignContractSendModelV2({required this.requestId,required this.contractID , required this.signaturePath});

  Map<String, dynamic> toMap() {
    return {
      "Booking_ID": requestId,
      "Sign_ID": contractID,
    };
  }

  Future<FormData> mapSignatureImage() async {
    return FormData.fromMap({
      "Booking_ID": requestId,
      "Sign_ID": contractID,
      "Signature_Image": await MultipartFile.fromFile(signaturePath,
          filename: signaturePath.split('/').last)
    });
  }
}
