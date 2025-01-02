class UpdateEmailSendModel {
  final String currentEmail;
  final String password;
  final String newEmail;

  UpdateEmailSendModel(this.currentEmail, this.password, this.newEmail);

  Map<String, dynamic> toMap() {
    return {
      "CurrentEmail": currentEmail,
      "Password": password,
      "NewMail": newEmail
    };
  }
}
