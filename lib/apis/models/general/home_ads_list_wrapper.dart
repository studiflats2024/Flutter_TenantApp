import 'package:equatable/equatable.dart';

// ApartmentDetailsWrapper
class HomeAdsListWrapper extends Equatable {
  final List<HomeAdsModel> data;

  const HomeAdsListWrapper({
    required this.data,
  });

  factory HomeAdsListWrapper.fromJson(List<dynamic>? json) =>
      HomeAdsListWrapper(
        data: json != null
            ? (json)
                .map((e) => HomeAdsModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );

  @override
  List<Object?> get props {
    return [data];
  }
}

class HomeAdsModel extends Equatable {
  final String adsID;
  final String url;
  final String photoAttach;
  final String buttonName;

  const HomeAdsModel({
    required this.adsID,
    required this.url,
    required this.photoAttach,
    required this.buttonName,
  });

  factory HomeAdsModel.fromJson(Map<String, dynamic> json) => HomeAdsModel(
        adsID: json['ads_ID'] as String,
        url: json['url'] as String,
        photoAttach: json['photo_Attach'] as String,
        buttonName: json['button_Name'] as String,
      );

  @override
  List<Object?> get props {
    return [
      adsID,
      url,
      photoAttach,
      buttonName,
    ];
  }
}
