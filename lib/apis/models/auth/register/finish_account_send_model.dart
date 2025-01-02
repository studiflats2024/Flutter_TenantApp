class FinishAccountSendModel {
  final String? email;
  final String gender;
  final String nationality;
  final String dob;
  final String uuid;
  final String? mobileNumber;
  final ProviderApiKey providerApiKey;

  FinishAccountSendModel({
    this.email,
    required this.gender,
    required this.nationality,
    required this.dob,
    required this.uuid,
    required this.providerApiKey,
    this.mobileNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      if (email != null) "Email": email,
      "Gender": gender,
      "Nationality": nationality,
      "DOB": dob,
      "UUID": uuid,
      if (mobileNumber != null) "Mobile": mobileNumber,
      "Provider": providerApiKey.toApiKey(),
    };
  }
}

enum ProviderApiKey {
  locale,
  google,
  apple;

  String toApiKey() {
    switch (this) {
      case locale:
        return "Local";
      case google:
        return "Google";
      case apple:
        return "Apple";
    }
  }
}
