import 'package:equatable/equatable.dart';

class RoomApiModel extends Equatable {
  final String roomName;
  final String roomType;
  final List<String> roomTools;

  const RoomApiModel(
      {required this.roomName,
      required this.roomType,
      required this.roomTools});

  factory RoomApiModel.fromJson(Map<String, dynamic> json) => RoomApiModel(
        roomName: json['room_Name'] as String,
        roomType: json['room_Type'] as String,
        roomTools: json['room_Tools'] != null
            ? (json['room_Tools'] as List<dynamic>)
                .map((e) => e["tool_Name"].toString())
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'room_Name': roomName,
        'room_Type': roomType,
        'room_Tools': roomTools,
      };

  bool get isBedRoom => roomType == "Bedroom";

  @override
  List<Object?> get props => [roomName, roomType, roomTools];
}
