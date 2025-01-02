import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/models/ApartmentRules/apartment_rules_request.dart';
import 'package:vivas/apis/models/ApartmentRules/apartment_rules_response_model.dart';
import 'package:vivas/apis/models/booking/apartment_rules_model.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/bookings/bloc/apartment_rules_bloc.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';
import 'package:vivas/feature/bookings/screen/booking_details_screen.dart';
import 'package:vivas/feature/bookings/screen/congratulations_screen.dart';
import 'package:vivas/feature/bookings/widget/contact_us.dart';
import 'package:vivas/feature/contact_support/screen/contact_support_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_elevated_button.dart';
import 'package:vivas/feature/widgets/app_buttons/app_text_button.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import '../../../apis/_base/dio_api_manager.dart';
import '../../../apis/managers/apartment_requests_api_manger.dart';
import '../../../preferences/preferences_manager.dart';
import '../../../res/app_colors.dart';
import '../../../utils/locale/app_localization_keys.dart';

class ApartmentRulesScreen extends StatelessWidget {
  static const routeName = '/_apartment-rules-screen';
  static const argumentBookingDetails = 'booking-details';
  static const argumentFunctionBack = 'function-call-back';

  ApartmentRulesScreen({super.key});

  Function() onBack(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments as Map)[argumentFunctionBack]
          as Function();

  BookingDetailsModel bookingDetailsModel(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[ApartmentRulesScreen.argumentBookingDetails]
          as BookingDetailsModel;

  static Future<void> open(
    BuildContext context,
    BookingDetailsModel bookingDetailsModel,
    bool withReplacement,
    Function() onBack,
  ) async {
    if (withReplacement) {
      await Navigator.of(context).pushReplacementNamed(routeName, arguments: {
        argumentBookingDetails: bookingDetailsModel,
        argumentFunctionBack: onBack
      });
    } else {
      await Navigator.of(context).pushNamed(routeName, arguments: {
        argumentBookingDetails: bookingDetailsModel,
        argumentFunctionBack: onBack
      });
    }
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ApartmentRulesBloc(
        BookingsRepository(
          preferencesManager: GetIt.I<PreferencesManager>(),
          apartmentRequestsApiManger:
              ApartmentRequestsApiManger(dioApiManager, context),
        ),
      ),
      child: ApartmentRules(bookingDetailsModel(context), onBack(context)),
    );
  }
}

class ApartmentRules extends BaseStatefulScreenWidget {
  final BookingDetailsModel bookingDetailsModel;
  final Function() onBack;

  const ApartmentRules(this.bookingDetailsModel, this.onBack, {super.key});

  @override
  BaseScreenState<ApartmentRules> baseScreenCreateState() {
    return _ApartmentRulesScreenState();
  }
}

class _ApartmentRulesScreenState extends BaseScreenState<ApartmentRules> {
  TextEditingController controller = TextEditingController();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  late ApartmentRulesBloc apartmentRulesBloc;
  ApartmentRulesResponseModel? model;

  TapGestureRecognizer gestureRecognizer = TapGestureRecognizer();

  void _goToContactSupport() async {
    await ContactSupportScreen.open(context);
  }

  @override
  void initState() {
    apartmentRulesBloc = context.read<ApartmentRulesBloc>();
    gestureRecognizer.onTap = _goToContactSupport;
    Future.microtask(() {
      apartmentRulesBloc.add(GetApartmentRulesEvent(ApartmentRulesRequest(
          widget.bookingDetailsModel.bookingId ?? "",
          widget.bookingDetailsModel.apartmentId ?? "",
          widget.bookingDetailsModel
                  .guests?[widget.bookingDetailsModel.guestIndex].bedId ??
              "")));
    });
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ApartmentRulesBloc, ApartmentRulesState>(
        listener: (context, state) {
          if (state is GetApartmentRulesLoading ) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is SignApartmentRulesLoading) {
            showMessageLoading(message: translate(LocalizationKeys.preparingYourApartmentRulesPleaseWait));
          } else {
            hideMessageLoading();
          }

          if (state is GetApartmentRulesSuccess) {
            model = state.model;
          }
          if (state is SignApartmentRulesSuccess) {
            CongratulationsScreen.open(context);
          } else if (state is GetApartmentRulesException) {
            showFeedbackMessage(state.message);
          } else if (state is SignApartmentRulesException) {
            showFeedbackMessage(state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_back,
                              color: AppColors.colorPrimary,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              translate(LocalizationKeys.back)!,
                              style: const TextStyle(
                                  color: AppColors.colorPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      const Center(
                        child: Text(
                          'Sign Apartment Rules',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1A1B1E),
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: model?.rules?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model?.rules?[index] ?? "",
                                style: const TextStyle(
                                  color: Color(0xFF1A1B1E),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              // ListView.separated(
                              //   shrinkWrap: true,
                              //   physics: const NeverScrollableScrollPhysics(),
                              //   itemCount: model.rules?.length??0,
                              //   itemBuilder: (context, descIndex) {
                              //     return Row(
                              //       children: [
                              //         Container(
                              //           height: 5.h,
                              //           width: 5.w,
                              //           decoration: const BoxDecoration(
                              //               color: Colors.black,
                              //               shape: BoxShape.circle),
                              //         ),
                              //         Container(
                              //           width: 315.w,
                              //           padding: EdgeInsets.symmetric(
                              //               horizontal: 5.w),
                              //           child: Text(
                              //             rules[index].description[descIndex],
                              //             maxLines: 2,
                              //             style: const TextStyle(
                              //               color: Color(0xFF1A1B1E),
                              //               fontSize: 14,
                              //               fontWeight: FontWeight.w600,
                              //             ),
                              //             overflow: TextOverflow.clip,
                              //           ),
                              //         )
                              //       ],
                              //     );
                              //   },
                              //   separatorBuilder: (context, index) {
                              //     return SizedBox(
                              //       height: 10.h,
                              //     );
                              //   },
                              // )
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 20.h,
                          );
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      // Text(
                      //   translate(LocalizationKeys.signature) ?? "",
                      //   style: const TextStyle(
                      //     color: Color(0xFF1A1B1E),
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      // InkWell(
                      //   onTap: _onSignContractNowClicked,
                      //   child: Container(
                      //     height: 120.h,
                      //     width: 350.w,
                      //     decoration: BoxDecoration(
                      //         border: Border.all(color: Colors.grey),
                      //         borderRadius: BorderRadius.circular(20)),
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 10.w, vertical: 10.h),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         SvgPicture.asset(
                      //           AppAssetPaths.signatureIcon,
                      //           width: 50.w,
                      //           height: 50.h,
                      //         ),
                      //         SizedBox(
                      //           height: 5.h,
                      //         ),
                      //         const Text(
                      //           'Sign Here',
                      //           style: TextStyle(
                      //             color: Color(0xFF1F4068),
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.w400,
                      //             height: 0.11,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 10.h),
                    ],
                  ),
                  //
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  // Center(
                  //   child: Text.rich(
                  //     TextSpan(
                  //       text: translate(
                  //         LocalizationKeys.needHelp,
                  //       ),
                  //       style: const TextStyle(
                  //           color: AppColors.formFieldHintText),
                  //       children: [
                  //         TextSpan(
                  //           text: translate(LocalizationKeys.contactUs)!,
                  //           style: const TextStyle(
                  //               color: AppColors.colorPrimary,
                  //               fontWeight: FontWeight.w600),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 120.h,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          shrinkWrap: true,
          children: [
            AppElevatedButton(
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
            ),
            SizedBox(
              height: 10.h,
            ),
            Center(
              child: ContactUs(gestureRecognizer),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  void _onSignContractNowClicked() {
    showSignatureBottomSheet();
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
                  onPressed: () {
                    _onConfirmSignatureClicked();
                  },
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

  
  void _dismissSignatureBottomSheet() {
    Navigator.of(context).pop();
  }

  void _signContractApiEvent() async {
    final exportController = SignatureController(
        penStrokeWidth: 2,
        exportBackgroundColor: Colors.white,
        penColor: Colors.black,
        points: _signatureController.points);
    final signatureImageBytes = await exportController.toPngBytes();
    //final signatureImage=await _signatureController.toImage();
    Uint8List imageInUnit8List = signatureImageBytes!;
    //debugPrint(const Utf8Decoder().convert(imageInUnit8List));

    final imageData = await _signatureController
        .toPngBytes(); // must be called in async method
    // ignore: unused_local_variable
    final imageEncoded =
        base64.encode(imageData as List<int>); // returns base64 string

// callback variant
    _signatureController.toPngBytes().then((data) {
      final imageEncoded = base64.encode(data as List<int>);
      debugPrint(imageEncoded);
    });

    final tempDir = await getTemporaryDirectory();
    // final randfile = DateTime.now().millisecondsSinceEpoch;
    final randomNum = Random().nextInt(10);

    File file =
        await File('${tempDir.path}/signature-image$randomNum.png').create();
    file.writeAsBytesSync(imageInUnit8List);
    // final result = await ImageGallerySaver.saveImage(signature, name: name);
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: _signatureConfirmWidget(file),
        title: translate(LocalizationKeys.signRentalRules)!);
   
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
                    apartmentRulesBloc.add(SignApartmentRulesEvent(
                        widget.bookingDetailsModel.bookingId ?? "",
                        model?.rentRulesId ?? "",
                        file.path));
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
  
  void _onConfirmSignatureClicked() {
    if (_signatureController.isNotEmpty) {
      _dismissSignatureBottomSheet();
      _signContractApiEvent();
    } else {
      showFeedbackMessage(translate(LocalizationKeys.pleaseAddYourSignature)!);
    }
  }

  void showSignatureBottomSheet() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: _signatureWidget(),
        title: translate(LocalizationKeys.signRentalRules)!);
  }
}
