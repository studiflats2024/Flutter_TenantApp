import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/apis/managers/date_manager.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/apis/models/booking/extend_contract_model.dart';
import 'package:vivas/feature/bookings/bloc/booking__bloc.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';
import 'package:vivas/feature/contract/sign_contract/screen/sign_extend_contract.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_field/date_picker_form_filed_widget.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

class ExtendContractRequest extends BaseStatelessWidget {
  final ExtendContractModel extendContractModel;
  final Function() afterChange;
  ExtendContractRequest(this.extendContractModel,this.afterChange, {super.key});

  PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();
  DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
        create: (context) => BookingBloc(
              BookingsRepository(
                preferencesManager: preferencesManager,
                apartmentRequestsApiManger: ApartmentRequestsApiManger(
                  dioApiManager,
                  context,
                ),
              ),
            ),
        child: ExtendContractScreen(extendContractModel, afterChange));
  }
}

class ExtendContractScreen extends BaseStatefulScreenWidget {
  final ExtendContractModel extendContractModel;
  final Function() afterChange;
  ExtendContractScreen(this.extendContractModel, this.afterChange);

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _ExtendContractScreen();
  }
}

class _ExtendContractScreen extends BaseScreenState<ExtendContractScreen> {
  late ExtendContractModel extendContractModel;
  late int calculating;

  late int days;
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    extendContractModel = widget.extendContractModel;
    super.initState();
  }

  BookingBloc get currentBloc => BlocProvider.of<BookingBloc>(context);

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Container(
      color: AppColors.textWhite,
      child: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(LocalizationKeys.extendStatus)!,
                    style: TextStyle(
                      color: AppColors.formFieldHintText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: SizeManager.sizeSp8,
                  ),
                  Text(
                    extendContractModel.extendStatus ?? "",
                    maxLines: 1,
                    style:  TextStyle(
                      color: AppColors.appFormFieldTitle,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: SizeManager.sizeSp20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate(LocalizationKeys.checkIn)!,
                          style: const TextStyle(
                            color: Color(0xFF667084),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          AppDateFormat.formattingMonthDay(
                              DateTime.parse(extendContractModel.extendedFrom!),
                              appLocale.locale.languageCode),
                          maxLines: 1,
                          style: const TextStyle(
                            color: Color(0xFF344053),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    height: 40,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate(LocalizationKeys.checkOut)!,
                          style: const TextStyle(
                            color: Color(0xFF667084),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          AppDateFormat.formattingMonthDay(
                              DateTime.parse(extendContractModel.extendedTo!),
                              appLocale.locale.languageCode),
                          maxLines: 1,
                          style: const TextStyle(
                            color: Color(0xFF344053),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              if (extendContractModel.rejectReason != null &&
                  extendContractModel.rejectReason!.isNotEmpty &&
                  extendContractModel.extendStatus == "Rejected") ...[
                SizedBox(
                  height: SizeManager.sizeSp20,
                ),
                Text(
                  extendContractModel.rejectReason ?? "",
                  style:  TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.appFormFieldErrorIBorder,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
