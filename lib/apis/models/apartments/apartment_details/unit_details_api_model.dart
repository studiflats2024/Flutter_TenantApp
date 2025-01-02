import 'package:equatable/equatable.dart';
import 'package:vivas/feature/widgets/reviews/model/reviews_ui_model.dart';

import 'bath_room_api_model.dart';
import 'facility_api_model.dart';
import 'feature_api_model.dart';
import 'general_info_api_model.dart';
import 'kitchen_tool_api_model.dart';
import 'room_api_model.dart';
import 'transport_api_model.dart';

// ignore: must_be_immutable
class UnitDetailsApiModel extends Equatable {
  final GeneralInfoApiModel generalInfo;
  final List<TransportApiModel> transports;
  final List<RoomApiModel> rooms;
  final List<BathRoomApiModel> bathRoom;
  final KitchenToolApiModel kitchenTools;
  final FeatureApiModel features;
  final FacilityApiModel facilities;
  final List<ReviewsUiModel> reviewsList;
  final double rate;
  bool isWishlist = false;
  bool canMakeRequest = false;
  UnitDetailsApiModel({
    required this.generalInfo,
    required this.transports,
    required this.rooms,
    required this.bathRoom,
    required this.kitchenTools,
    required this.features,
    required this.facilities,
    required this.reviewsList,
    required this.rate,
    required this.canMakeRequest,
    required this.isWishlist,
  });

  factory UnitDetailsApiModel.fromJson(Map<String, dynamic> json) =>
      UnitDetailsApiModel(
        generalInfo: GeneralInfoApiModel.fromJson(
            json['general_Info'] as Map<String, dynamic>),
        transports: json['trasponrts'] != null
            ? (json['trasponrts'] as List<dynamic>)
                .map((e) =>
                    TransportApiModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        rooms: json['rooms'] != null
            ? (json['rooms'] as List<dynamic>)
                .map((e) => RoomApiModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        bathRoom: json['bath_Room'] != null
            ? (json['bath_Room'] as List<dynamic>)
                .map(
                    (e) => BathRoomApiModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        facilities: (json['facilities'] as List<dynamic>).isNotEmpty
            ? FacilityApiModel.fromJson((json['facilities'] as List<dynamic>)[0]
                as Map<String, dynamic>)
            : const FacilityApiModel(facNames: []),
        kitchenTools: (json['kitchen_Tools'] as List<dynamic>).isNotEmpty
            ? KitchenToolApiModel.fromJson((json['kitchen_Tools']
                as List<dynamic>)[0] as Map<String, dynamic>)
            : const KitchenToolApiModel(kitTool: []),
        features: (json['features'] as List<dynamic>).isNotEmpty
            ? FeatureApiModel.fromJson(
                (json['features'] as List<dynamic>)[0] as Map<String, dynamic>)
            : const FeatureApiModel(fetNames: []),
        reviewsList: ReviewsUiModel.demo,
        rate: 4.7,
        canMakeRequest: !(json['exist_req'] as bool? ?? false),
        isWishlist: (json["general_Info"]['is_Wish'] as bool? ?? false),
      );

  Map<String, dynamic> toJson() => {
        'general_Info': generalInfo.toJson(),
        'trasponrts': transports.map((e) => e.toJson()).toList(),
        'rooms': rooms.map((e) => e.toJson()).toList(),
        'bath_Room': bathRoom.map((e) => e.toJson()).toList(),
        'kitchen_Tools': kitchenTools.toJson(),
        'features': features.toJson(),
        'facilities': facilities.toJson(),
      };

  @override
  List<Object?> get props {
    return [
      generalInfo,
      transports,
      rooms,
      bathRoom,
      kitchenTools,
      features,
      facilities,
    ];
  }
}
