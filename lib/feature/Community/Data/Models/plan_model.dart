import 'package:flutter/material.dart';

class PlanModel {
  String name;
  String description;
  String type;
  num price;
  Color color;
  String asset;
  List<String> features;

  PlanModel(
    this.name,
    this.description,
    this.type,
    this.price,
    this.color,
    this.asset,
    this.features,
  );
}
