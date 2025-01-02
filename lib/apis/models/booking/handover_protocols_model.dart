import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class HandoverProtocolsModel extends Equatable {
  String title, description;

  HandoverProtocolsModel({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}
