import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/plan_settings_api_manager.dart';
import 'package:vivas/apis/models/CancelPlan/cancel_plan_model.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/PlanSettings/ViewModel/cancel_plan_repository.dart';
import 'package:vivas/feature/PlanSettings/ViewModel/cancel_plans_bloc.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

List<String> reasons = [
  "Too expensive",
  "No longer need the service",
  "Switching to another Plan",
  "Bad Service",
  "other"
];

//ignore:must_be_immutable
class CancelPlans extends BaseStatelessWidget {
  CancelPlans({super.key});

  static const routeName = '/cancel-plan';
  final DioApiManager _dioApiManager = GetIt.I<DioApiManager>();

  static Future<void> open(
    BuildContext context,
    bool replacement,
  ) async {
    if (replacement) {
      await Navigator.of(context).pushReplacementNamed(routeName);
    } else {
      await Navigator.of(context).pushNamed(routeName);
    }
  }

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
      create: (context) => CancelPlansBloc(CancelPlanRepositoryImplementation(
          PlanSettingsApiManager(_dioApiManager))),
      child: const CancelPlansWithBloc(),
    );
  }
}

class CancelPlansWithBloc extends BaseStatefulScreenWidget {
  const CancelPlansWithBloc({super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _CancelPlansWithBloc();
  }
}

class _CancelPlansWithBloc extends BaseScreenState<CancelPlansWithBloc> {
  int? reasonSelected;

  TextEditingController otherReason = TextEditingController();

  CancelPlansBloc get currentBloc => context.read<CancelPlansBloc>();

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalizationKeys.cancelPlan,
        withBackButton: true,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: BlocConsumer<CancelPlansBloc, CancelPlansState>(
        listener: (context, state) {
          if (state is CancelPlansLoading) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is ChooseCancelPlanReasonState) {
            reasonSelected = state.reason;
          } else if (state is CancelPlansSuccess) {
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                text: translate(LocalizationKeys.cancelSuccessMessage),
              ),
            ).then((v) {
              Navigator.pop(context);
            });
          } else if (state is CancelPlansError) {
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.warning,
                text: state.errorApiModel.isMessageLocalizationKey
                    ? translate(state.errorApiModel.message) ??
                        "Un Expected Error"
                    : state.errorApiModel.message,
              ),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: TextApp(
                  multiLang: true,
                  fontWeight: FontWeight.w400,
                  fontSize: FontSize.fontSize14,
                  color: AppColors.textNatural700,
                  text: LocalizationKeys.cancelPlanHint,
                ),
              ),
              SizedBox(
                height: SizeManager.sizeSp8,
              ),
              Center(
                child: TextApp(
                  text:
                      "${translate(LocalizationKeys.note)} : ${translate(LocalizationKeys.cancelPlanMessage)}",
                  multiLang: false,
                  textAlign: TextAlign.center,
                  color: AppColors.textConsultant,
                  fontSize: FontSize.fontSize14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: SizeManager.sizeSp8,
              ),
              Column(
                children: List.generate(reasons.length, (index) {
                  return RadioListTile<int>(
                    value: index,
                    onChanged: (value) {
                      if (value != null) {
                        currentBloc.add(ChooseCancelPlanReasonEvent(value));
                      }
                    },
                    activeColor: AppColors.colorPrimary,
                    title: TextApp(
                      text: reasons[index],
                      fontSize: FontSize.fontSize14,
                      color: AppColors.textMainColor,
                    ),
                    groupValue: reasonSelected,
                  );
                }),
              ),
              SizedBox(
                height: SizeManager.sizeSp32,
              ),
              Visibility(
                visible: reasonSelected == 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeManager.sizeSp16,
                  ),
                  child: AppTextFormField(
                    title: translate(LocalizationKeys.other) ?? "",
                    hintText: translate(LocalizationKeys.writeYourReason) ?? "",
                    maxLines: 10,
                    maxLength: 1000,
                    controller: otherReason,
                    onSaved: (value) {},
                  ),
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CancelPlansBloc, CancelPlansState>(
        builder: (context, state) {
          return SizedBox(
            height: 110.r,
            child: SubmitButtonWidget(
                title: translate(LocalizationKeys.cancelPlan) ?? "",
                buttonColor:
                    reasonSelected != null ? null : AppColors.buttonGrey,
                titleStyle: reasonSelected != null
                    ? null
                    : TextStyle(
                        color: AppColors.textMainColor,
                        fontSize: FontSize.fontSize16),
                onClicked: () {
                  if (reasonSelected != null) {
                    if (reasonSelected == 4 && otherReason.text.isEmpty) {
                      showFeedbackMessage("Please enter your reason");
                    } else {
                      AppBottomSheet.openAppBottomSheet(
                          context: context,
                          child: CancelDialog(
                            reasonSelected != 4
                                ? reasons[reasonSelected!]
                                : otherReason.text,
                            currentBloc,
                          ),
                          title: '');
                    }
                  }
                }),
          );
        },
      ),
    );
  }
}

//ignore: must_be_immutable
class CancelDialog extends BaseStatelessWidget {
  final String reason;

  final CancelPlansBloc currentBloc;

  CancelDialog(this.reason, this.currentBloc, {super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider.value(
      value: currentBloc,
      child: Column(
        children: [
          SvgPicture.asset(AppAssetPaths.cancelPlanWarningIcon),
          SizedBox(
            height: SizeManager.sizeSp16,
          ),
          TextApp(
            text: LocalizationKeys.cancelPlanWarning,
            multiLang: true,
          ),
          SizedBox(
            height: SizeManager.sizeSp16,
          ),
          TextApp(
            text: LocalizationKeys.cancelPlanMessage,
            multiLang: true,
            textAlign: TextAlign.center,
            color: AppColors.textNatural700,
            fontSize: FontSize.fontSize14,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            height: SizeManager.sizeSp32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: AppColors.textWhite,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: AppColors.colorPrimary,
                      ),
                      borderRadius:
                          BorderRadius.all(SizeManager.circularRadius10)),
                  label: TextApp(
                    multiLang: true,
                    text: LocalizationKeys.cancel,
                  ),
                ),
              ),
              SizedBox(
                width: SizeManager.sizeSp16,
              ),
              Expanded(
                child: AppElevatedButton(
                  onPressed: () {
                    currentBloc
                        .add(CancelPlanEvent(CancelPlanSendModel(reason)));
                    Navigator.pop(context);
                  },
                  label: TextApp(
                    multiLang: true,
                    color: AppColors.textWhite,
                    text: LocalizationKeys.confirm,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
