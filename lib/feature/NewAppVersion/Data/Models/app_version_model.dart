class AppVersionModel {
  String version;

  AppVersionModel({required this.version});

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(version: json['version_Tenant']);
  }
}
