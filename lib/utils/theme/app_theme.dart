import 'package:vivas/res/app_colors.dart';
import 'package:flutter/material.dart';

abstract class BaseAppTheme {
  ThemeData get themeDataLight;

  TextTheme get txtThemeLight;

  ThemeData get themeDataDark;

  TextTheme get txtThemeDark;
}

class LightAppTheme implements BaseAppTheme {
  /// The Light Theme
  @override
  ThemeData get themeDataLight {
    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.colorSchemeSeed,
        primary: AppColors.colorPrimary,
      ),
      primaryColor: AppColors.colorPrimary,
      brightness: Brightness.light,
      focusColor: AppColors.focus,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      textTheme: txtThemeLight,
      cardTheme: ThemeData.light().cardTheme.copyWith(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      iconTheme:
          ThemeData.light().iconTheme.copyWith(color: AppColors.iconTheme),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: AppColors.floatActionBtnIcon,
        backgroundColor: AppColors.floatActionBtnBackground,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: AppColors.bottomNavigationSelectedItem,
          unselectedItemColor: AppColors.bottomNavigationUnselectedItem,
          backgroundColor: AppColors.bottomNavigationBackground),
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
            elevation: 0,
            iconTheme: ThemeData.light().iconTheme.copyWith(
                  color: const Color(0xFF101828),
                ),
            centerTitle: false,
            titleTextStyle: const TextStyle(
              color: Color(0xFF0F1728),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: Colors.white,
          ),
    );
  }

  @override
  TextTheme get txtThemeLight => ThemeData.light().textTheme.copyWith(
        headlineMedium: ThemeData.light()
            .textTheme
            .headlineMedium
            ?.copyWith(color: AppColors.headlineMedium, fontSize: 22),
        bodyMedium: ThemeData.light().textTheme.bodyMedium?.copyWith(
              color: AppColors.bodyMedium,
              fontSize: 16,
            ),
        titleMedium: ThemeData.light().textTheme.titleMedium?.copyWith(
              color: AppColors.titleMedium,
            ),
        // for subtitle
        labelLarge: ThemeData.light().textTheme.labelLarge?.copyWith(
              color: AppColors.labelLarge,
            ),
        labelMedium: ThemeData.light().textTheme.labelMedium?.copyWith(
              color: AppColors.labelMedium,
            ),
        labelSmall: ThemeData.light().textTheme.labelSmall?.copyWith(
              color: AppColors.labelSmall,
            ),
      );

  @override
  ThemeData get themeDataDark => themeDataLight;

  @override
  TextTheme get txtThemeDark => txtThemeLight;
}
