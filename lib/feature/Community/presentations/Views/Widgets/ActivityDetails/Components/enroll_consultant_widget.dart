import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/enroll_activity_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/activity_details_model.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/ActivityDetails/activity_details_bloc.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

class EnrollConsultantWidget extends BaseStatefulScreenWidget {
  final ActivityDetailsModel model;
  final ActivityDetailsBloc currentBloc;

  const EnrollConsultantWidget(this.model, this.currentBloc, {super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _EnrollConsultantWidget();
  }
}

class _EnrollConsultantWidget extends BaseScreenState<EnrollConsultantWidget> {
  ConsultDay? consultDay;
  String? time;

  @override
  Widget baseScreenBuild(BuildContext context) {
    return BlocProvider.value(
      value: widget.currentBloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: LocalizationKeys.clubActivity,
          systemOverlayStyle: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: AppColors.textWhite),
          withBackButton: true,
          centerTitle: true,
          onBack: () {
            Navigator.pop(context);
          },
        ),
        body: BlocConsumer<ActivityDetailsBloc, ActivityDetailsState>(
          listener: (context, state) {
            if (state is ActivityDetailsLoadingState) {
              showLoading();
            } else {
              hideLoading();
            }
            if (state is ChooseDayTimeState) {
              consultDay = state.day;
            } else if (state is ChooseTimeState) {
              time = state.time;
            } else if (state is SuccessEnrollState) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeManager.sizeSp16,
                  vertical: SizeManager.sizeSp32),
              children: [
                Column(
                  children: List.generate(widget.model.consultDays?.length ?? 0,
                      (index) {
                    var item = widget.model.consultDays![index];
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(SizeManager.sizeSp16),
                          decoration: BoxDecoration(
                              color: consultDay == item
                                  ? AppColors.colorPrimary
                                  : AppColors.cardBorderPrimary100,
                              borderRadius: BorderRadius.all(
                                  SizeManager.circularRadius10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  // TextApp(
                                  //   text: item.consultDay ?? "",
                                  //   fontSize: FontSize.fontSize14,
                                  //   color: consultDay == item
                                  //       ? AppColors.textWhite
                                  //       : AppColors.textShade7,
                                  // ),
                                  TextApp(
                                    text: DateFormat.yMEd().format(
                                            item.consultDate ??
                                                DateTime.now()) ??
                                        "",
                                    fontSize: FontSize.fontSize14,
                                    color: consultDay == item
                                        ? AppColors.textWhite
                                        : AppColors.textShade7,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.currentBloc
                                      .add(ChooseDayTimeEvent(item));
                                },
                                child: TextApp(
                                  text: LocalizationKeys.viewSchedule,
                                  multiLang: true,
                                  fontSize: FontSize.fontSize14,
                                  color: consultDay == item
                                      ? AppColors.textWhite
                                      : AppColors.colorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: SizeManager.sizeSp16,
                        ),
                      ],
                    );
                  }),
                ),
                if (consultDay?.consultTime != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeManager.sizeSp8,
                        vertical: SizeManager.sizeSp16),
                    decoration: BoxDecoration(
                        color: AppColors.textWhite,
                        borderRadius:
                            BorderRadius.all(SizeManager.circularRadius10),
                        border:
                            Border.all(color: AppColors.cardBorderPrimary100)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: LocalizationKeys.availableTime,
                          multiLang: true,
                        ),
                        SizedBox(
                          height: SizeManager.sizeSp16,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 1.1,
                                  childAspectRatio: 2.9,
                                  crossAxisCount: 3),
                          itemCount: consultDay!.consultTime!.length,
                          itemBuilder: (BuildContext context, int index) {
                            var key =
                                consultDay!.consultTime!.keys.elementAt(index);
                            var item = consultDay!.consultTime![key];
                            return GestureDetector(
                              onTap: () {
                                if (item?.isAvailable ?? false) {
                                  widget.currentBloc.add(ChooseTimeEvent(key));
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(SizeManager.sizeSp4),
                                decoration: BoxDecoration(
                                    color: time == key
                                        ? AppColors.colorPrimary
                                        : (item?.isAvailable ?? false)
                                            ? AppColors.textWhite
                                            : AppColors.cardNatural100,
                                    borderRadius: BorderRadius.all(
                                        SizeManager.circularRadius8),
                                    border: Border.all(
                                        color: AppColors.cardBorderPrimary100)),
                                child: Center(
                                  child: TextApp(
                                    text:
                                        item?.timeRange?.split("-").first ?? "",
                                    color: time == key
                                        ? AppColors.textWhite
                                        : (item?.isAvailable ?? false)
                                            ? AppColors.textMainColor
                                            : AppColors.textNatural500,
                                    fontSize: FontSize.fontSize14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  )
                ]
              ],
            );
          },
        ),
        bottomNavigationBar:
            BlocBuilder<ActivityDetailsBloc, ActivityDetailsState>(
          builder: (context, state) {
            return SizedBox(
              height: 110.r,
              child: SubmitButtonWidget(
                  title: translate(LocalizationKeys.confirmRequest) ?? "",
                  titleStyle: time != null
                      ? null
                      : TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: FontSize.fontSize16,
                          color: AppColors.textNatural700,
                        ),
                  buttonColor: time != null ? null : AppColors.divider,
                  onClicked: () {
                    if (time != null) {
                      widget.currentBloc.add(
                        EnrollEvent(
                          EnrollActivitySendModel(
                            widget.model.activityId ?? "",
                            widget.model.activityType!,
                            date: time,
                          ),
                        ),
                      );
                    }
                  }),
            );
          },
        ),
      ),
    );
  }
}
