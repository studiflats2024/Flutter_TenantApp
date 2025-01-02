import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/contract_api_manager.dart';
import 'package:vivas/apis/models/contract/check_in_details/check_in_details_response.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';

// ignore: unused_import
import 'package:vivas/feature/complaints/screen/complaints_list_screen.dart';
import 'package:vivas/feature/complaints/screen/send_complaints_screen.dart';
import 'package:vivas/feature/contact_support/screen/contact_support_screen.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/bloc/check_in_details_bloc.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/bloc/check_in_repository.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/widget/check_in_details_section_widget.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/widget/check_in_details_section_with_image_safe_widget.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/widget/rule_list_widget.dart';
import 'package:vivas/feature/contract/check_in_and_rental_details/widget/check_in_details_section_with_image_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/empty_result/status_widget.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';

import '../../../contact_support/screen/chat_screen.dart';

// ignore: must_be_immutable
class CheckInDetailsScreen extends StatelessWidget {
  CheckInDetailsScreen({super.key});

  static const routeName = '/check-in-details-screen';
  static const argumentRequestId = 'requestId';
  static const argumentAptId = 'aptId';
  static const argumentCheckInDetails = 'checkInDetails';

  static Future<void> open(BuildContext context, String requestId, String aptId,
      {CheckInDetailsResponse? checkInDetailsResponse}) async {
    Navigator.of(context).pushNamed(routeName, arguments: {
      argumentRequestId: requestId,
      argumentAptId: aptId,
      argumentCheckInDetails: checkInDetailsResponse
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckInDetailsBloc>(
      create: (context) => CheckInDetailsBloc(CheckInDetailsRepository(
        contractApiManger: ContractApiManger(dioApiManager, context),
      )),
      child: CheckInDetailsScreenWithBloc(
          requestId(context), aptId(context), checkInDetails(context)),
    );
  }

  String requestId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[CheckInDetailsScreen.argumentRequestId] as String;

  String aptId(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[CheckInDetailsScreen.argumentAptId] as String;

  CheckInDetailsResponse checkInDetails(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[CheckInDetailsScreen.argumentCheckInDetails]
          as CheckInDetailsResponse;
}

class CheckInDetailsScreenWithBloc extends BaseStatefulScreenWidget {
  final String requestId, aptId;
  final CheckInDetailsResponse? checkInDetailsResponse;

  const CheckInDetailsScreenWithBloc(
      this.requestId, this.aptId, this.checkInDetailsResponse,
      {super.key});

  @override
  BaseScreenState<CheckInDetailsScreenWithBloc> baseScreenCreateState() {
    return _CheckInDetailsScreenWithBloc();
  }
}

class _CheckInDetailsScreenWithBloc
    extends BaseScreenState<CheckInDetailsScreenWithBloc>
    with AuthValidate, SingleTickerProviderStateMixin {
  late TabController _tabController;

  CheckInDetailsResponse? checkInDetailsResponse;

  @override
  void initState() {
    // Future.microtask(() => _getCheckInDetailsEvent());
    checkInDetailsResponse = widget.checkInDetailsResponse;
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(translate(LocalizationKeys.checkInAndRentalRulesDetails)!)),
      body: BlocConsumer<CheckInDetailsBloc, CheckInDetailsState>(
        listener: (context, state) {
          // if (state is CheckInDetailsLoadingState) {
          //   showLoading();
          // } else {
          //   hideLoading();
          // }
          // if (state is CheckInDetailsErrorState) {
          //   showFeedbackMessage(state.isLocalizationKey
          //       ? translate(state.errorMassage)!
          //       : state.errorMassage);
          // } else if (state is CheckInDetailsLoadedState) {
          //   checkInDetailsResponse = state.checkInDetailsResponse;
          // }
        },
        builder: (context, state) {
          return _checkInDetailsWidgetTabs();
          // if (state is CheckInDetailsLoadingState) {
          //   return const LoaderWidget();
          // } else if (state is CheckInDetailsLoadedState) {
          //   return _checkInDetailsWidgetTabs();
          // } else {
          //   if (checkInDetailsResponse == null) {
          //     return _noUnitData();
          //   } else {
          //     return const LoaderWidget();
          //   }
          // }
        },
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _checkInDetailsWidgetTabs() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1151B4),
          indicatorColor: const Color(0xFF1151B4),
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelColor: const Color(0xFF49454F),
          tabs: [
            Tab(child: Text(translate(LocalizationKeys.checkInDetails)!)),
            Tab(child: Text(translate(LocalizationKeys.rentalRules)!))
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_checkInDetailsWidget(), _checkInDetailRentalRulesWidget()],
      ),
    );
  }

  Widget _checkInDetailRentalRulesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    translate(LocalizationKeys.retnalRulesNotes)!,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 74, 86, 107),
                      height: 1.5,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  RuleListWidget(checkInDetailsResponse!.rentRules!),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkInDetailsWidget() {
    // ignore: unused_local_variable
    var safecode = translate(LocalizationKeys.safecodekeys);

    // ignore: unused_local_variable
    var code = safecode!
        .replaceAll('SafeCode', checkInDetailsResponse!.safeCode ?? "");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    translate(checkInDetailsResponse!.checkInType.toLocaleKey)!,
                    style: const TextStyle(
                      color: Color(0xFF344054),
                      height: 1.5,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CheckInDetailsSectionWidget(LocalizationKeys.address,
                      checkInDetailsResponse!.aptLocation!),
                  CheckInDetailsSectionWithImageWidget(
                      imageUrl:
                          checkInDetailsResponse!.buildingImg.isNullOrEmpty
                              ? []
                              : [checkInDetailsResponse!.buildingImg!],
                      value: "",
                      title: translate(LocalizationKeys.buildingDoor)!),
                  CheckInDetailsSectionWidget(LocalizationKeys.numberOfTheDoor,
                      checkInDetailsResponse!.doorNo),
                  CheckInDetailsSectionWidget(LocalizationKeys.floorNumber,
                      checkInDetailsResponse!.floorNo),
                  CheckInDetailsSectionWithImageWidget(
                    imageUrl: checkInDetailsResponse!.doorImg.isNullOrEmpty
                        ? []
                        : [checkInDetailsResponse!.doorImg!],
                    value: "",
                    title:
                        translate(LocalizationKeys.pictureOfTheApartmentDoor)!,
                  ),
                  CheckInDetailsSectionWithImageSafeWidget(
                      title: translate(LocalizationKeys.selfchecksteps)!,
                      imageUrl: checkInDetailsResponse!.safeImg.isNullOrEmpty
                          ? []
                          : [checkInDetailsResponse!.safeImg!],
                      value: "",
                      subTitle: translate(LocalizationKeys.findsafecode)!,
                      safeCode:
                          checkInDetailsResponse!.safeCode != null ? code : ""),
                  /* CheckInDetailsSectionWithImageWidget(
                    imageUrl: checkInDetailsResponse!.safeImg.isNullOrEmpty
                        ? []
                        : [checkInDetailsResponse!.safeImg!],
                    value: checkInDetailsResponse!.safeCode != null
                        ? "${translate(LocalizationKeys.safeCode)!} : ${checkInDetailsResponse!.safeCode}"
                        : "",
                    title: translate(LocalizationKeys.theSafeCodeAndImage)!,
                  ),*/
                  CheckInDetailsSectionWidget(LocalizationKeys.theMailboxNumber,
                      checkInDetailsResponse!.mailboxNo),
                  CheckInDetailsSectionWidget(
                      LocalizationKeys.locationOfTheApartmentOnTheFloor,
                      checkInDetailsResponse!.aptLocation),
                  CheckInDetailsSectionWithImageWidget(
                    imageUrl: checkInDetailsResponse!.trashImgs!,
                    value: checkInDetailsResponse!.trashLoc,
                    title: translate(LocalizationKeys.trashBinLocation)!,
                  ),
                  if (!checkInDetailsResponse!.wifiName.isNullOrEmpty)
                    _wifiDetailsWidget(checkInDetailsResponse!.wifiName!,
                        checkInDetailsResponse!.wifiPassword!),
                  SizedBox(height: 16.h),
                  _supportWidget(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _wifiDetailsWidget(String name, String password) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Text(
          translate(LocalizationKeys.wifiDetails)!,
          style: const TextStyle(
            color: Color(0xFF344054),
            height: 1.5,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${translate(LocalizationKeys.name)!} : $name",
                style: const TextStyle(
                  color: Color(0xFF344054),
                  height: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "${translate(LocalizationKeys.password)!} : $password",
                style: const TextStyle(
                  color: Color(0xFF344054),
                  height: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        const Divider(height: 4, color: Color.fromARGB(255, 198, 199, 200)),
        /*SizedBox(height: 8.h), */
      ],
    );
  }

  Widget _supportWidget() {
    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 14.0);
    TextStyle linkStyle = const TextStyle(
        color: AppColors.colorPrimary, fontWeight: FontWeight.w600);
    TextStyle mainstyle = const TextStyle(color: Colors.black, fontSize: 16);

    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(
              text: "${translate(LocalizationKeys.morequestion)}  ",
              style: mainstyle),
          TextSpan(
            text: "${translate(LocalizationKeys.support)} ",
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _goToContactSupport(widget.aptId, context),
          ),
        ],
      ),
    );
  }

  void _goToContactSupport(String aptUUID, BuildContext context) async {
    //await ContactSupportScreen.open(context);
    await ChatScreen.open(context,
        unitUUID: aptUUID, openWithReplacement: false);
  }

  Widget imagesWidget(String title, List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(title)!,
          style: const TextStyle(
            color: Color(0xFF344054),
            height: 1.5,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        ListView.builder(
            shrinkWrap: true,
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  padding: EdgeInsets.only(bottom: 12.h),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Image.network(images[index]));
            })
      ],
    );
  }

  Widget _noUnitData() {
    return StatusWidget.notFound(
      onAction: _getCheckInDetailsEvent,
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  CheckInDetailsBloc get currentBloc =>
      BlocProvider.of<CheckInDetailsBloc>(context);

  void _getCheckInDetailsEvent() {
    currentBloc.add(GetCheckInDetailsEvent(widget.requestId));
  }
}

_openSupportScreen(BuildContext context) {
  SendComplaintsScreen.open(context);
}
