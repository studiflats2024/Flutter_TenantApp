class AppVersionModel {
  String version;
  bool canSkip;

  AppVersionModel({required this.version, required this.canSkip});

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
        version: json['version_Tenant'], canSkip: json['tenant_Can_Skip']);
  }
}
