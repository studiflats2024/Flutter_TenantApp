import 'package:equatable/equatable.dart';

class KitchenToolApiModel extends Equatable {
  final List<String> kitTool;

  const KitchenToolApiModel({required this.kitTool});

  factory KitchenToolApiModel.fromJson(Map<String, dynamic> json) =>
      KitchenToolApiModel(
        kitTool: json['kit_tool'] != null
            ? (json['kit_tool'] as List<dynamic>)
                .map((e) => e["description"].toString())
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'kit_tool': kitTool,
      };

  @override
  List<Object?> get props => [kitTool];
}
