import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/contract_api_manager.dart';
import 'package:vivas/apis/models/contract/get_contract/contract_member_response_model.dart';
import 'package:vivas/apis/models/contract/get_contract/get_contract_response_v2.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanHistory/club_terms.dart';
import 'package:vivas/feature/app_pages/screen/terms_conditions_screen.dart';
import 'package:vivas/feature/contract/sign_contract/bloc/sign_contract_bloc.dart';
import 'package:vivas/feature/contract/sign_contract/bloc/sign_contract_repository.dart';
import 'package:vivas/feature/contract/sign_contract/widget/signature_alert_dialog.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/feature/widgets/app_buttons/app_text_button.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class SignMemberContract extends StatelessWidget {
  SignMemberContract({super.key});

  static const routeName = '/sign-member-contract-screen';
  static const argumentReplacement = 'replacement';

  static Future<void> open(
    BuildContext context,
    bool replacement,
  ) async {
    if (replacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentReplacement: replacement,
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentReplacement: replacement,
      });
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignContractBloc>(
      create: (context) => SignContractBloc(SignContractRepository(
          contractApiManger: ContractApiManger(dioApiManager, context))),
      child: const SignMemberContractWithBloc(),
    );
  }
}

class SignMemberContractWithBloc extends BaseStatefulScreenWidget {
  const SignMemberContractWithBloc({super.key});

  @override
  BaseScreenState<SignMemberContractWithBloc> baseScreenCreateState() {
    return _SignMemberContractWithBloc();
  }
}

class _SignMemberContractWithBloc
    extends BaseScreenState<SignMemberContractWithBloc> {
  List<ContractMemberResponseModel>? _contractResponseModel;

  @override
  void initState() {
    Future.microtask(_getContractApiEvent);
    super.initState();
  }

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate(LocalizationKeys.memberContract)!)),
      body: BlocConsumer<SignContractBloc, SignContractState>(
        listener: (context, state) {
          if (state is SignContractLoadingState) {
            showMessageLoading(
                message: translate(
                    LocalizationKeys.preparingYourContractPleaseWait));
          } else {
            hideMessageLoading();
          }
          if (state is SignContractErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is GetContractMemberSuccessfullyState) {
            _contractResponseModel = state.response;
          } else if (state is ContractSignedSuccessfullyState) {
            showFeedbackMessage(state.response.message);
            _clearSignature();
            _closeScreen();
          } else if (state is SignContractErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)??""
                : state.errorMassage);
          }
        },
        builder: (context, state) => _agreementsWidget(),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////
  Widget _agreementsWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (_contractResponseModel != null)
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h),
                          child: Column(
                              children: List.generate(
                                  _contractResponseModel!.length ?? 0, (index) {
                            var item = _contractResponseModel![index];
                            return _contractSectionWidget(item.clauseName ?? "",
                                item.clauseDetails ?? "");
                          })))
                      : const SizedBox.shrink(),
                  SizedBox(
                      width: double.infinity,
                      child: AppElevatedButton(
                        label: Text(
                          translate(LocalizationKeys.signContractNow)!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: _onSignContractNowClicked,
                      )),
                ]),
          ),
        ),
      ),
    ]);
  }

  Widget _dateWidget(String checkIn, String checkOut) {
    return Row(
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
                checkIn,
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
                checkOut,
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
    );
  }

  Widget _priceWidget(String priceValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          translate(LocalizationKeys.rentPricePerMonth)!,
          style: const TextStyle(
            color: Color(0xFF667084),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "$priceValue€",
          maxLines: 1,
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  Widget _signatureWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0.h, horizontal: 16.h),
          child: DottedBorder(
            borderType: BorderType.Rect,
            radius: const Radius.circular(8),
            padding: const EdgeInsets.all(4),
            color: AppColors.signatureBorderColor,
            dashPattern: const [10, 10],
            child: Signature(
              controller: _signatureController,
              height: 200.h,
              width: 290.w,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.appCancelButtonBackground,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: AppElevatedButton.withTitle(
                onPressed: () => {_signatureController.clear()},
                title: translate(LocalizationKeys.clear)!,
                color: Colors.white,
                textColor: AppColors.colorPrimary,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: AppTextButton(
                  onPressed: () => {_onConfirmSignatureClicked()},
                  child: Text(
                    translate(LocalizationKeys.checkSignature)!,
                    style: themeData.textTheme.labelMedium?.copyWith(
                        color: AppColors.appSecondButton,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )),
            ),
          ],
        )
      ],
    );
  }

  Widget _signatureConfirmWidget(file) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0.h, horizontal: 16.h),
          child: DottedBorder(
            borderType: BorderType.Rect,
            radius: const Radius.circular(8),
            padding: const EdgeInsets.all(4),
            color: AppColors.signatureBorderColor,
            dashPattern: const [10, 10],
            child: Image.file(
              file,
              height: 200.h,
              width: 290.w,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.appCancelButtonBackground,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: AppElevatedButton.withTitle(
                onPressed: () {
                  _signatureController.clear();
                  _dismissSignatureBottomSheet();
                },
                title: translate(LocalizationKeys.clear)!,
                color: Colors.white,
                textColor: AppColors.colorPrimary,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: AppTextButton(
                  onPressed: () {
                    currentBloc.add(
                      SignMemberContractApiEvent(file.path),
                    );
                    _dismissSignatureBottomSheet();
                  },
                  child: Text(
                    translate(LocalizationKeys.confirm)!,
                    style: themeData.textTheme.labelMedium?.copyWith(
                        color: AppColors.appSecondButton,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )),
            ),
          ],
        )
      ],
    );
  }

  Widget _contractSectionWidget(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          style: const TextStyle(
            color: Color(0xFF344054),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Text(
            description,
            style: const TextStyle(
              color: Color(0xFF605D62),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  SignContractBloc get currentBloc =>
      BlocProvider.of<SignContractBloc>(context);

  void _changeTermsCheckboxState(bool value) {
    currentBloc.add(ChangeTermsAndConditionsStatusEvent(value));
  }

  void _showSignatureAlertDialog() {
    showSignatureAlertDialog(context: context);
  }

  void showSignatureBottomSheet() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: _signatureWidget(),
        title: translate(LocalizationKeys.yourSignature)!);
  }

  void _getContractApiEvent() {
    currentBloc.add(
      GetMemberContractEvent(),
    );
  }

  void _signContractApiEvent() async {
    final exportController = SignatureController(
        penStrokeWidth: 5,
        exportBackgroundColor: Colors.white,
        penColor: Colors.black,
        points: _signatureController.points);
    final signatureImageBytes = await exportController.toPngBytes();
    if (_signatureController.isNotEmpty && signatureImageBytes != null) {
      Uint8List imageInUnit8List = signatureImageBytes;

      final tempDir = await getTemporaryDirectory();
      final randomNum = DateTime.now().millisecondsSinceEpoch;

      File file =
          await File('${tempDir.path}/signature-image$randomNum.png').create();
      file.writeAsBytesSync(imageInUnit8List);
      AppBottomSheet.openAppBottomSheet(
          context: context,
          child: _signatureConfirmWidget(file),
          title: translate(LocalizationKeys.yourSignature)!);
    }
  }

  void _onSignContractNowClicked() {
    showSignatureBottomSheet();
  }

  void _onConfirmSignatureClicked() {
    if (_signatureController.isNotEmpty) {
      _dismissSignatureBottomSheet();
      _signContractApiEvent();
    } else {
      showFeedbackMessage(translate(LocalizationKeys.pleaseAddYourSignature)!);
    }
  }

  void _closeScreen() {
    Navigator.of(context).pop();
  }

  void _dismissSignatureBottomSheet() {
    Navigator.of(context).pop();
  }

  void _clearSignature() {
    _signatureController.clear();
  }

  void _signLaterClicked() {
    Navigator.of(context).pop();
  }
}
