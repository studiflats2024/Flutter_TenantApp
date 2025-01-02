import 'package:flutter/material.dart';

import '../loading_manager.dart';
import 'base_stateful_widget.dart';

abstract class BaseStatefulScreenWidget extends BaseStatefulWidget {
  const BaseStatefulScreenWidget({Key? key}) : super(key: key);

  @override
  BaseScreenState baseCreateState() => baseScreenCreateState();

  BaseScreenState baseScreenCreateState();
}

abstract class BaseScreenState<W extends BaseStatefulScreenWidget>
    extends BaseState<W> with LoadingManager {
  @override
  Widget baseBuild(BuildContext context) {
    return Material(
      child: Stack(fit: StackFit.expand, children: [
        baseScreenBuild(context),
        loadingManagerWidget(),
      ]),
    );
  }

  void changeState() {
    setState(() {});
  }

  @override
  void runChangeState() {
    changeState();
  }

  @override
  BaseScreenState provideTranslate() {
    return this;
  }

  Widget baseScreenBuild(BuildContext context);
}
