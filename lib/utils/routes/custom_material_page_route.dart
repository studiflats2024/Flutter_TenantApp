import 'package:flutter/material.dart';

class CustomMaterialPageRoute extends MaterialPageRoute {
  @override
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }

  CustomMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullScreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullScreenDialog,
        );
}

/// references ...
/// this class to fix swipe back in ios
/// WillPopScope disables 'swipe back gesture' feature on iOS
/// https://github.com/flutter/flutter/issues/14203#issuecomment-540663717
