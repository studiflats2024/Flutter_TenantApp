import 'package:flutter/material.dart';

/// to control all colors, app theme, without any need to dig into code
/// any new color or existing color will have a const with its value
/// there is a stand alone variable for any widget, text, image or icon
///
/// All name colors according to https://chir.ag/projects/name-that-color
///   100% - FF
///   95% - F2
///   90% - E6
///   85% - D9
///   80% - CC
///   75% - BF
///   70% - B3
///   65% - A6
///   60% - 99
///   55% - 8C
///    50% - 80
///    45% - 73
///    40% - 66
///    35% - 59
///   30% - 4D
///   25% - 40
///   20% - 33
///   15% - 26
///   10% - 1A
///    5% - 0D
///   0% - 00

class AppColors {
  static const _black = Colors.black;
  static const _white = Colors.white;

  static const _cloudBurst = Color(0xff183059);
  static const _wildSand = Color(0xffF5F5F5);
  static const _toryBlue = Color(0xFF1151B4);

  static const _gray = Color(0xff667085);

  static const _blackCow = Color(0xff494947);
  static const _alto = Color(0xffD9D9D9);
  static const _nobel = Color(0xffB7B7B7);
  static const _oxfordBlue = Color(0xFF344053);
  static const _mischka = Color(0xFFCFD4DC);
  static const _paleSky = Color(0xFF667084);
  static const _ebony = Color(0xFF0F1728);
  static const _ebonyApprox = Color(0xFF101828);
  static const _mischkaApprox = Color(0xFFD0D5DD);
  static const _codGray = Color(0xFF101010);
  static const _gallerySolid = Color(0xFFEFEFEF);
  static const _fiordApprox = Color(0xFF475467);
  static const _linkWaterApprox = Color(0xFFCFDCF0);
  static const _regentStBlue = Color(0xFFA0B9E1);

  /// app main theme ...
  static const colorSchemeSeed = _cloudBurst;
  static const colorPrimary = _toryBlue;
  static const focus = colorPrimary;
  // static const scaffoldBackground = _wildSand;
  static const scaffoldBackground = _white;
  static const iconTheme = colorPrimary;
  static const placeholder = _nobel;

  static const bottomNavigationBackground = _white;
  static const bottomNavigationSelectedItem = colorPrimary;
  static const bottomNavigationUnselectedItem = _alto;

  static const appBarBackground = colorPrimary;
  static const background = _white;
  static const appBarTextColor = _white;
  static const appBarIcon = _white;

  static const appMainButton = colorPrimary;
  static const appSecondButton = _white;
  static const appCancelButton = _codGray;

  static const floatActionBtnIcon = _white;
  static const floatActionBtnBackground = appSecondButton;

  static const titleMedium = colorPrimary;
  static const headlineMedium = _blackCow;
  static const bodyMedium = _cloudBurst;
  static const labelLarge = _paleSky;
  static const labelMedium = _alto;
  static const labelSmall = _alto;

  /// toast ..
  static const toastBackground = _black;
  static const toastText = _white;

  /// home widget ..

  static const searchItemColor = Color(0xff878787);
  static const productSliderActiveIndicator = colorPrimary;
  static const productSliderDisableIndicator = _white;

  /// app form field
  static const appFormFieldTitle = _oxfordBlue;
  static const appFormFieldFill = _white;
  static const enabledAppFormFieldBorder = _mischka;
  static const appFormFieldErrorIBorder = Colors.red;
  static const suffixIcon = _gray;
  static const success = Color(0xFF027A48);

  static const textWhite = _white;
  static const formFieldText = _black;
  static const formFieldHintText = _paleSky;
  static const formFieldFocusIBorder = colorPrimary;
  static const pinCodeTextFieldFill = _white;
  static const pinCodeTextFieldActive = colorPrimary;
  static const pinCodeTextFieldInactive = colorPrimary;
  static const pinCodeTextFieldSelected = colorPrimary;
  static const countryPickerFormFieldBackground = _white;
  static const countryPickerFormFieldText = formFieldText;
  static const unCountryPickerFormFieldText = _paleSky;

  /// Custom DropDown Widget
  static const appDropdownFill = _white;
  static const appDropdownDisabledBorder = _paleSky;
  static const appDropdownEnabledBorder = _gray;
  static const appDropdownFocusedBorder = colorPrimary;

  /// dialogs ..
  static const closeDialogIcon = _nobel;

  /// paging
  static const paginationLoadingBackground = _white;

  /// app buttons
  static const appButtonText = _white;
  static const appButtonBlueBackground = colorPrimary;
  static const appButtonBlueText = colorPrimary;
  static const appButtonBorder = _mischka;
  static const appButtonWhiteBackground = _white;
  static const appTextButtonText = colorPrimary;
  static const appOutlinedButtonText = colorPrimary;
  static const appOutlinedButtonBorder = colorPrimary;
  static const appShareIcon = _alto;
  static const appCancelButtonBackground = _gallerySolid;

  /// login Screen
  static const loginWithAppleButtonBackground = _white;
  static const loginWithAppleButtonText = _oxfordBlue;
  static const loginWithGoogleButtonBackground = _white;
  static const loginWithGoogleButtonText = _oxfordBlue;
  static const loginTitleText = _ebony;
  static const loginSubTitleText = _paleSky;

  /// profile And Edit Screens
  static const lisTileTitle = _ebonyApprox;
  static const editTitle = _oxfordBlue;
  static const infoText = _fiordApprox;
  static const dividerBackground = _mischkaApprox;
  static const bottomSheetTitle = _codGray;
  static const profilePicBackground = _linkWaterApprox;

  /// assign contract screens
  static const signatureBorderColor = _regentStBlue;

  /// Change Language  widget ..
  static const languageRadioActive = colorPrimary;
  static const languageRadioDeActive = _white;
  static const languageRadioDeActiveBorder = _gray;
  static const languageRadioActiveBorder = _white;
  static const languageRadioIcon = _white;

  static const divider = Color(0xffCACACA);
  static const textColor = Color(0xff344054);
  static const badgeColor = Color(0xFFE4EFFF);

  // new Colors \\
  static const cardColor = Color(0xffEBEBEB);
  static const cardCommunityActionShadow = Color(0xffA1A1A1);
  static const cardBorderGreen = Color(0xff21C36F);
  static const cardBorderGold = Color(0xffEFBF4D);
  static const cardBorderBlue = Color(0xff6136EF);
  static const cardBorderBrown = Color(0xffA85D02);
  static const cardBorderPrimary100 = Color(0xFFE7EEF8);
  static const cardBackgroundCourse = Color(0xFFE7EEF8);
  static const cardBackgroundWorkshop = Color(0xFFF9F0FD);
  static const cardBackgroundEvent = Color(0xFFE9F9F1);
  static const cardBackgroundConsultant = Color(0xFFFEF1F5);
  static const cardBackgroundActivityCancelled = Color(0xFFFEF1F5);
  static const cardTextNatural700 = Color(0xFF727272);
  static const  cardCountdown =  Color(0xffFDF9ED);

  static const textCourse = Color(0xFF1151B4);
  static const textWorkshop = Color(0xFF4F1681);
  static const textEvent = Color(0xFF16814A);
  static const textActivityCancelled = Color(0xFFD02831);
  static const textConsultant = Color(0xFFB4114A);
  static const textNatural400 = Color(0xFFafafaf);
  static const textNatural700 = Color(0xFF475467);
  static const textRed = Color(0xFFC1111A);
  static const textShade3 = Color(0xFF9CA8BA);
  static const textMainColor = Color(0xFF0a0c0f);
  static const dotsNotActive = _linkWaterApprox;
}
