class ForgetPasswordSendModel {
  final String mobile;

  ForgetPasswordSendModel(this.mobile);

  Map<String, dynamic> toMap() {
    return {
      "Mobile": mobile,
    };
  }
}
