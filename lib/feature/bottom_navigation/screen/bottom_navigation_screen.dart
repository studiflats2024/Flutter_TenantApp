import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/app_linking.dart';
import 'package:vivas/feature/Community/presentations/Views/community_screen.dart';
import 'package:vivas/feature/bookings/screen/bookings_screen.dart';
import 'package:vivas/feature/bottom_navigation/bloc/bottom_navigation_bloc.dart';
import 'package:vivas/feature/bottom_navigation/widget/app_g_nav.dart';
import 'package:vivas/feature/bottom_navigation/widget/exit_app.dart';
import 'package:vivas/feature/home/screen/home_screen.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/wishlist/screen/wishlist_screen.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

import '../../profile/profile_screen/profile_screen.dart';
import '../widget/app_nav_button.dart';

class BottomNavigationScreen extends StatelessWidget {
  static const routeName = '/bottom_navigation_screen';
  static const bottomNavigationIndex = 'bottom_navigation_index';
  static const deepAppLink = 'deep_link';

  static Future<void> open(BuildContext context, int index,
      {AppLinksDeepLink? appLinksDeepLink}) async {
    await Navigator.of(context).pushNamedAndRemoveUntil(
        BottomNavigationScreen.routeName, (_) => false, arguments: {
      bottomNavigationIndex: index,
      deepAppLink: appLinksDeepLink
    });
  }

  const BottomNavigationScreen({Key? key}) : super(key: key);

  AppLinksDeepLink? deepLink(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      return (arguments as Map)[deepAppLink];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var blocInstance = BottomNavigationBloc();
    return BlocProvider<BottomNavigationBloc>(
      create: (BuildContext context) => blocInstance,
      child: _BottomNavigationScreen(
        indexToOpen(context),
        blocInstance,
        appLinksDeepLink: deepLink(context),
      ),
    );
  }

  int? indexToOpen(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      return (arguments as Map)[bottomNavigationIndex];
    } else {
      return null;
    }
  }
}

class _BottomNavigationScreen extends BaseStatefulScreenWidget {
  final int? indexToOpen;
  final BottomNavigationBloc blocInstance;
  final AppLinksDeepLink? appLinksDeepLink;

  const _BottomNavigationScreen(this.indexToOpen, this.blocInstance,
      {Key? key, this.appLinksDeepLink})
      : super(key: key);

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() =>
      _BottomNavigationScreenState();
}

class _BottomNavigationScreenState
    extends BaseScreenState<_BottomNavigationScreen> {
  int _selectedBottomNavigationIndex = 0;

  @override
  void initState() {
    _selectedBottomNavigationIndex = widget.indexToOpen ?? 0;
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (widget.appLinksDeepLink != null &&
          widget.appLinksDeepLink?.status == AppLinkStatus.apartment) {
        UnitDetailsScreen.open(context, widget.appLinksDeepLink?.id ?? "");
      }
    });
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: _onBackPressed,
      child: Scaffold(
          body: BlocConsumer<BottomNavigationBloc, BottomNavigationState>(
            listener: (context, state) {
              if (state is HomeClickedSte) {
                _selectedBottomNavigationIndex = 0;
              } else if (state is WishlistClickedSte) {
                _selectedBottomNavigationIndex = 1;
              } else if (state is BookingsClickedSte) {
                _selectedBottomNavigationIndex = 2;
              } else if (state is ProfileClickedSte) {
                _selectedBottomNavigationIndex = 3;
              }
            },
            builder: (context, state) {
              if (state is HomeClickedSte) {
                return _homeWidget();
              } else if (state is WishlistClickedSte) {
                 // return _wishlistWidget();
                return _communityWidget();
              } else if (state is BookingsClickedSte) {
                return _bookingsWidget();
              } else if (state is ProfileClickedSte) {
                return _profileWidget();
              } else {
                switch (_selectedBottomNavigationIndex) {
                  case 1:
                     // return _wishlistWidget();
                    return _communityWidget();
                  case 2:
                    return _bookingsWidget();
                  case 3:
                    return _profileWidget();
                  default:
                    return _homeWidget();
                }
              }
            },
          ),
          bottomNavigationBar:
              BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
            builder: (context, state) {
              return Container(
                height: 72.h,
                // padding: EdgeInsets.only(top: 15.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 40,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                  child: GNav(
                    selectedIndex: _selectedBottomNavigationIndex,
                    rippleColor: AppColors.colorPrimary,
                    hoverColor: const Color(0xFFF5F5FF),
                    gap: 8,
                    activeColor: AppColors.colorPrimary,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: const Color(0xFFF5F5FF),
                    color: const Color(0xFF667084),
                    tabs: [
                      GButton(
                        iconAssetPath: AppAssetPaths.navHomeIcon,
                        text: translate(LocalizationKeys.home)!,
                      ),
                      // GButton(
                      //   iconAssetPath: AppAssetPaths.navWishlistIcon,
                      //   text: translate(LocalizationKeys.wishlist)!,
                      // ),
                      GButton(
                        iconAssetPath: AppAssetPaths.community,
                        iconSize: SizeManager.sizeSp25,
                        text: translate(LocalizationKeys.community)!,
                      ),
                      GButton(
                        iconAssetPath: AppAssetPaths.navBookmarkIcon,
                        text: translate(LocalizationKeys.bookings)!,
                      ),
                      GButton(
                        iconAssetPath: AppAssetPaths.navProfileIcon,
                        text: translate(LocalizationKeys.profile)!,
                      ),
                    ],
                    onTabChange: _onItemTapped,
                  ),
                ),
              );
            },
          )),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _homeWidget() {
    return HomeScreen();
  }

  Widget _wishlistWidget() {
    return WishlistScreen();
  }

  Widget _profileWidget() {
    return const ProfileScreen();
  }

  Widget _bookingsWidget() {
    return BookingsScreen();
  }

  Widget _communityWidget() {
    return  CommunityScreen();
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  // we are not using the below because the hot reload or restart can not get the current bloc instance.
  //BottomNavigationBloc get currentBloc => widget.blocInstance;
  BottomNavigationBloc get currentBloc =>
      BlocProvider.of<BottomNavigationBloc>(context);

  void _onBackPressed(bool value) async {
    if (cnBack) {
       AppBottomSheet.openAppBottomSheet(
          context: context,
          child: ExitApp(exitApp: _exitApp),
          title: translate(LocalizationKeys.exitApp) ?? "Exit App");
    } else {
      _onItemTapped(0);
    }
  }

  void _exitApp() {
    if (Platform.isAndroid) {
      // Exit for Android
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      // Force exit for iOS (not App Store-friendly)
      exit(0);
    }
  }

  bool get cnBack => _selectedBottomNavigationIndex == 0;

  void _onItemTapped(int index) {
    currentBloc.add(ItemBottomNavigationClickedEvt(index));
  }
}
