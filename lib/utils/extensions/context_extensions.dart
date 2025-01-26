import 'package:flutter/material.dart';
extension AdaptiveCount on BuildContext {
  T withFormFactor<T>({
    required T onMobile,
    required T onTablet,
    required T onDesktop,
    bool followDeviceOrientation = true,
  }) {
    final formFactor = this.formFactor(
      followDeviceOrientation: followDeviceOrientation,
    );

    return formFactor.isMobile
        ? onMobile
        : formFactor.isTablet
        ? onTablet
        : onDesktop;
  }
  DeviceType formFactor({bool followDeviceOrientation = true}) {
    final width = followDeviceOrientation
        ? mediaQuery.size.width
        : mediaQuery.size.shortestSide;

    return width > ScreenWidthBreakpoints.desktop
        ? DeviceType.desktop
        : width > ScreenWidthBreakpoints.tablet
        ? DeviceType.tablet
        : DeviceType.mobile;
  }
}

class ScreenWidthBreakpoints {
  static const double desktop = 900;
  static const double tablet = 600;
  static const double mobile = 300;
}

extension FormFactorHelpers on DeviceType {
  bool get isDesktop => this == DeviceType.desktop;
  bool get isTablet => this == DeviceType.tablet;
  bool get isMobile => this == DeviceType.mobile;
}

extension MediaQueryExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  bool get isKeyBoardOpen => MediaQuery.of(this).viewInsets.bottom > 0;
  double get screenHeight => mediaQuery.size.height;
  double get screenWidth => mediaQuery.size.width;
}

enum DeviceType {
  desktop,
  tablet,
  mobile,
}