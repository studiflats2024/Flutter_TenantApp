import 'package:dio/dio.dart';

class SignMemberContractSendModel {
  final String signatureImagePath;

  SignMemberContractSendModel(this.signatureImagePath);

  Future<FormData> mapSignatureImage() async {
    return FormData.fromMap({
      "Signature_Image": await MultipartFile.fromFile(signatureImagePath,
          filename: signatureImagePath.split('/').last)
    });
  }
}
