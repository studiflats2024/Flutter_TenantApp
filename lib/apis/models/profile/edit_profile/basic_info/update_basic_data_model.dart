class UpdateBasicDataSendModel {
  final String fullName;
  final String about;

  UpdateBasicDataSendModel(this.fullName, this.about);

  Map<String, dynamic> toMap() {
    return {"FullName": fullName, "About": about};
  }
}
