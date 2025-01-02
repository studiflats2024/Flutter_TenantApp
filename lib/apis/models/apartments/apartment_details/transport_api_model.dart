import 'package:equatable/equatable.dart';

class TransportApiModel extends Equatable {
  final String tName;
  final String tDistance;

  const TransportApiModel({required this.tName, required this.tDistance});

  factory TransportApiModel.fromJson(Map<String, dynamic> json) =>
      TransportApiModel(
        tName: json['t_Name'] as String,
        tDistance: json['t_Distance'] as String,
      );

  Map<String, dynamic> toJson() => {
        't_Name': tName,
        't_Distance': tDistance,
      };

  @override
  List<Object?> get props => [tName, tDistance];
}
