import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/invite_frind_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/invitations_history_model.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/InviteFrindes/invite_frindes_bloc.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/text_field/date_time_form_field_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

//ignore: must_be_immutable
class InviteAgain extends BaseStatelessWidget {
 final InviteFrindesBloc currentBloc;
 final InviteModel model;

  InviteAgain(this.currentBloc, this.model, {super.key});

  DateTime? date;

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
      height: 200.h,
      child: BlocProvider.value(
        value: currentBloc,
        child: BlocConsumer<InviteFrindesBloc, InviteFrindesState>(
          listener: (context, state) {
            if (state is ChooseDateState) {
              date = state.date;
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DateTimeFormFieldWidget(
                  title: translate(LocalizationKeys.invitationDate) ?? "",
                  hintText:
                      translate(LocalizationKeys.invitationDateHint) ?? "",
                  hintStyle: textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textNatural700,
                      fontWeight: FontWeight.w400),
                  iconStart: true,
                  onSaved: (v) {
                    currentBloc.add(ChooseDateEvent(v));
                  },
                ),
                SizedBox(
                  height: SizeManager.sizeSp16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 160.r,
                      child: SubmitButtonWidget(
                          withoutShape: true,
                          withoutCustomShape: true,
                          padding: EdgeInsets.zero,
                          sizeTop: 0,
                          sizeBottom: 0,
                          title: translate(LocalizationKeys.cancel) ?? "",
                          buttonColor: AppColors.textWhite,
                          titleStyle: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.colorPrimary),
                          outlinedBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  SizeManager.circularRadius10),
                              side: const BorderSide(
                                color: AppColors.colorPrimary,
                              )),
                          onClicked: () {
                            Navigator.pop(context);
                          }),
                    ),
                    SizedBox(
                      width: 160.r,
                      child: SubmitButtonWidget(
                          title: translate(LocalizationKeys.send) ?? "",
                          withoutShape: true,
                          padding: EdgeInsets.zero,
                          sizeTop: 0,
                          sizeBottom: 0,
                          onClicked: () {
                            currentBloc
                                .add(InviteFriendEvent(InviteFriendSendModel(
                              name: model.name ?? "",
                              email: model.email ?? "",
                              phone: model.phone ?? "",
                              invitationDate: date,
                            )));
                            Navigator.pop(context);
                          }),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
