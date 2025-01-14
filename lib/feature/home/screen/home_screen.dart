import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/managers/general_api_manger.dart';
import 'package:vivas/apis/models/apartments/ApartmentQrDetails/apartment_qr_details_model.dart';
import 'package:vivas/apis/models/apartments/apartment_list/apartment_item_api_model.dart';
import 'package:vivas/apis/models/contract/check_in_details/check_in_details_response.dart';
import 'package:vivas/apis/models/general/home_ads_list_wrapper.dart';
import 'package:vivas/feature/contact_support/screen/chat_history_screen.dart';
import 'package:vivas/feature/contact_support/screen/chat_screen.dart';
import 'package:vivas/feature/contract/sign_contract/screen/sign_extend_contract.dart';
import 'package:vivas/feature/filter/model/filter_model.dart';
import 'package:vivas/feature/home/bloc/home_bloc.dart';
import 'package:vivas/feature/home/bloc/home_repository.dart';
import 'package:vivas/feature/home/widget/home_slider_widget.dart';
import 'package:vivas/feature/notification_list/screen/notification_list_screen.dart';
import 'package:vivas/feature/problem/screen/report_apartment_screen.dart';
import 'package:vivas/feature/search/model/search_model.dart';
import 'package:vivas/feature/search/screen/search_widget.dart';
import 'package:vivas/feature/search_result/screen/search_result_screen.dart';
import 'package:vivas/feature/uint_widget/unit_widget.dart';
import 'package:vivas/feature/unit_details/screen/unit_details_screen.dart';
import 'package:vivas/feature/unit_list/screen/unit_list_screen.dart';
import 'package:vivas/feature/widgets/search/search_bar_widget.dart';
import 'package:vivas/mangers/notification_manger.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../contract/check_in_and_rental_details/screen/check_in_details_screen.dart';
import '../../request_details/request_details/screen/request_details_screen_v2.dart';
import '../../widgets/modal_sheet/app_bottom_sheet.dart';
import 'apartment_qr_code_details.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';

  static Future<void> open(BuildContext context) async {
    await Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomeScreen()), (_) => false);
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(HomeRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        apartmentApiManger: ApartmentApiManger(dioApiManager, context),
        generalApiManger: GeneralApiManger(dioApiManager, context),
      )),
      child: const HomeScreenWithBloc(),
    );
  }
}

class HomeScreenWithBloc extends BaseStatefulScreenWidget {
  const HomeScreenWithBloc({super.key});

  @override
  BaseScreenState<HomeScreenWithBloc> baseScreenCreateState() {
    return _HomeScreenWithBloc();
  }
}

class _HomeScreenWithBloc extends BaseScreenState<HomeScreenWithBloc>
    with SingleTickerProviderStateMixin {
  List<HomeAdsModel> _sliderInfoList = [];
  List<ApartmentItemApiModel> _unitList = [];
  List<ApartmentItemApiV2Model> _unitListV2 = [];
  ScrollController scrollController = ScrollController();
  late AnimationController expandController;
  late Animation<double> animation;
  bool expand = false;
  Barcode? scanData;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  void initState() {
    Future.microtask(_getSliderInfoApi);
    Future.microtask(_getNotificationCountApi);
    Future.microtask(_getBestOfferInfoApiEvent);
    Future.microtask(_checkNotification);
    _prepareAnimations();
    _runExpandCheck();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 1000), () async {
        _checkNotification();
      });
    });
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (scrollController.position.atEdge) {
          if (scrollController.position.pixels == 0) {
            _runExpandCheck();
          }
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (expand) {
          _runExpandCheck();
        }
      }
    });
    super.initState();
  }

  void _prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (!expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
    setState(() {
      expand = !expand;
    });
  }

  Future<void> checkCameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isGranted) {
      ApartmentQrCodeDetails.open(context, currentBloc);
    } else if (status.isDenied) {
      var result = await Permission.camera.request();
      if (result.isGranted) {
        ApartmentQrCodeDetails.open(context, currentBloc);
      } else {}
    } else if (status.isPermanentlyDenied) {
      var value = await openAppSettings();
      if (value) {
        ApartmentQrCodeDetails.open(context, currentBloc);
      } else {}
    }
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          AppAssetPaths.appLogoTitle,
          height: 40,
        ),
        leading: IconButton(
            onPressed: () async {
              // showAppDialog(context: context, dialogWidget: dialogWidget, shouldPop: shouldPop)
              await checkCameraPermission();
            },
            icon: Icon(
              Icons.qr_code_scanner_sharp,
              color: AppColors.colorPrimary,
              size: 30.r,
            )),
        actions: [
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) {
              if (current is HomeCountsLoadedState) return true;
              return false;
            },
            builder: (context, state) {
              if (state is HomeCountsLoadedState) {
                return badges.Badge(
                  onTap: _openChatScreen,
                  badgeContent: Text(
                    state.chatsCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: GestureDetector(
                      onTap: _openChatScreen,
                      child:
                          SvgPicture.asset(AppAssetPaths.chatIcon, height: 25)),
                );
              }
              return badges.Badge(
                onTap: _openChatScreen,
                showBadge: false,
                child: GestureDetector(
                    onTap: _openChatScreen,
                    child:
                        SvgPicture.asset(AppAssetPaths.chatIcon, height: 25)),
              );
            },
          ),
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) {
              if (current is HomeCountsLoadedState) return true;
              return false;
            },
            builder: (context, state) {
              if (state is HomeCountsLoadedState) {
                return badges.Badge(
                    onTap: _openNotificationScreen,
                    badgeContent: Text(
                      state.notificationsCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: GestureDetector(
                      onTap: _openNotificationScreen,
                      child: SvgPicture.asset(AppAssetPaths.notificationsIcon,
                          height: 25,
                          colorFilter: const ColorFilter.mode(
                              AppColors.colorPrimary, BlendMode.srcIn)),
                    ));
              }
              return badges.Badge(
                  onTap: _openNotificationScreen,
                  showBadge: false,
                  child: GestureDetector(
                    onTap: _openNotificationScreen,
                    child: SvgPicture.asset(AppAssetPaths.notificationsIcon,
                        height: 25,
                        colorFilter: const ColorFilter.mode(
                            AppColors.colorPrimary, BlendMode.srcIn)),
                  ));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) async {
            _checkNotification();
            if (state is HomeLoadingState) {
              showLoading();
            } else {
              hideLoading();
            }
            if (state is HomeErrorState) {
              if ((await GetIt.I<PreferencesManager>().isLoggedIn())) {
                showFeedbackMessage(state.isLocalizationKey
                    ? translate(state.errorMassage)!
                    : state.errorMassage);
              }
            } else if (state is HomeSliderInfoLoadedState) {
              _sliderInfoList = state.list;
            } else if (state is HomeOfferInfoLoadedState) {
              _unitList = state.list;
            } else if (state is HomeOfferInfoLoadedStateV2) {
              _unitListV2 = state.list;
            } else if (state is HomeQrDetailsResponseState) {
              if (state.apartmentQrDetailsModel.bookingId == null) {
                UnitDetailsScreen.open(
                    context, state.apartmentQrDetailsModel.apartmentId ?? '',
                    maxPerson: state.apartmentQrDetailsModel.apartmentPersonsNo
                            ?.toInt() ??
                        0);
              } else {
                bookingSheet(state.apartmentQrDetailsModel);
              }
            } else if (state is OpenUnitListScreenState) {
              _openAllOfferUnitScreen();
            }
          },
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Stack(
                children: [
                  Visibility(
                    visible: !expand,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                      child: SearchBarWidget(
                        filterModel: FilterModel(),
                        searchModel: SearchModel(),
                        filterSearchClicked: _openSearchScreenAfterFilter,
                        searchScreenClicked: _openSearchScreenAfterSearch,
                        fromHome: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                    child: SizeTransition(
                        axisAlignment: 1.0,
                        sizeFactor: animation,
                        child: SearchWidget(
                          initSearchModel: SearchModel(),
                          searchCallBack: _openSearchScreenAfterSearch,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _sliderWidget(),
                        SizedBox(height: 15.h),
                        _titleWidget(),
                        SizedBox(height: 15.h),
                        _unitListWidgetV2(),
                        SizedBox(height: 15.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _sliderWidget() {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) {
        if (current is HomeSliderInfoLoadedState ||
            current is HomeQrDetailsResponseState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state is HomeSliderInfoLoadedState ||
            state is HomeQrDetailsResponseState) {
          if (_sliderInfoList.isEmpty) return const EmptyWidget();
          return HomeSliderWidget(_sliderInfoList);
        } else {
          return const EmptyWidget();
        }
      },
    );
  }

  Widget _titleWidget() {
    return Row(
      children: [
        Text(translate(LocalizationKeys.bestOffer)!,
            style: TextStyle(
              color: const Color(0xFF0F1728),
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            )),
        const Spacer(),
        GestureDetector(
          onTap: _bestOfferSeeAllClicked,
          child: Text(
            translate(LocalizationKeys.seeAll)!,
            style: TextStyle(
              color: const Color(0xFF1151B4),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _unitListWidget() {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => current is HomeOfferInfoLoadedState,
      builder: (context, state) {
        if (state is HomeOfferInfoLoadedState) {
          return ResponsiveGridList(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            desiredItemWidth: 340,
            minSpacing: 0,
            scroll: false,
            children: _unitList
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: UintWidget(
                        cardClickCallback: _unitClickCallback,
                        apartmentItemApiModel: e,
                      ),
                    ))
                .toList(),
          );
        } else {
          return const LoaderWidget();
        }
      },
    );
  }

  Widget _unitListWidgetV2() {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          current is HomeOfferInfoLoadedStateV2 ||
          current is HomeQrDetailsResponseState,
      builder: (context, state) {
        if (state is HomeOfferInfoLoadedStateV2 ||
            state is HomeQrDetailsResponseState) {
          return ResponsiveGridList(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            desiredItemWidth: 340.w,
            minSpacing: 0,
            scroll: false,
            children: _unitListV2
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: UintWidgetV2(
                        cardClickCallback: _unitClickCallbackV2,
                        apartmentItemApiV2Model: e,
                      ),
                    ))
                .toList(),
          );
        } else {
          return const LoaderWidget();
        }
      },
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  HomeBloc get currentBloc => BlocProvider.of<HomeBloc>(context);

  void _getSliderInfoApi() {
    currentBloc.add(const GetSliderInfoApiEvent());
  }

  void _getNotificationCountApi() {
    currentBloc.add(const GetNotificationCountApiEvent());
  }

  void _getBestOfferInfoApiEvent() {
    currentBloc.add(const GetBestOfferInfoApiEvent());
  }

  void _openSearchScreenAfterSearch(SearchModel searchModel) {
    SearchResultScreen.open(context,
        withReplacement: false,
        filterModel: FilterModel(),
        searchModel: searchModel);
  }

  void _openSearchScreenAfterFilter(FilterModel filterModel) {
    SearchResultScreen.open(context,
        withReplacement: false,
        filterModel: filterModel,
        searchModel: SearchModel());
  }

  void _bestOfferSeeAllClicked() {
    currentBloc.add(const BestOfferSeeAllClickedEvent());
  }

  void _openAllOfferUnitScreen() {
    UnitListScreen.open(context, translate(LocalizationKeys.bestOffer)!);
  }

  void _unitClickCallback(ApartmentItemApiModel model) {
    UnitDetailsScreen.open(
      context,
      model.aptUuid,
    );
  }

  void _unitClickCallbackV2(ApartmentItemApiV2Model model) {
    UnitDetailsScreen.open(context, model.apartmentId ?? '',
        maxPerson: model.apartmentPersonsNo ?? 0);
  }

  Future<void> _checkNotification() async {
    if (GetIt.I<NotificationManager>().canOpenNotification) {
      await GetIt.I<NotificationManager>().openNotification();
    }
  }

  void _openNotificationScreen() {
    NotificationListScreen.open(context);
  }

  void _openChatScreen() {
    ChatHistoryScreen.open(context);
  }

  Future bookingSheet(ApartmentQrDetailsModel model) async {
    String? action = await AppBottomSheet.openAppBottomSheet(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.h,
            ),
            TextButton(
              onPressed: () {
                RequestDetailsScreenV2.open(
                  context,
                  model.bookingId ?? "",
                );
              },
              child: Text(
                translate(LocalizationKeys.bookingDetails)!,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TextButton(
              onPressed: () {
                CheckInDetailsScreen.open(
                    context, model.bookingId ?? '', model.apartmentId ?? "",
                    checkInDetailsResponse: model.checkInRules);
              },
              child: Text(
                translate(LocalizationKeys.checkInDetails)!,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            if (model.extendContract != null) ...[
              TextButton(
                onPressed: (model.extendContract?.extendContractSigned ?? false)
                    ? null
                    : () {
                        SignExtendContractScreen.open(
                          context,
                          model.extendContract?.id ?? "",
                          false,
                            (){}
                        );
                      },
                child: Text(
                  (model.extendContract?.extendContractSigned ?? false)
                      ? "${translate(LocalizationKeys.extendedTo)!} ${AppDateFormat.formattingApiDateFromString(model.extendContract!.extendingTo!.toString())}"
                      : translate(LocalizationKeys.signYourExtendedContract)!,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
            TextButton(
              onPressed: () {
                ReportApartmentScreen.open(context, model.apartmentId ?? "");
              },
              child: Text(
                translate(LocalizationKeys.reportProblem)!,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TextButton(
                onPressed: () {
                  _goToContactSupport(model.apartmentId ?? "");
                },
                child: Text(
                  translate(LocalizationKeys.contactSupport)!,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                )),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
        title: translate(LocalizationKeys.bookingActions)!);
  }

  void _goToContactSupport(String aptUUID) async {
    //await ContactSupportScreen.open(context);
    await ChatScreen.open(context,
        unitUUID: aptUUID, openWithReplacement: false);
  }
}
