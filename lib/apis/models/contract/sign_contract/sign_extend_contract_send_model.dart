import 'package:dio/dio.dart';

class SignExtendContractSendModel {
  final String requestId;
  final String signaturePath;

  SignExtendContractSendModel({required this.requestId, required this.signaturePath});

  Map<String, dynamic> toMap() {
    return {
      "Extend_ID": requestId,
    };
  }

  Future<FormData> mapSignatureImage() async {
    return FormData.fromMap({
      "Sign_Image": await MultipartFile.fromFile(signaturePath,
          filename: signaturePath.split('/').last)
    });
  }
}