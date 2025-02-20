import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/my_activity_rating_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/my_activity_model.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/MyActivity/my_activity_bloc.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

class MyActivityRating extends BaseStatefulScreenWidget {
  final MyActivityModel model;
  final MyActivityBloc currentBloc;
  final int index;

  const MyActivityRating(this.model, this.currentBloc, this.index, {super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _MyActivityRating();
  }
}

class _MyActivityRating extends BaseScreenState<MyActivityRating> {
  num rate = 0;
  TextEditingController comment = TextEditingController();

  @override
  Widget baseScreenBuild(BuildContext context) {
    return BlocProvider.value(
      value: widget.currentBloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocalizationKeys.leaveRating,
          withBackButton: true,
          onBack: () {
            Navigator.pop(context);
          },
          multiLan: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
            child: Column(
              children: [
                SizedBox(
                  height: SizeManager.sizeSp16,
                ),
                Row(
                  children: [
                    Container(
                      width: 90.r,
                      height: 90.r,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(SizeManager.circularRadius10),
                        image: widget.model.image.isLink
                            ? DecorationImage(
                                image: NetworkImage(
                                  widget.model.image,
                                ),
                                fit: BoxFit.cover)
                            : const DecorationImage(
                                image: AssetImage(
                                    AppAssetPaths.imageMonthlyActivities),
                                fit: BoxFit.cover),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(SizeManager.sizeSp8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: SizeManager.sizeSp8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 140.r,
                                  child: TextApp(
                                    text: widget.model.name,
                                    fontSize: FontSize.fontSize14,
                                    overflow: TextOverflow.ellipsis,
                                    color: AppColors.textMainColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeManager.sizeSp8,
                            ),
                            footer(widget.model)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeManager.sizeSp24,
                ),
                TextApp(
                  text: LocalizationKeys.howIsYourExperience,
                  multiLang: true,
                  fontSize: FontSize.fontSize20,
                ),
                SizedBox(
                  height: SizeManager.sizeSp24,
                ),
                Container(
                  height: 1.r,
                  color: AppColors.cardBorderPrimary100,
                ),
                SizedBox(
                  height: SizeManager.sizeSp16,
                ),
                TextApp(
                  text: LocalizationKeys.yourOverallRating,
                  multiLang: true,
                  fontSize: FontSize.fontSize12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textNatural700,
                ),
                SizedBox(
                  height: SizeManager.sizeSp8,
                ),
                RatingBar(
                  onRatingUpdate: (value) {
                    setState(() {
                      rate = value;
                    });
                  },
                  itemSize: SizeManager.sizeSp32,
                  itemPadding:
                      EdgeInsets.symmetric(horizontal: SizeManager.sizeSp10),
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset(
                      AppAssetPaths.rateIcon,
                      color: AppColors.colorPrimary,
                    ),
                    half: SvgPicture.asset(
                      AppAssetPaths.rateIcon,
                      color: AppColors.colorPrimary.withOpacity(0.5),
                    ),
                    empty: SvgPicture.asset(
                      AppAssetPaths.communityRateOutline,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeManager.sizeSp16,
                ),
                Container(
                  height: 1.r,
                  color: AppColors.cardBorderPrimary100,
                ),
                SizedBox(
                  height: SizeManager.sizeSp16,
                ),
                AppTextFormField(
                  maxLines: 8,
                  hintText: "",
                  onSaved: (e) {},
                  controller: comment,
                  requiredTitle: false,
                  background: AppColors.appFormFieldFill2,
                  title: translate(LocalizationKeys.addDetailedReview),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 110.r,
          child: SubmitButtonWidget(
            title: translate(LocalizationKeys.submit)!,
            onClicked: () {
              if (rate != 0) {
                widget.currentBloc.add(
                  ReviewEvent(
                      MyActivityRatingSendModel(
                        widget.model.id,
                        rate.toInt().toString(),
                        comment.text,
                      ),
                      widget.index),
                );
              } else {
                ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                    text: "You Need to put your rate",
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget footer(MyActivityModel model) {
    if (model.activitiesType == ActivitiesType.event) {
      return Row(
        children: [
          SvgPicture.asset(
            AppAssetPaths.calenderIconOutline,
            color: AppColors.colorPrimary,
          ),
          SizedBox(
            width: SizeManager.sizeSp8,
          ),
          Row(
            children: [
              TextApp(
                text: model.date,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
                fontSize: 12.sp,
                color: AppColors.textNatural700,
              ),
            ],
          ),
        ],
      );
    } else if (model.activitiesType == ActivitiesType.consultant) {
      return Row(
        children: [
          SvgPicture.asset(
            AppAssetPaths.calenderIconOutline,
            color: AppColors.colorPrimary,
          ),
          SizedBox(
            width: SizeManager.sizeSp8,
          ),
          TextApp(
            text: "${model.day}",
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.textNatural700,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          SvgPicture.asset(
            AppAssetPaths.calenderIconOutline,
            color: AppColors.colorPrimary,
          ),
          SizedBox(
            width: SizeManager.sizeSp8,
          ),
          TextApp(
            text: "${model.date} ",
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: AppColors.textNatural700,
          ),
        ],
      );
    }
  }
}
