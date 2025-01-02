import 'package:dio/dio.dart';

class SignContractSendModel {
  final String requestId;
  final String signaturePath;

  SignContractSendModel({required this.requestId, required this.signaturePath});

  Map<String, dynamic> toMap() {
    return {
      "Req_ID": requestId,
    };
  }

  Future<FormData> mapSignatureImage() async {
    return FormData.fromMap({
      "Sign_Path": await MultipartFile.fromFile(signaturePath,
          filename: signaturePath.split('/').last)
    });
  }
}
