class CreateAccountSendModel {
  final String fullName;
  final String whatAppMobile;
  final String password;

  CreateAccountSendModel(this.fullName, this.whatAppMobile, this.password);

  Map<String, dynamic> toMap() {
    return {
      "fullName": fullName,
      "mobile": whatAppMobile,
      "password": password,
      "confirm_Password": password,
    };
  }
}
