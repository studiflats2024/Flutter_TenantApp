import 'package:vivas/res/app_asset_paths.dart';

enum ActivitiesType {
  all("All", "All", null),
  course("Courses", "Course", AppAssetPaths.videoIcon),
  workshop("Workshops", "Workshop", AppAssetPaths.workshopIcon),
  event("Events", "Event", AppAssetPaths.calenderIconOutline),
  consultant("Consultant", "Consult", AppAssetPaths.consultantIcon);

  final String code;
  final String filter;
  final String? asset;

  const ActivitiesType(
      this.code,
      this.filter,
      this.asset,
      );

  static ActivitiesType? fromValue(String value) {
    return ActivitiesType.values.firstWhere(
          (s) => s.code == value,
      orElse: () => ActivitiesType.all,
    );
  }
  static ActivitiesType? fromType(String value) {
    return ActivitiesType.values.firstWhere(
          (s) => s.filter == value,
      orElse: () => ActivitiesType.all,
    );
  }
}