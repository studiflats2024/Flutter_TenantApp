class UpdatePhoneNumberSendModel {
  final String currentPhoneNumber;
  final String password;
  final String newPhoneNumber;

  UpdatePhoneNumberSendModel(
      this.currentPhoneNumber, this.password, this.newPhoneNumber);

  Map<String, dynamic> toMap() {
    return {
      "CurrentPhone": currentPhoneNumber,
      "Password": password,
      "NewPhone": newPhoneNumber
    };
  }
}
