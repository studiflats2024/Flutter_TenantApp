import 'package:flutter/material.dart';

import '../../_core/widgets/base_stateless_widget.dart';
import '../locale/app_localization_keys.dart';

// ignore: must_be_immutable
class NoResultFoundWidget extends BaseStatelessWidget {
  final String? message;
  NoResultFoundWidget({this.message, super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Center(child: Text(message ?? translate(LocalizationKeys.noData)!));
  }
}
