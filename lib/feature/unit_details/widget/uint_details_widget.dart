import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import 'package:vivas/apis/models/apartments/apartment_details/transport_api_model.dart';
import 'package:vivas/apis/models/apartments/apartment_details/unit_details_api_model.dart';
import 'package:vivas/apis/models/general/faq_list_wrapper.dart';
import 'package:vivas/feature/make_request/model/request_ui_model.dart';
import 'package:vivas/feature/unit_details/widget/static_map_widget.dart';
import 'package:vivas/feature/unit_details/widget/unit_images_slider_widget.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/faqs/widget/faq_item_widget.dart';
import 'package:vivas/feature/widgets/reviews/widget/review_item_widget.dart';
import 'package:vivas/feature/widgets/video_viewer_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/read_more_text_widget/read_more_text_widget.dart';

class UintDetailsWidget extends BaseStatefulWidget {
  final UnitDetailsApiModel unitDetailsApiModel;
  final bool viewOnlyModel;
  final List<FAQModel> faqList;
  final Function(UnitDetailsApiModel model) shareClicked;
  final Function() showAllFeatureClicked;
  final Function() showAllFaqClicked;
  final Function() requestApartmentClicked;

  const UintDetailsWidget({
    required this.unitDetailsApiModel,
    required this.viewOnlyModel,
    required this.shareClicked,
    required this.showAllFeatureClicked,
    required this.showAllFaqClicked,
    required this.requestApartmentClicked,
    required this.faqList,
    super.key,
  });

  @override
  BaseState<UintDetailsWidget> baseCreateState() => _UintWidgetState();
}

class _UintWidgetState extends BaseState<UintDetailsWidget> {
  @override
  Widget baseBuild(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UnitImageSliderWidget(
                shareClicked: widget.shareClicked,
                unitDetailsApiModel: widget.unitDetailsApiModel,
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _videoWidget(),
                    SizedBox(height: 10.h),
                    _titleRateWidget(),
                    SizedBox(height: 10.h),
                    _addressWidget(),
                    SizedBox(height: 20.h),
                    _specificationsWidget(),
                    SizedBox(height: 20.h),
                    _priceWidget(),
                    SizedBox(height: 10.h),
                    _utilitiesWidget(),
                    SizedBox(height: 10.h),
                    _securityDepositWidget(),
                    SizedBox(height: 10.h),
                    const Divider(),
                    SizedBox(height: 10.h),
                    _descriptionWidget(),
                    SizedBox(height: 10.h),
                    const Divider(),
                    SizedBox(height: 10.h),
                    _keyFeaturesWidget(),
                    SizedBox(height: 10.h),
                    const Divider(),
                    SizedBox(height: 10.h),
                    _transportWidget(),
                    SizedBox(height: 10.h),
                    const Divider(),
                    SizedBox(height: 10.h),
                    _locationWidget(),
                    SizedBox(height: 10.h),
                    const Divider(),
                    SizedBox(height: 10.h),
                    _reviewWidget(),
                    SizedBox(height: 10.h),
                    if (widget.faqList.isNotEmpty) _faqsWidget(),
                  ],
                ),
              ),
              SizedBox(height: widget.viewOnlyModel ? 50.h : 110.h),
            ],
          ),
        ),
        if (!widget.viewOnlyModel)
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: _requestButtonWidget(),
          )
      ],
    );
  }

  Widget _requestButtonWidget() {
    return SubmitButtonWidget(
      title: translate(LocalizationKeys.requestApartment)!,
      onClicked: widget.requestApartmentClicked,
    );
  }

  Widget _videoWidget() {
    return Row(
      children: [
        if (widget.unitDetailsApiModel.generalInfo.aptVideoLink != null)
          Expanded(
            child: GestureDetector(
              onTap: () {
                VideoViewerWidget.open(context,
                    widget.unitDetailsApiModel.generalInfo.aptVideoLink!);
              },
              child: _videoItem(translate(LocalizationKeys.viewVideo)!,
                  AppAssetPaths.unitVideoIcon),
            ),
          ),
        if (widget.unitDetailsApiModel.generalInfo.apt360Link != null) ...[
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                launchUrlString(
                    widget.unitDetailsApiModel.generalInfo.apt360Link!,
                    mode: LaunchMode.inAppWebView);
              },
              child: _videoItem("360D", AppAssetPaths.d360Icon),
            ),
          ),
        ],
      ],
    );
  }

  Widget _videoItem(String title, String iconPath) {
    return Container(
      width: width,
      height: 56.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFE1EAF8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(iconPath),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0A316C),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleRateWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.unitDetailsApiModel.generalInfo.aptName,
            style: const TextStyle(
              color: Color(0xFF0F1728),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        _rateWidget(),
      ],
    );
  }

  Widget _rateWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AppAssetPaths.starIcon,
          width: 20.w,
          height: 20.h,
        ),
        SizedBox(width: 10.w),
        Text(
          widget.unitDetailsApiModel.rate.toString(),
          style: const TextStyle(
            color: Color(0xFF0F0F0F),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _addressWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(AppAssetPaths.unitLocationIcon),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            widget.unitDetailsApiModel.generalInfo.aptAddress,
            style: const TextStyle(
              color: Color(0xFF878787),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _specificationsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _specificationItemWidget(
            widget.unitDetailsApiModel.generalInfo.isApartment
                ? "${widget.unitDetailsApiModel.generalInfo.aptBedrooms} ${translate(LocalizationKeys.room)}"
                : widget.unitDetailsApiModel.generalInfo.aptTypes,
            AppAssetPaths.unitBedroomIcon),
        _specificationItemWidget(
            "${widget.unitDetailsApiModel.generalInfo.aptMaxGuest} ${translate(LocalizationKeys.person)}",
            AppAssetPaths.unitPersonIcon),
        _specificationItemWidget(
            "${widget.unitDetailsApiModel.generalInfo.aptSquareMeters} ${translate(LocalizationKeys.m2)}",
            AppAssetPaths.unitHomeIcon),
      ],
    );
  }

  Widget _specificationItemWidget(String title, String imagePath) {
    return Container(
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(imagePath),
          SizedBox(width: 8.w),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF7D7F88),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
                '€ ${widget.unitDetailsApiModel.generalInfo.aptPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF1151B4),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: ' /${translate(LocalizationKeys.month)}',
            style: const TextStyle(
              color: Color(0xFF878787),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _utilitiesWidget() {
    return Row(
      children: [
        SvgPicture.asset(AppAssetPaths.unitUtilitiesIcon),
        SizedBox(width: 8.w),
        Text(
          widget.unitDetailsApiModel.generalInfo.aptAllBillsIncludes
              ? translate(LocalizationKeys.allBillsIncluded)!
              : widget.unitDetailsApiModel.generalInfo.aptBillDescription,
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _securityDepositWidget() {
    return Row(
      children: [
        Text(
          translate(LocalizationKeys.securityDeposit)!,
          style: const TextStyle(
            color: Color(0xFF1B1B2F),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '€ ${widget.unitDetailsApiModel.generalInfo.aptSecurityDep.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Color(0xFF1B1B2F),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _descriptionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.description)!,
          style: const TextStyle(
              color: Color(0xFF1D2838),
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12.h),
        ReadMoreText(
          text: widget.unitDetailsApiModel.generalInfo.aptDescription,
          style: const TextStyle(
            color: Color(0xFF475466),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  Widget _keyFeaturesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          translate(LocalizationKeys.keyFeatures)!,
          style: const TextStyle(
            color: Color(0xFF1D2838),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        if (widget.unitDetailsApiModel.generalInfo.aptBedrooms > 0)
          _keyFeaturesItemWidget(
              "${widget.unitDetailsApiModel.generalInfo.aptBedrooms} ${translate(LocalizationKeys.bedrooms)}",
              AppAssetPaths.unitBedroomIcon),
        if (widget.unitDetailsApiModel.generalInfo.aptLiving > 0)
          _keyFeaturesItemWidget(
              "${widget.unitDetailsApiModel.generalInfo.aptLiving} ${translate(LocalizationKeys.livingRoom)}",
              AppAssetPaths.unitLivingRooIcon),
        if (widget.unitDetailsApiModel.generalInfo.aptToilets > 0)
          _keyFeaturesItemWidget(
              "${widget.unitDetailsApiModel.generalInfo.aptToilets} ${translate(LocalizationKeys.toilet)}",
              AppAssetPaths.unitBathroomIcon),
        if (widget.unitDetailsApiModel.generalInfo.aptElevator)
          _keyFeaturesItemWidget("${translate(LocalizationKeys.elevator)}",
              AppAssetPaths.unitElevatorIcon),
        if (widget.unitDetailsApiModel.kitchenTools.kitTool.isNotEmpty)
          _keyFeaturesItemWidget("${translate(LocalizationKeys.kitchen)}",
              AppAssetPaths.unitKitchenIcon),
        SizedBox(height: 10.h),
        AppOutlinedButton.withTitle(
            borderColor: const Color(0xFF344053),
            textColor: const Color(0xFF1D2838),
            title: translate(LocalizationKeys.showAllDetails)!,
            onPressed: widget.showAllFeatureClicked)
      ],
    );
  }

  Widget _keyFeaturesItemWidget(String title, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          SvgPicture.asset(imagePath, height: 25.h, width: 25.w),
          SizedBox(width: 8.w),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF344053),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _transportWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(AppAssetPaths.busIcon, height: 25.h, width: 25.w),
            SizedBox(width: 8.w),
            Text(
              translate(LocalizationKeys.publicTransport)!,
              style: const TextStyle(
                  color: Color(0xFF1D2838),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        ReadMoreText(
          text: _generateTransportText(widget.unitDetailsApiModel.transports),
          useSeeMore: true,
          maxLength: 60,
          maxLines: 2,
          style: const TextStyle(
            color: Color(0xFF1B1B2F),
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _locationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          translate(LocalizationKeys.location)!,
          style: const TextStyle(
            color: Color(0xFF1D2838),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        _addressWidget(),
        SizedBox(height: 12.h),
        StaticMapWidget(
          locationLink: "",
          latitude: widget.unitDetailsApiModel.generalInfo.aptLat.toDouble(),
          longitude: widget.unitDetailsApiModel.generalInfo.aptLong.toDouble(),
        )
      ],
    );
  }

  Widget _reviewWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _rateWidget(),
            SizedBox(width: 10.w),
            Text(
              "${widget.unitDetailsApiModel.reviewsList.length} ${translate(LocalizationKeys.reviews)}",
              style: const TextStyle(
                color: Color(0xFF1D2838),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 6 / 2,
            enlargeCenterPage: true,
          ),
          items: widget.unitDetailsApiModel.reviewsList
              .map((e) => ReviewItemWidget(reviewsUiModel: e))
              .toList(),
        ),
      ],
    );
  }

  Widget _faqsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          translate(LocalizationKeys.faq)!,
          style: const TextStyle(
            color: Color(0xFF1D2838),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        ...widget.faqList.map((e) => FaqItemWidget(faqUiModel: e)).toList(),
        SizedBox(height: 10.h),
        AppOutlinedButton.withTitle(
            borderColor: const Color(0xFF344053),
            textColor: const Color(0xFF1D2838),
            title: translate(LocalizationKeys.showAllFaq)!,
            onPressed: widget.showAllFaqClicked)
      ],
    );
  }

  String _generateTransportText(List<TransportApiModel> transports) {
    String text = "";
    for (var element in transports) {
      text += "${element.tName} : ${element.tDistance} M\n";
    }
    return text;
  }
}

class UintDetailsWidgetV2 extends BaseStatefulWidget {
  final ApartmentDetailsApiModelV2 unitDetailsApiModel;
  final bool viewOnlyModel, isGuest;
  final int maxPersons;
  final List<FAQModel> faqList;
  final Function(ApartmentDetailsApiModelV2 model) shareClicked;
  final Function() showAllFeatureClicked;
  final Function() showAllFaqClicked;
  final Function() requestApartmentClicked;
  final Function() onBack;
  final RequestUiModel? requestUiModel;

  const UintDetailsWidgetV2({
    required this.unitDetailsApiModel,
    required this.viewOnlyModel,
    required this.isGuest,
    required this.maxPersons,
    required this.shareClicked,
    required this.showAllFeatureClicked,
    required this.showAllFaqClicked,
    required this.requestApartmentClicked,
    required this.onBack,
    required this.faqList,
    required this.requestUiModel,
    super.key,
  });

  @override
  BaseState<UintDetailsWidgetV2> baseCreateState() => _UintWidgetStateV2();
}

class _UintWidgetStateV2 extends BaseState<UintDetailsWidgetV2> {
  @override
  Widget baseBuild(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UnitImageSliderWidgetV2(
                  shareClicked: widget.shareClicked,
                  unitDetailsApiModel: widget.unitDetailsApiModel,
                  onBack: widget.onBack,
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _videoWidget(),
                      SizedBox(height: 10.h),
                      _titleRateWidget(),
                      SizedBox(height: 10.h),
                      _addressWidget(),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible:
                                widget.unitDetailsApiModel
                                            .apartmentSharedType !=
                                        null &&
                                    widget.unitDetailsApiModel
                                            .apartmentSharedType !=
                                        "" &&
                                    widget.unitDetailsApiModel
                                            .apartmentSharedType ==
                                        "Shared Apartment",
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0.w, vertical: 5.h),
                              margin: EdgeInsets.symmetric(horizontal: 2.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC5C2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  widget.unitDetailsApiModel
                                          .apartmentSharedType ??
                                      '',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffB3261E)),
                                ),
                              ),
                            ),
                          ),
                          if(widget.requestUiModel?.startDate != null &&
                              widget.unitDetailsApiModel.haveUnAvailableBeds)...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0.w, vertical: 5.h),
                              margin: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: AppColors.colorPrimary.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  " Beds left: ${widget.unitDetailsApiModel.countOfAvailableRoomsBedByDate(DateTimeRange(start: widget.requestUiModel!.startDate!, end: widget.requestUiModel!.endDate!), DateTimeRange(start: widget.unitDetailsApiModel.availableFrom!, end: widget.unitDetailsApiModel.availableTo!))}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.colorPrimary),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "${translate(LocalizationKeys.minimumStay)!} ${widget.unitDetailsApiModel.minStay} ${translate(widget.unitDetailsApiModel.minStay == 1 ? LocalizationKeys.month : LocalizationKeys.months)!}",
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.appFormFieldErrorIBorder,
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _specificationsWidget(),
                      SizedBox(height: 10.h),
                      _priceWidget(),
                      SizedBox(height: 10.h),
                      _utilitiesWidget(),
                      SizedBox(height: 10.h),
                      const Divider(),
                      SizedBox(height: 10.h),
                      _descriptionWidget(),
                      SizedBox(height: 10.h),
                      const Divider(),
                      SizedBox(height: 10.h),
                      _keyFeaturesWidget(),
                      SizedBox(height: 10.h),
                      const Divider(),
                      SizedBox(height: 10.h),
                      _transportWidget(),
                      SizedBox(height: 10.h),
                      const Divider(),
                      SizedBox(height: 10.h),
                      _locationWidget(),
                      SizedBox(height: 10.h),
                      const Divider(),
                      //TODO::Reviews on Here
                      // SizedBox(height: 10.h),
                      // _reviewWidget(),
                      SizedBox(height: 10.h),
                      if (widget.faqList.isNotEmpty) _faqsWidget(),
                    ],
                  ),
                ),
                SizedBox(height: widget.viewOnlyModel ? 50.h : 110.h),
              ],
            ),
          ),
          if (!widget.viewOnlyModel)
            PositionedDirectional(
              bottom: 0,
              start: 0,
              end: 0,
              child: _requestButtonWidget(),
            )
        ],
      ),
    );
  }

  Widget _requestButtonWidget() {
    return SubmitButtonWidget(
      title: translate(LocalizationKeys.requestApartment)!,
      onClicked: widget.requestApartmentClicked,
    );
  }

  Widget _videoWidget() {
    return Row(
      children: [
        if (widget.unitDetailsApiModel.apartmentVideoLink != null)
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.unitDetailsApiModel.apartmentVideoLink == null ||
                    widget.unitDetailsApiModel.apartmentVideoLink == "") {
                  showFeedbackMessage("this apartment doesn't have video");
                } else {
                  VideoViewerWidget.open(
                      context, widget.unitDetailsApiModel.apartmentVideoLink!);
                }
              },
              child: _videoItem(translate(LocalizationKeys.viewVideo)!,
                  AppAssetPaths.unitVideoIcon),
            ),
          ),
        if (widget.unitDetailsApiModel.apartment360DLink != null) ...[
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.unitDetailsApiModel.apartmentVideoLink == null ||
                    widget.unitDetailsApiModel.apartmentVideoLink == "") {
                  showFeedbackMessage("this apartment doesn't have 360D");
                } else {
                  launchUrlString(widget.unitDetailsApiModel.apartment360DLink!,
                      mode: LaunchMode.inAppWebView);
                }
              },
              child: _videoItem("360D", AppAssetPaths.d360Icon),
            ),
          ),
        ],
      ],
    );
  }

  Widget _videoItem(String title, String iconPath) {
    return Container(
      width: width,
      height: 56.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFE1EAF8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  color: AppColors.colorPrimary,
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0A316C),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleRateWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.unitDetailsApiModel.apartmentName ?? '',
            style: const TextStyle(
              color: Color(0xFF0F1728),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        //TODO::Rate Value On Here
        // SizedBox(width: 10.w),
        // _rateWidget(),
      ],
    );
  }

  Widget _rateWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AppAssetPaths.starIcon,
          width: 20.w,
          height: 20.h,
        ),
        SizedBox(width: 10.w),
        Text(
          "widget.unitDetailsApiModel.rate.toString()",
          style: const TextStyle(
            color: Color(0xFF0F0F0F),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _addressWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AppAssetPaths.unitLocationIcon,
          color: AppColors.colorPrimary,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            "${widget.unitDetailsApiModel.apartmentLocation?.split(",")[3] ?? ""},${widget.unitDetailsApiModel.apartmentLocation?.split(",")[2] ?? ""}",
            style: const TextStyle(
              color: Color(0xFF878787),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _specificationsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _specificationItemWidget(
            widget.unitDetailsApiModel.isApartment
                ? "${widget.unitDetailsApiModel.apartmentBedRoomsNo} ${translate(LocalizationKeys.room)}"
                : widget.unitDetailsApiModel.apartmentType ?? "",
            AppAssetPaths.unitBedroomIcon),
        _specificationItemWidget(
            "${widget.unitDetailsApiModel.countOfBeds} ${translate(LocalizationKeys.person)}",
            AppAssetPaths.unitPersonIcon),
        _specificationItemWidget(
            "${widget.unitDetailsApiModel.apartmentAreaSquare ?? 0} ${translate(LocalizationKeys.m2)}",
            AppAssetPaths.unitHomeIcon),
      ],
    );
  }

  Widget _specificationItemWidget(String title, String imagePath) {
    return Container(
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            imagePath,
            color: AppColors.colorPrimary,
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.colorPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    '€ ${widget.unitDetailsApiModel.apartmentRooms?[0].bedPrice?.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.colorPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: ' /${translate(LocalizationKeys.person)}',
                style: const TextStyle(
                  color: AppColors.colorPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        _securityDepositWidget(),
      ],
    );
  }

  Widget _utilitiesWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AppAssetPaths.billIcon,
              color: AppColors.colorPrimary,
            ),
            SizedBox(width: 8.w),
            Text(
              (widget.unitDetailsApiModel.apartmentAllBillIncluded ?? false)
                  ? translate(LocalizationKeys.allBillsIncluded)!
                  : widget.unitDetailsApiModel.apartmentBillDescirption ?? "",
              style: const TextStyle(
                color: AppColors.colorPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _securityDepositWidget() {
    return Row(
      children: [
        Text(
          translate(LocalizationKeys.securityDeposit)!,
          style: const TextStyle(
            color: Color(0xFF1B1B2F),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '€ ${widget.unitDetailsApiModel.securityDeposit.toStringAsFixed(2)}/${translate(LocalizationKeys.person)}',
          style: const TextStyle(
            color: Color(0xFF1B1B2F),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _descriptionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.description)!,
          style: const TextStyle(
              color: Color(0xFF1D2838),
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12.h),
        ReadMoreText(
          text: widget.unitDetailsApiModel.apartmentDescription ?? "",
          style: const TextStyle(
            color: Color(0xFF475466),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  Widget _keyFeaturesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          translate(LocalizationKeys.keyFeatures)!,
          style: const TextStyle(
            color: Color(0xFF1D2838),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        if ((widget.unitDetailsApiModel.apartmentBedRoomsNo ?? 0) > 0)
          _keyFeaturesItemWidget(
              "${widget.unitDetailsApiModel.apartmentBedRoomsNo} ${translate(LocalizationKeys.bedrooms)}",
              AppAssetPaths.unitBedroomIcon),
        //TODO:: Living Room Not Available on Response
        // if ((widget.unitDetailsApiModel.apartmentBedRoomsNo ?? 0) > 0)
        //   _keyFeaturesItemWidget(
        //       "${widget.unitDetailsApiModel.generalInfo.aptLiving} ${translate(LocalizationKeys.livingRoom)}",
        //       AppAssetPaths.unitLivingRooIcon),
        if ((widget.unitDetailsApiModel.apartmentBathroomNo ?? 0) > 0)
          _keyFeaturesItemWidget(
              "${widget.unitDetailsApiModel.apartmentBathroomNo} ${translate(LocalizationKeys.toilet)}",
              AppAssetPaths.unitBathroomIcon),
        if (widget.unitDetailsApiModel.apartmentElevator ?? false)
          _keyFeaturesItemWidget("${translate(LocalizationKeys.elevator)}",
              AppAssetPaths.unitElevatorIcon),
        if (widget.unitDetailsApiModel.kitchenDetails?.isNotEmpty ?? false)
          _keyFeaturesItemWidget("${translate(LocalizationKeys.kitchen)}",
              AppAssetPaths.unitKitchenIcon),
        SizedBox(height: 10.h),
        AppOutlinedButton.withTitle(
            borderColor: const Color(0xFF344053),
            textColor: const Color(0xFF1D2838),
            title: translate(LocalizationKeys.showAllDetails)!,
            onPressed: widget.showAllFeatureClicked)
      ],
    );
  }

  Widget _keyFeaturesItemWidget(String title, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          SvgPicture.asset(
            imagePath,
            height: 25.h,
            width: 25.w,
            color: AppColors.colorPrimary,
          ),
          SizedBox(width: 8.w),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF344053),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _transportWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AppAssetPaths.busIcon,
              height: 25.h,
              width: 25.w,
              color: AppColors.colorPrimary,
            ),
            SizedBox(width: 8.w),
            Text(
              translate(LocalizationKeys.publicTransport)!,
              style: const TextStyle(
                  color: Color(0xFF1D2838),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        ReadMoreText(
          text: _generateTransportText(widget
              .unitDetailsApiModel.apartmentTransports!
              .map((e) => TransportApiModel(
                  tName: e.transportName ?? '',
                  tDistance: e.transportDistance ?? ""))
              .toList()),
          useSeeMore: true,
          maxLength: 60,
          maxLines: 2,
          style: const TextStyle(
            color: Color(0xFF1B1B2F),
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _locationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          translate(LocalizationKeys.location)!,
          style: const TextStyle(
            color: Color(0xFF1D2838),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        _addressWidget(),
        SizedBox(height: 12.h),
        StaticMapWidget(
          locationLink:
              widget.unitDetailsApiModel.apartmentGoogleLocation ?? "",
          latitude: widget.unitDetailsApiModel.apartmentLat ?? 0.0,
          longitude: widget.unitDetailsApiModel.apartmentLong ?? 0.0,
        )
      ],
    );
  }

  // Widget _reviewWidget() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _rateWidget(),
  //           SizedBox(width: 10.w),
  //           Text(
  //             "${widget.unitDetailsApiModel.reviewsList.length} ${translate(LocalizationKeys.reviews)}",
  //             style: const TextStyle(
  //               color: Color(0xFF1D2838),
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 6.h),
  //       CarouselSlider(
  //         options: CarouselOptions(
  //           autoPlay: false,
  //           aspectRatio: 6 / 2,
  //           enlargeCenterPage: true,
  //         ),
  //         items: widget.unitDetailsApiModel.reviewsList
  //             .map((e) => ReviewItemWidget(reviewsUiModel: e))
  //             .toList(),
  //       ),
  //     ],
  //   );
  // }

  Widget _faqsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          translate(LocalizationKeys.faq)!,
          style: const TextStyle(
            color: Color(0xFF1D2838),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        ...widget.faqList.map((e) => FaqItemWidget(faqUiModel: e)).toList(),
        SizedBox(height: 10.h),
        AppOutlinedButton.withTitle(
            borderColor: const Color(0xFF344053),
            textColor: const Color(0xFF1D2838),
            title: translate(LocalizationKeys.showAllFaq)!,
            onPressed: widget.showAllFaqClicked)
      ],
    );
  }

  String _generateTransportText(List<TransportApiModel> transports) {
    String text = "";
    for (var element in transports) {
      text += "${element.tName} : ${element.tDistance} M\n";
    }
    return text;
  }
}
