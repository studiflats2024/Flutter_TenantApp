// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/managers/general_api_manger.dart';
import 'package:vivas/apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import 'package:vivas/apis/models/apartments/apartment_details/unit_details_api_model.dart';
import 'package:vivas/apis/models/general/faq_list_wrapper.dart';
import 'package:vivas/app_route.dart';
import 'package:vivas/feature/app_pages/screen/faq_list_screen.dart';
import 'package:vivas/feature/bottom_navigation/screen/bottom_navigation_screen.dart';
import 'package:vivas/feature/make_request/model/request_ui_model.dart';
import 'package:vivas/feature/make_request/screen/apartment_request_view.dart';
import 'package:vivas/feature/make_request/screen/make_request_screen.dart';
import 'package:vivas/feature/unit_details/bloc/unit_details_bloc.dart';
import 'package:vivas/feature/unit_details/bloc/unit_details_repository.dart';
import 'package:vivas/feature/unit_details/screen/apartment_contents_screen.dart';
import 'package:vivas/feature/unit_details/widget/uint_details_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_range_form_field_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/utils.dart';
import 'package:vivas/utils/validations/validator.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_icons.dart';
import '../../../utils/locale/app_localization_keys.dart';
import '../../search/widget/new_person_widget.dart';
import '../../widgets/modal_sheet/app_bottom_sheet.dart';

class UnitDetailsScreen extends StatelessWidget {
  UnitDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/unit-details-screen';
  static const argumentUnitId = 'unitId';
  static const argumentMaxPersons = 'maxPersons';
  static const argumentUnitViewOnly = 'unitViewOnly';
  static const argumentRequestUiModel = 'requestUiModel';

  static Future<void> open(BuildContext context, String unitId,
      {RequestUiModel? requestUiModel,
      bool viewOnlyMode = false,
      int maxPerson = 0}) async {
    Navigator.of(context).pushNamed(routeName, arguments: {
      argumentUnitId: unitId,
      argumentMaxPersons: maxPerson,
      argumentUnitViewOnly: viewOnlyMode,
      argumentRequestUiModel: requestUiModel
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  final PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UnitDetailsBloc>(
      create: (context) => UnitDetailsBloc(UnitDetailsRepository(
        apartmentApiManger: ApartmentApiManger(dioApiManager, context),
        generalApiManger: GeneralApiManger(dioApiManager, context),
        preferencesManager: preferencesManager,
      )),
      child: UnitDetailsScreenWithBloc(
        uuid: apartmentItemApiModel(context),
        maxPerson: _maxPerson(context),
        viewOnlyModel: argumentUnitViewOnlyMode(context),
        requestUiModel: argumentRequestModel(context),
      ),
    );
  }

  String apartmentItemApiModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[UnitDetailsScreen.argumentUnitId] as String;

  int _maxPerson(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[UnitDetailsScreen.argumentMaxPersons] as int;

  bool argumentUnitViewOnlyMode(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[UnitDetailsScreen.argumentUnitViewOnly] as bool;

  RequestUiModel? argumentRequestModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[UnitDetailsScreen.argumentRequestUiModel] as RequestUiModel?;
}

class UnitDetailsScreenWithBloc extends BaseStatefulScreenWidget {
  final String uuid;
  final bool viewOnlyModel;
  final int maxPerson;
  final RequestUiModel? requestUiModel;

  const UnitDetailsScreenWithBloc(
      {required this.uuid,
      required this.viewOnlyModel,
      required this.maxPerson,
      this.requestUiModel,
      super.key});

  @override
  BaseScreenState<UnitDetailsScreenWithBloc> baseScreenCreateState() {
    return _UnitDetailsScreenWithBloc();
  }
}

class _UnitDetailsScreenWithBloc
    extends BaseScreenState<UnitDetailsScreenWithBloc> {
  UnitDetailsApiModel? _unitDetailsApiModel;
  ApartmentDetailsApiModelV2? _unitDetailsApiModelV2;
  List<FAQModel> faqList = [];
  bool isGuest = false;

  @override
  void initState() {
    Future.microtask(_getFaqApiEvent);

    Future.microtask(_getIsCheckInEvent);

    Future.microtask(_getUnitDetailsApiEvent);

    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      body: BlocListener<UnitDetailsBloc, UnitDetailsState>(
        listener: (context, state) {
          if (state is UnitDetailLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is IsGuestModeState) {
            isGuest = true;
            AppBottomSheet.showLoginOrRegisterDialog(context);
          }
          if (state is UnitDetailErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is UnitDetailsLoadedState) {
            _unitDetailsApiModel = state.unitDetailsApiModel;
          } else if (state is UnitDetailsLoadedStateV2) {
            _unitDetailsApiModelV2 = state.unitDetailsApiModel;
          } else if (state is FaqLoadedState) {
            faqList = state.faqList;
          }
        },
        child: _detailsWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _detailsWidget() {
    return BlocBuilder<UnitDetailsBloc, UnitDetailsState>(
      buildWhen: (previous, current) {
        if (current is UnitDetailsLoadedState) {
          return true;
        } else if (current is FaqLoadedState) {
          return true;
        } else if (current is UnitDetailsLoadedStateV2) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state is UnitDetailsLoadedState) {
          return UintDetailsWidget(
            viewOnlyModel:
                (widget.viewOnlyModel || !_unitDetailsApiModel!.canMakeRequest),
            unitDetailsApiModel: _unitDetailsApiModel!,
            shareClicked: _shareClicked,
            showAllFeatureClicked: _showAllFeatureClicked,
            showAllFaqClicked: _showAllFaqClicked,
            requestApartmentClicked: _requestApartmentClicked,
            faqList: faqList,
          );
        } else if (state is UnitDetailsLoadedStateV2) {
          return UintDetailsWidgetV2(
            viewOnlyModel:
                (!(_unitDetailsApiModelV2!.canMakeRequest ?? true) || isGuest),
            unitDetailsApiModel: _unitDetailsApiModelV2!,
            shareClicked: _shareClickedV2,
            showAllFeatureClicked: _showAllFeatureClickedV2,
            showAllFaqClicked: _showAllFaqClicked,
            requestApartmentClicked: _requestApartmentClickedV2,
            isGuest: isGuest,
            faqList: faqList,
            maxPersons: widget.maxPerson,
            onBack: onBack,
            requestUiModel: widget.requestUiModel,
          );
        } else if (state is FaqLoadedState) {
          if (_unitDetailsApiModelV2 != null) {
            return UintDetailsWidgetV2(
              viewOnlyModel:
                  (!(_unitDetailsApiModelV2!.canMakeRequest ?? true) ||
                      isGuest),
              unitDetailsApiModel: _unitDetailsApiModelV2!,
              shareClicked: _shareClickedV2,
              showAllFeatureClicked: _showAllFeatureClickedV2,
              showAllFaqClicked: _showAllFaqClicked,
              requestApartmentClicked: _requestApartmentClickedV2,
              isGuest: isGuest,
              faqList: faqList,
              maxPersons: widget.maxPerson,
              onBack: onBack,
              requestUiModel: widget.requestUiModel,
            );
          } else {
            return const LoaderWidget();
          }
        } else {
          if (_unitDetailsApiModel != null) {
            return UintDetailsWidget(
              viewOnlyModel: (widget.viewOnlyModel ||
                  !_unitDetailsApiModel!.canMakeRequest),
              unitDetailsApiModel: _unitDetailsApiModel!,
              shareClicked: _shareClicked,
              showAllFeatureClicked: _showAllFeatureClicked,
              showAllFaqClicked: _showAllFaqClicked,
              requestApartmentClicked: _requestApartmentClicked,
              faqList: faqList,
            );
          } else if (_unitDetailsApiModelV2 != null) {
            return UintDetailsWidgetV2(
              viewOnlyModel:
                  (!(_unitDetailsApiModelV2!.canMakeRequest ?? true) ||
                      isGuest),
              unitDetailsApiModel: _unitDetailsApiModelV2!,
              shareClicked: _shareClickedV2,
              showAllFeatureClicked: _showAllFeatureClickedV2,
              showAllFaqClicked: _showAllFaqClicked,
              requestApartmentClicked: _requestApartmentClickedV2,
              isGuest: isGuest,
              faqList: faqList,
              maxPersons: widget.maxPerson,
              onBack: onBack,
              requestUiModel: widget.requestUiModel,
            );
          } else {
            return const LoaderWidget();
          }
          //Future.microtask(_getUnitDetailsApiEvent);
        }
      },
    );
  }

  onBack() {
    if (Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      AppRoute.mainNavigatorKey.currentState!.pushNamedAndRemoveUntil(
        BottomNavigationScreen.routeName,
        (route) => false,
      );
    }
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  UnitDetailsBloc get currentBloc => BlocProvider.of<UnitDetailsBloc>(context);

  void _getUnitDetailsApiEvent() {
    currentBloc.add(GetUnitDetailsApiEvent(widget.uuid));
  }

  void _getFaqApiEvent() {
    currentBloc.add(const GetFaqApiEvent());
  }

  void _getIsCheckInEvent() {
    currentBloc.add(CheckIsLoggedInEvent());
  }

  void _shareClicked(UnitDetailsApiModel newModel) {}

  Future<File> _downloadImage(String url) async {
    final tempDir = await getTemporaryDirectory();
    String path = "${tempDir.path}/${url.split("/").last}";
    print("$path");
    // Get the image data from the URL
    final response = await GetIt.I.get<DioApiManager>().dio.download(url, path);

    if (response.statusCode == 200) {
      // Get the system's temporary directory

      // Create a file to save the image

      // Write the image data to the file
      return File(path);
    } else {
      throw Exception('Failed to download image');
    }
  }

  Future<void> _shareClickedV2(ApartmentDetailsApiModelV2 newModel) async {
    File file = await _downloadImage(newModel.apartmentImages?[0].url ?? "");
    // File qrFile = await _downloadImage(newModel.apartmentQrImg ?? "");
    await Share.shareFiles([
      file.path,
    ], text: newModel.shareLink);
  }

  void _showAllFeatureClicked() {
    ApartmentContentsScreen.open(context, _unitDetailsApiModel!);
  }

  void _showAllFeatureClickedV2() {
    ApartmentContentsScreenV2.open(context, _unitDetailsApiModelV2!,
        maxPerson: widget.maxPerson);
  }

  void _showAllFaqClicked() {
    FaqListScreen.open(context);
  }

  void _requestApartmentClicked() async {
    await MakeRequestScreen.open(
            context,
            RequestUiModel(
                aptUUID: _unitDetailsApiModel!.generalInfo.aptUuid,
                numberOfGuests: _unitDetailsApiModel!.generalInfo.aptMaxGuest))
        .then((value) => {_getUnitDetailsApiEvent()});
  }

  void _requestApartmentClickedV2() async {
    if(isGuest){
      AppBottomSheet.showLoginOrRegisterDialog(context);
    }else{
      _confirmClicked();
    }

    // await ApartmentRequestView.open(
    //         context,
    //         RequestUiModel(
    //             aptUUID: _unitDetailsApiModelV2!.apartmentId ?? '',
    //             numberOfGuests: widget.maxPerson),
    //         _unitDetailsApiModelV2!)
    //     .then((value) => {_getUnitDetailsApiEvent()});
  }

  void _confirmClicked() async {
    RequestUiModel requestUiModel;
    if (widget.requestUiModel != null) {
      requestUiModel = widget.requestUiModel!;
    } else {
      requestUiModel =
          RequestUiModel(aptUUID: _unitDetailsApiModelV2!.apartmentId ?? '');
    }

    bool? nextStep = await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        context: context,
        builder: (ctx) {
          return Container(
            height: 255.h,
            width: 400.w,
            padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 10.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "${translate(LocalizationKeys.numberOfGuests)}",
                    style: const TextStyle(
                        color: AppColors.formFieldText,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  DateRangeFormFieldWidget(
                    withTitle: false,
                    hintText: translate(LocalizationKeys.selectDate),
                    minStay: _unitDetailsApiModelV2!.minStay,
                    initialValue: requestUiModel.startDate != null &&
                            requestUiModel.endDate != null
                        ? DateTimeRange(
                            start: requestUiModel.startDate!,
                            end: requestUiModel.endDate!)
                        : null,
                    validator: (range) {
                      return Validator.validateTimeRange(range,
                          minStay: _unitDetailsApiModelV2!.minStay ?? 1);
                    },
                    onChangedDate: (DateTimeRange? range) {
                      if (range != null) {
                        requestUiModel.startDate = range.start;
                        requestUiModel.endDate = range.end;
                      }
                    },
                    onSaved: (DateTimeRange? newValue) {},
                    minimumDate: _unitDetailsApiModelV2!.availableFrom != null
                        ? DateTime.now().isBefore(
                                _unitDetailsApiModelV2!.availableFrom!)
                            ? _unitDetailsApiModelV2!.availableFrom!
                            : null
                        : null,
                    maximumDate: _unitDetailsApiModelV2!.availableTo,
                  ),
                  SizedBox(height: 5.h),
                  NewPersonWidget(
                    selected: requestUiModel.numberOfGuests,
                    max: requestUiModel.startDate != null
                        ? _unitDetailsApiModelV2!
                            .countOfAvailableRoomsBedByDate(
                                DateTimeRange(
                                    start: requestUiModel.startDate!,
                                    end: requestUiModel.endDate!),
                                DateTimeRange(
                                  start: _unitDetailsApiModelV2!.availableFrom!,
                                  end: _unitDetailsApiModelV2!.availableTo!,
                                ))
                        : _unitDetailsApiModelV2!.countOfAvailableRoomsBed ==
                                _unitDetailsApiModelV2!.countOfBeds
                            ? _unitDetailsApiModelV2!.countOfAvailableRoomsBed
                            : _unitDetailsApiModelV2!.countOfBeds,
                    changePersonNumberCallBack: (v) {
                      requestUiModel.numberOfGuests = v;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Container(
                          width: 160.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.divider),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text("${translate(LocalizationKeys.cancel)}",
                                style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.formFieldText)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (requestUiModel.numberOfGuests == 0) {
                            showFeedbackMessage(
                                translate(LocalizationKeys.numGuestsMessage) ??
                                    "");
                          } else if (Validator.validateTimeRange(
                                  DateTimeRange(
                                    start: requestUiModel.startDate!,
                                    end: requestUiModel.endDate!,
                                  ),
                                  minStay:
                                      _unitDetailsApiModelV2!.minStay ?? 1) !=
                              null) {
                            Utils.showMessageAlert(
                                context: context,
                                type: ArtSweetAlertType.warning,
                                title: translate(LocalizationKeys.minimumStay)??"",
                                message:
                                    "${translate(LocalizationKeys.periodMessage) ?? "minStay is "} ${_unitDetailsApiModelV2!.minStay} ${translate(_unitDetailsApiModelV2!.minStay == 1 ? LocalizationKeys.month : LocalizationKeys.months)}");
                          }
                          else if (_unitDetailsApiModelV2!
                                  .countOfAvailableRoomsBedByDate(
                                DateTimeRange(
                                  start: requestUiModel.startDate!,
                                  end: requestUiModel.endDate!,
                                ),
                                DateTimeRange(
                                  start: _unitDetailsApiModelV2!.availableFrom!,
                                  end: _unitDetailsApiModelV2!.availableTo!,
                                ),
                              ) ==
                              0) {
                            Utils.showMessageAlert(
                                context: context,
                                type: ArtSweetAlertType.warning,
                                message: translate(LocalizationKeys
                                        .noAvailableBedsOnThisApartmentForDates) ??
                                    "");
                          }
                          else if (requestUiModel.numberOfGuests >
                              _unitDetailsApiModelV2!
                                  .countOfAvailableRoomsBedByDate(
                                DateTimeRange(
                                  start: requestUiModel.startDate!,
                                  end: requestUiModel.endDate!,
                                ),
                                DateTimeRange(
                                  start: _unitDetailsApiModelV2!.availableFrom!,
                                  end: _unitDetailsApiModelV2!.availableTo!,
                                ),
                              )) {
                            Utils.showMessageAlert(
                                context: context,
                                type: ArtSweetAlertType.warning,
                                message: translate(LocalizationKeys
                                        .noAvailableBedsForThoseGuests) ??
                                    "");
                          }
                          else {
                            Navigator.of(ctx).pop(true);
                          }
                        },
                        child: Container(
                          width: 160.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: AppColors.colorPrimary,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              translate(LocalizationKeys.request) ?? "",
                              style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textWhite),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
    if (nextStep == true) {
      ApartmentRequestView.open(context, requestUiModel,
              _unitDetailsApiModelV2!, _getUnitDetailsApiEvent)
          .then((value) => {_getUnitDetailsApiEvent()});
    }
    // currentBloc.add(ValidateFormEvent(requestFormKey));
  }

// void _changeRangeDateCallBack(DateTimeRange? dateRange) {
//   requestUiModel.startDate = dateRange?.start;
//   searchModel.endDate = dateRange?.end;
// }
}
