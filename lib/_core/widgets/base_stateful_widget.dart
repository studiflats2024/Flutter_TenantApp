import 'package:flutter/material.dart';

import '../platform_manager.dart';
import '../screen_sizer.dart';
import '../themer.dart';
import '../translator.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  BaseState createState() => baseCreateState();

  BaseState baseCreateState();
}

abstract class BaseState<W extends BaseStatefulWidget> extends State<W>
    with Translator, ScreenSizer, PlatformManager, Themer {
  @override
  void didChangeDependencies() {
    initTranslator(context);
    initScreenSizer(context);
    initThemer(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return baseBuild(context);
  }

  Widget baseBuild(BuildContext context);
}
