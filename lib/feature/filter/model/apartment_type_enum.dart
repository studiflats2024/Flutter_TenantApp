import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

enum ApartmentType {
  apartment,
  studio,
  bed,
  room;

  String get imagePath {
    switch (this) {
      case apartment:
        return AppAssetPaths.apartmentIcon;
      case ApartmentType.studio:
        return AppAssetPaths.studioIcon;
      case ApartmentType.bed:
        return AppAssetPaths.bedIcon;
      case ApartmentType.room:
        return AppAssetPaths.roomIcon;
    }
  }

  String get localizedKey {
    switch (this) {
      case apartment:
        return LocalizationKeys.apartment;
      case ApartmentType.studio:
        return LocalizationKeys.studio;
      case ApartmentType.bed:
        return LocalizationKeys.bed;
      case ApartmentType.room:
        return LocalizationKeys.room;
    }
  }

  String get apiKey {
    switch (this) {
      case apartment:
        return "Apartment";
      case ApartmentType.studio:
        return "Studio";
      case ApartmentType.bed:
        return "Bed";
      case ApartmentType.room:
        return "Room";
    }
  }
}
