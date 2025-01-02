import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/rate/rate_item_widget.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class ReviewWidget extends BaseStatefulWidget {
  final void Function(int, int, int, int, int, int, String?)
      onSendReviewClicked;

  const ReviewWidget({required this.onSendReviewClicked, super.key});

  @override
  BaseState<BaseStatefulWidget> baseCreateState() =>
      _CheckoutRatingWidgetState();
}

class _CheckoutRatingWidgetState extends BaseState<ReviewWidget>
    with AuthValidate {
  int _apartmentStudioRateValue = 0;
  int _safetyRateValue = 0;
  int _locationRateValue = 0;
  int _serviceRateValue = 0;
  int _cleanlinessRateValue = 0;
  int _communicationRateValue = 0;

  String? _comment;

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 24.0.h),
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Text(
                  translate(LocalizationKeys.review)!,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                translate(LocalizationKeys
                    .pleaseRateYourExperienceOnAScaleOf1To5With1BeingTheLowestAnd5TheHighest)!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF8A8A88),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 24.h),
              Column(
                children: [
                  RatingItemWidget(
                      title: translate(LocalizationKeys.apartmentStudio)!,
                      onRateValueChanged: _onApartmentStudioRateValueChanged),
                  RatingItemWidget(
                      title: translate(LocalizationKeys.safety)!,
                      onRateValueChanged: _onSafetyRateValueChanged),
                  RatingItemWidget(
                      title: translate(LocalizationKeys.location)!,
                      onRateValueChanged: _onLocationRateValueChanged),
                  RatingItemWidget(
                      title: translate(LocalizationKeys.ourService)!,
                      onRateValueChanged: _onServiceRateValueChanged),
                  RatingItemWidget(
                      title: translate(LocalizationKeys.cleanliness)!,
                      onRateValueChanged: _onCleanlinessRateValueChanged),
                  RatingItemWidget(
                      title: translate(LocalizationKeys.communication)!,
                      onRateValueChanged: _onCommunicationRateValueChanged),
                  SizedBox(height: 12.h),
                  AppTextFormField(
                    title:
                        translate(LocalizationKeys.additionalCommentOptional)!,
                    requiredTitle: false,
                    initialValue: _comment,
                    hintText: translate(LocalizationKeys.yourComment),
                    onSaved: _commentSaved,
                    onChanged: _commentSaved,
                    textInputAction: TextInputAction.done,
                    validator: textValidator,
                    maxLines: 5,
                  )
                ],
              ),
              SizedBox(height: 24.h),
              Container(
                decoration: const BoxDecoration(
                    color: AppColors.colorPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: AppTextButton(
                    onPressed: () =>
                        {Navigator.pop(context), _onSendReviewClicked()},
                    child: Text(
                      translate(LocalizationKeys.sendYourReview)!,
                      style: themeData.textTheme.labelMedium?.copyWith(
                          color: AppColors.appSecondButton,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onApartmentStudioRateValueChanged(double value) {
    _apartmentStudioRateValue = value.toInt();
  }

  void _onSafetyRateValueChanged(double value) {
    _safetyRateValue = value.toInt();
  }

  void _onLocationRateValueChanged(double value) {
    _locationRateValue = value.toInt();
  }

  void _onServiceRateValueChanged(double value) {
    _serviceRateValue = value.toInt();
  }

  void _onCleanlinessRateValueChanged(double value) {
    _cleanlinessRateValue = value.toInt();
  }

  void _onCommunicationRateValueChanged(double value) {
    _communicationRateValue = value.toInt();
  }

  void _commentSaved(String? value) {
    _comment = value!;
  }

  void _onSendReviewClicked() {
    widget.onSendReviewClicked(
        _apartmentStudioRateValue,
        _safetyRateValue,
        _locationRateValue,
        _serviceRateValue,
        _cleanlinessRateValue,
        _communicationRateValue,
        _comment);
  }
}
