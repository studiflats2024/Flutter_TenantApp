import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/make_request/bloc/make_request_bloc.dart';
import 'package:vivas/feature/make_request/model/request_ui_model.dart';
import 'package:vivas/feature/make_request/widget/Components/email_main_tenant.dart';
import 'package:vivas/feature/make_request/widget/Components/phoneMainTenant.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/phone_number_form_filed_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class FullBooking extends BaseStatelessWidget with AuthValidate {
  final int numberOfGuest;
  final String mobile, email;
  final MakeRequestBloc currentBloc;
  final RequestUiModel requestUiModel;
  final ApartmentDetailsApiModelV2 apartmentDetailsApiModelV2;
  final Function(int index, String value) guestNAmeSavedSaved;
  final Function(int roomIndex, PhoneNumber? value, {String? myPhone})
      guestWaNoSaved;
  final Function(int roomIndex, String value) guestEmailSavedSaved;
  final PhoneController phoneController;
  final AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  FullBooking({
    super.key,
    required this.numberOfGuest,
    required this.mobile,
    required this.email,
    required this.currentBloc,
    required this.requestUiModel,
    required this.apartmentDetailsApiModelV2,
    required this.guestNAmeSavedSaved,
    required this.guestWaNoSaved,
    required this.guestEmailSavedSaved,
    required this.phoneController,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider.value(
      value: currentBloc,
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: AppColors.cardColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: requestUiModel.numberOfGuests > 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(requestUiModel.numberOfGuests,
                          (bedIndex) {
                        var bed =
                            apartmentDetailsApiModelV2.getRoomBeds[bedIndex];
                        if (requestUiModel.roomsId.isEmpty ||
                            requestUiModel.numberOfGuests !=
                                requestUiModel.roomsId.length) {
                          requestUiModel.roomsId[bed.bedNo ?? 0] = {
                            "room_ID": bed.roomId ?? '',
                            "bed_ID": bed.bedId ?? "",
                            "apartment_ID":
                                apartmentDetailsApiModelV2.apartmentId ?? '',
                            "guest_Name": "",
                            "guest_WA_No": "",
                            "guest_Email": ""
                          };
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0.h),
                              child: Text(
                                "${translate(LocalizationKeys.bed)!} ${(bed.bedNo)}",
                                style: textTheme.titleMedium?.copyWith(
                                    fontSize: FontSize.fontSize18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Visibility(
                              visible: (requestUiModel.chooseWhereStay == "" &&
                                      (!(requestUiModel.chooseBed ?? false))) ||
                                  (requestUiModel.chooseWhereStay ==
                                          bed.bedId &&
                                      (requestUiModel.chooseBed ?? false)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    translate(LocalizationKeys
                                            .doYouPlanToStayHere) ??
                                        "",
                                    style: textTheme.labelMedium?.copyWith(
                                        fontSize: FontSize.fontSize14),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                requestUiModel.chooseBed,
                                            activeColor: AppColors.colorPrimary,
                                            onChanged: (value) async {
                                              if (value == true) {
                                                requestUiModel.chooseBed =
                                                    value;
                                                requestUiModel.chooseWhereStay =
                                                    bed.bedId ?? "";

                                                requestUiModel.bedIndex =
                                                    bed.bedNo ?? 0;
                                                requestUiModel.roomsId[bed
                                                        .bedNo ??
                                                    0]!["guest_WA_No"] = mobile;
                                                requestUiModel.roomsId[bed
                                                        .bedNo ??
                                                    0]!["guest_Email"] = email;
                                                currentBloc.add(
                                                    ChooseWhereWillStay(
                                                        requestUiModel));
                                              }
                                            },
                                          ),
                                          Transform.translate(
                                            offset: Offset(-8.w, 0),
                                            // Adjust the offset value as needed
                                            child: Text(
                                              translate(LocalizationKeys.yes) ??
                                                  "",
                                              style: textTheme.labelMedium
                                                  ?.copyWith(
                                                      fontSize:
                                                          FontSize.fontSize14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: false,
                                            groupValue:
                                                requestUiModel.chooseBed,
                                            activeColor: AppColors.colorPrimary,
                                            onChanged: (value) {
                                              if (value == false) {
                                                requestUiModel.chooseBed =
                                                    value;
                                                requestUiModel.chooseWhereStay =
                                                    "";
                                                requestUiModel.bedIndex = null;
                                                currentBloc.add(
                                                    ChooseWhereWillStay(
                                                        requestUiModel));
                                              } else {}
                                            },
                                          ),
                                          Transform.translate(
                                            offset: Offset(-8.w, 0),
                                            // Adjust the offset value as needed
                                            child: Text(
                                              translate(LocalizationKeys.no) ??
                                                  "",
                                              style: textTheme.labelMedium
                                                  ?.copyWith(
                                                      fontSize:
                                                          FontSize.fontSize14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            _generateNameTextField(bed.bedNo ?? 0),
                            if (requestUiModel.chooseWhereStay ==
                                bed.bedId) ...[
                              SizedBox(
                                height: 85.r,
                                child: PhoneMainGuest(
                                    index: bed.bedNo ?? 0,
                                    bedId: bed.bedId ?? "",
                                    guestWaNoSaved: guestWaNoSaved),
                              ),
                            ] else ...[
                              _generateWaNoTextField(
                                  bed.bedNo ?? 0,
                                  bed.bedId ?? "",
                                  mobile != ''
                                      ? PhoneNumber.parse(mobile)
                                      : null)
                            ],
                            requestUiModel.chooseWhereStay == bed.bedId
                                ? SizedBox(
                                    height: 110.r,
                                    child: EmailMainGuest(
                                        index: bed.bedNo ?? 0,
                                        bedId: bed.bedId ?? "",
                                        guestEmailSavedSaved:
                                            guestEmailSavedSaved),
                                  )
                                : _generateEmailTextField(
                                    bed.bedNo ?? 0, bed.bedId ?? "", null),
                          ],
                        );
                      }),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(1, (bedIndex) {
                        var bed = apartmentDetailsApiModelV2
                            .apartmentRooms![0].roomBeds![bedIndex];

                        if (requestUiModel.roomsId.isEmpty) {
                          requestUiModel.roomsId[bed.bedNo ?? 0] = {
                            "room_ID": bed.roomId ?? '',
                            "bed_ID": bed.bedId ?? "",
                            "apartment_ID":
                                apartmentDetailsApiModelV2.apartmentId ?? '',
                            "guest_Name": "",
                            "guest_WA_No": mobile,
                            "guest_Email": email
                          };
                          requestUiModel.chooseBed = true;
                          requestUiModel.chooseWhereStay = bed.bedId ?? "";

                          requestUiModel.bedIndex = bed.bedNo ?? 0;

                          currentBloc.add(ChangeRequestData(requestUiModel));
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _generateNameTextField(bed.bedNo ?? 0),
                            SizedBox(
                              height: 85.r,
                              child: PhoneMainGuest(
                                  index: bed.bedNo ?? 0,
                                  bedId: bed.bedId ?? "",
                                  guestWaNoSaved: guestWaNoSaved),
                            ),
                            SizedBox(
                              height: 110.r,
                              child: EmailMainGuest(
                                  index: bed.bedNo ?? 0,
                                  bedId: bed.bedId ?? "",
                                  guestEmailSavedSaved: guestEmailSavedSaved),
                            )
                          ],
                        );
                      }),
                    ],
                  )),
      ),
    );
  }

  Widget _generateNameTextField(int index) {
    return Column(
      children: [
        AppTextFormField(
          hintText: "${translate(LocalizationKeys.enterNameOfGuest)!} ",
          title:
              "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.name)!}",
          titleStyle: textTheme.titleMedium?.copyWith(
              fontSize: FontSize.fontSize12,
              color: AppColors.formFieldText,
              fontWeight: FontWeight.w600),
          onSaved: (value) => guestNAmeSavedSaved(index, value!),
          validator: textValidator,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 10.h)
      ],
    );
  }

  Widget _generateWaNoTextField(int index, bedId, PhoneNumber? phoneNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PhoneNumberFormFiledWidget(
          title:
              "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.whatsAppNumber)!}",
          hintText: "ex.1234567890",
          initialValue: null,
          autovalidateMode: autoValidateMode,
          onSaved: (value) => guestWaNoSaved(index, value),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _generateMainWaNoTextField(int index, bedId, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.whatsAppNumber)!}"
                .concatenateAsterisk,
            style: textTheme.titleMedium?.copyWith(
                fontSize: FontSize.fontSize12,
                color: AppColors.appFormFieldTitle,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        PhoneFormField(
          autovalidateMode: autoValidateMode,
          autofillHints: const [AutofillHints.telephoneNumber],
          countrySelectorNavigator:
              const CountrySelectorNavigator.draggableBottomSheet(),
          initialValue: phoneController.value,
          decoration: InputDecoration(
            hintText: "ex.1234567890",
            fillColor: AppColors.appFormFieldFill,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            hintStyle: textTheme.labelMedium?.copyWith(
              color: AppColors.formFieldHintText,
              fontWeight: FontWeight.w400,
              fontSize: 16.spMin,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.enabledAppFormFieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.formFieldFocusIBorder,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          enabled: false,
          countryButtonStyle: CountryButtonStyle(
              textStyle: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.formFieldText),
              flagSize: 20.r,
              showFlag: true,
              showDropdownIcon: false),
          cursorColor: Theme.of(context).colorScheme.primary,
          onSaved: (value) => guestWaNoSaved(index, value),
          textInputAction: TextInputAction.done,
          isCountrySelectionEnabled: true,
          isCountryButtonPersistent: true,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.formFieldText),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _generateEmailTextField(int index, bedId, String? initValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFormField(
          hintText: "${translate(LocalizationKeys.enterEmailOfGuest)!} ",
          enable: bedId != requestUiModel.chooseWhereStay,
          title:
              "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.email)!}",
          titleStyle: textTheme.titleMedium?.copyWith(
              fontSize: FontSize.fontSize12,
              color: AppColors.appFormFieldTitle,
              fontWeight: FontWeight.w600),
          onSaved: (value) => guestEmailSavedSaved(index, value!),
          validator:
              bedId == requestUiModel.chooseWhereStay ? null : emailValidator,
          initialValue: initValue,
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 10.h),
        Text(translate(LocalizationKeys.bookingWillSentToEmail) ?? "",
            style: textTheme.bodyMedium?.copyWith(
              fontSize: FontSize.fontSize12,
              color: AppColors.colorPrimary,
            )),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _generateMainEmailTextField(
    int index,
    bedId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "${translate(LocalizationKeys.guest)!} ${translate(LocalizationKeys.email)!}"
                .concatenateAsterisk,
            style: textTheme.titleMedium?.copyWith(
                fontSize: FontSize.fontSize12,
                color: AppColors.appFormFieldTitle,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        TextFormField(
          readOnly: bedId == requestUiModel.chooseWhereStay,
          enabled: bedId != requestUiModel.chooseWhereStay,
          onSaved: (value) => guestEmailSavedSaved(index, value!),
          initialValue: email,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          validator: emailValidator,
          decoration: InputDecoration(
            hintText: "${translate(LocalizationKeys.enterEmailOfGuest)!} ",
            fillColor: AppColors.appFormFieldFill,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            hintStyle: textTheme.labelMedium?.copyWith(
              color: AppColors.formFieldHintText,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.enabledAppFormFieldBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.formFieldFocusIBorder,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          translate(LocalizationKeys.bookingWillSentToEmail) ?? "",
          style: textTheme.bodySmall?.copyWith(
            fontSize: FontSize.fontSize12,
            color: AppColors.colorPrimary,
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
