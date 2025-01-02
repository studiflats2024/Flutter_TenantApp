import 'package:equatable/equatable.dart';

class ApartmentRulesModel extends Equatable{
  String title;
  List<String> description;

  ApartmentRulesModel({required this.title, required this.description});

  @override
  // TODO: implement props
  List<Object?> get props => [
    title,
    description
  ];


}