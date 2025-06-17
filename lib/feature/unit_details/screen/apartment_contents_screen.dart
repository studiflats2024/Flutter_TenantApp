//

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/managers/general_api_manger.dart';
import 'package:vivas/apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import 'package:vivas/apis/models/apartments/apartment_details/unit_details_api_model.dart';
import 'package:vivas/feature/unit_details/bloc/unit_details_bloc.dart';
import 'package:vivas/feature/unit_details/bloc/unit_details_repository.dart';
import 'package:vivas/feature/unit_details/widget/content_item_widget.dart';
import 'package:vivas/feature/unit_details/widget/general_details_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ApartmentContentsScreen extends StatelessWidget {
  ApartmentContentsScreen({Key? key}) : super(key: key);
  static const routeName = '/apartment-contents-screen';
  static const argumentUnitDetailsApiModel = 'unitDetailsApiModel';

  static Future<void> open(BuildContext context,
      UnitDetailsApiModel unitDetailsApiModel) async {
    Navigator.of(context).pushNamed(routeName, arguments: {
      argumentUnitDetailsApiModel: unitDetailsApiModel,
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  final PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UnitDetailsBloc>(
      create: (context) =>
          UnitDetailsBloc(UnitDetailsRepository(
            apartmentApiManger: ApartmentApiManger(dioApiManager, context),
            preferencesManager: preferencesManager,
            generalApiManger: GeneralApiManger(dioApiManager, context),
          )),
      child: ApartmentContentsScreenWithBloc(unitDetailsApiModel(context)),
    );
  }

  UnitDetailsApiModel unitDetailsApiModel(BuildContext context) =>
      (ModalRoute
          .of(context)!
          .settings
          .arguments
      as Map)[ApartmentContentsScreen.argumentUnitDetailsApiModel]
      as UnitDetailsApiModel;
}

class ApartmentContentsScreenWithBloc extends BaseStatefulScreenWidget {
  final UnitDetailsApiModel unitDetailsApiModel;

  const ApartmentContentsScreenWithBloc(this.unitDetailsApiModel, {super.key});

  @override
  BaseScreenState<ApartmentContentsScreenWithBloc> baseScreenCreateState() {
    return _ApartmentContentsScreenWithBloc();
  }
}

class _ApartmentContentsScreenWithBloc
    extends BaseScreenState<ApartmentContentsScreenWithBloc> {
  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: Text(translate(LocalizationKeys.apartmentDetails)!)),
      body: BlocListener<UnitDetailsBloc, UnitDetailsState>(
        listener: (context, state) {
          if (state is UnitDetailLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is UnitDetailErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.unitDetailsApiModel.features.fetNames.isNotEmpty)
              ContentItemWidget.specialFeatures(
                  widget.unitDetailsApiModel.features.fetNames),
            GeneralDetailsWidget(
              floorNumber: widget.unitDetailsApiModel.generalInfo.aptFloorNo,
              maxNumberOfGuest:
              widget.unitDetailsApiModel.generalInfo.aptMaxGuest,
            ),
            SizedBox(height: 15.h),
            ...widget.unitDetailsApiModel.rooms
                .map((e) =>
                ContentItemWidget(
                  assetPath: e.isBedRoom
                      ? AppAssetPaths.unitBedroomIcon
                      : AppAssetPaths.unitLivingRooIcon,
                  listOfFeature: e.roomTools,
                  title: e.roomType,
                  titleIsLocalizationKey: false,
                ))
                .toList(),
            ...widget.unitDetailsApiModel.bathRoom
                .map((e) =>
                ContentItemWidget(
                  assetPath: AppAssetPaths.unitBathroomIcon,
                  listOfFeature: e.bathTools,
                  title: e.bathName,
                  titleIsLocalizationKey: false,
                ))
                .toList(),
            if (widget.unitDetailsApiModel.kitchenTools.kitTool.isNotEmpty) ...[
              ContentItemWidget.kitchen(
                  widget.unitDetailsApiModel.kitchenTools.kitTool),
              SizedBox(height: 15.h),
            ],
            if (widget.unitDetailsApiModel.facilities.facNames.isNotEmpty) ...[
              ContentItemWidget.otherFacilities(
                  widget.unitDetailsApiModel.facilities.facNames),
              SizedBox(height: 15.h),
            ],
          ],
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  UnitDetailsBloc get currentBloc => BlocProvider.of<UnitDetailsBloc>(context);
}

class ApartmentContentsScreenV2 extends StatelessWidget {
  ApartmentContentsScreenV2({Key? key}) : super(key: key);
  static const routeName = '/apartment-contents-screen-v2';
  static const argumentUnitDetailsApiModel = 'unitDetailsApiModel';
  static const argumentMaxPersons = 'maxPersons';

  static Future<void> open(BuildContext context,
      ApartmentDetailsApiModelV2 unitDetailsApiModel,
      {int maxPerson = 0}) async {
    Navigator.of(context).pushNamed(routeName, arguments: {
      argumentUnitDetailsApiModel: unitDetailsApiModel,
      argumentMaxPersons: maxPerson
    });
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  final PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UnitDetailsBloc>(
      create: (context) =>
          UnitDetailsBloc(UnitDetailsRepository(
            apartmentApiManger: ApartmentApiManger(dioApiManager, context),
            preferencesManager: preferencesManager,
            generalApiManger: GeneralApiManger(dioApiManager, context),
          )),
      child: ApartmentContentsScreenWithBlocV2(
          unitDetailsApiModel(context), maxPersons(context)),
    );
  }

  ApartmentDetailsApiModelV2 unitDetailsApiModel(BuildContext context) =>
      (ModalRoute
          .of(context)!
          .settings
          .arguments
      as Map)[ApartmentContentsScreenV2.argumentUnitDetailsApiModel]
      as ApartmentDetailsApiModelV2;

  int maxPersons(BuildContext context) =>
      (ModalRoute
          .of(context)!
          .settings
          .arguments
      as Map)[ApartmentContentsScreenV2.argumentMaxPersons]
      as int;
}

class ApartmentContentsScreenWithBlocV2 extends BaseStatefulScreenWidget {
  final ApartmentDetailsApiModelV2 unitDetailsApiModel;
  final int maxPerson;

  const ApartmentContentsScreenWithBlocV2(this.unitDetailsApiModel,
      this.maxPerson,
      {super.key});

  @override
  BaseScreenState<ApartmentContentsScreenWithBlocV2> baseScreenCreateState() {
    return _ApartmentContentsScreenWithBlocV2();
  }
}

class _ApartmentContentsScreenWithBlocV2
    extends BaseScreenState<ApartmentContentsScreenWithBlocV2> {
  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: Text(translate(LocalizationKeys.apartmentDetails)!)),
      body: BlocListener<UnitDetailsBloc, UnitDetailsState>(
        listener: (context, state) {
          if (state is UnitDetailLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is UnitDetailErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.unitDetailsApiModel.apartmentFeatures?.isNotEmpty ??
                false)
              ContentItemWidget.specialFeatures(
                  widget.unitDetailsApiModel.apartmentFeatures!),
            GeneralDetailsWidget(
              floorNumber: widget.unitDetailsApiModel.apartmentFloor ?? 0,
              maxNumberOfGuest: widget.maxPerson,
            ),
            SizedBox(height: 15.h),
            ...widget.unitDetailsApiModel.apartmentRooms
            !.map((e) =>
                ContentItemWidget(
                  assetPath: e.isBedRoom
                      ? AppAssetPaths.unitBedroomIcon
                      : AppAssetPaths.unitLivingRooIcon,
                  listOfFeature: e.roomBeds?.map((e) => "BedRoom ${e.bedNo}")
                      .toList() ?? [],
                  title: widget.unitDetailsApiModel.isStudio
                      ? "Studio"
                      : "BedRoom ${e.roomType}",
                  titleIsLocalizationKey: false,
                ))
                .toList(),
            ...widget.unitDetailsApiModel.bathroomDetails!
                .map((e) =>
                ContentItemWidget(
                  assetPath: AppAssetPaths.unitBathroomIcon,
                  listOfFeature: e.bathroomDetails ?? [],
                  title: e.bathroomName ?? "",
                  titleIsLocalizationKey: false,
                ))
                .toList(),
            if (widget.unitDetailsApiModel.kitchenDetails?.isNotEmpty ??
                false) ...[
              ContentItemWidget.kitchen(
                  widget.unitDetailsApiModel.kitchenDetails!),
              SizedBox(height: 15.h),
            ],
            if (widget.unitDetailsApiModel.apartmentFacilites?.isNotEmpty ??
                false) ...[
              ContentItemWidget.otherFacilities(
                  widget.unitDetailsApiModel.apartmentFacilites!),
              SizedBox(height: 15.h),
            ],
          ],
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  UnitDetailsBloc get currentBloc => BlocProvider.of<UnitDetailsBloc>(context);
}
