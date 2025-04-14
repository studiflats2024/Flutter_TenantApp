import 'package:flutter/foundation.dart';

bool isDevMode() => false;
bool isDebugMode() => kDebugMode;
bool isReleaseMode() => kReleaseMode;
bool isProfileMode() => kProfileMode;

/// references ...
/// Difference between debug and release and profile mode
/// https://github.com/flutter/flutter/wiki/Flutter%27s-modes
