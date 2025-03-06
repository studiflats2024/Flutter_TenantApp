import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/pay_subscription_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/invoice_club_details_model.dart';
import 'package:vivas/feature/Community/Data/Repository/PlanHistory/plan_history_repository_implementation.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/PlanInvoiceDetails/plan_invoice_details_bloc.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanDetails/pay_subscription.dart';
import 'package:vivas/feature/Community/presentations/Views/Widgets/PlanHistory/club_terms.dart';
import 'package:vivas/feature/widgets/app_buttons/submit_button_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';

import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class CommunityInvoiceDetails extends BaseStatelessWidget {
  String id;

  CommunityInvoiceDetails(
    this.id, {
    super.key,
  });

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
      create: (context) => PlanInvoiceDetailsBloc(
          PlanHistoryRepositoryImplementation(CommunityManager(dioApiManager))),
      child: CommunityInvoiceDetailsWithBloc(id),
    );
  }
}

class CommunityInvoiceDetailsWithBloc extends BaseStatefulScreenWidget {
  final String id;

  const CommunityInvoiceDetailsWithBloc(this.id, {super.key});

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _CommunityInvoiceDetailsWithBloc();
  }
}

class _CommunityInvoiceDetailsWithBloc
    extends BaseScreenState<CommunityInvoiceDetailsWithBloc> {
  InvoiceClubDetailsModel? invoiceClubDetailsModel;

  PlanInvoiceDetailsBloc get currentBloc =>
      context.read<PlanInvoiceDetailsBloc>();

  bool checkTerms = false;

  @override
  void initState() {
    currentBloc.add(GetPlanTransactionDetails(widget.id));
    super.initState();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return BlocConsumer<PlanInvoiceDetailsBloc, PlanInvoiceDetailsState>(
      listener: (context, state) {
        if (state is PlanInvoiceDetailsLoading) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is PlanCheckTerms) {
          checkTerms = state.terms;
        } else if (state is PaySubscribePlanSuccessState) {
          if (state.response.isLink) {
            PaySubscription.open(context,
                    invoiceClubDetailsModel?.invoiceId ?? "", state.response)
                .then((v) {
              currentBloc.add(GetPlanTransactionDetails(widget.id));
            });
          } else {
            showFeedbackMessage(state.response);
          }
        } else if (state is GetInvoiceDetails) {
          invoiceClubDetailsModel = state.model;
        } else if (state is ErrorPlanInvoiceState) {
          showFeedbackMessage(state.isLocalizationKey
              ? translate(state.errorMassage) ?? ""
              : state.errorMassage);
        }
      },
      builder: (context, state) {
        return invoiceClubDetailsModel != null
            ? InvoiceCardWithNotches(
                invoiceClubDetailsModel!,
                checkTerms,
                checkTermsFunction,
                onClickToPay,
              )
            : Scaffold(
                appBar: AppBar(
                    title: Text(translate(LocalizationKeys.invoice) ?? " ")),
                body: Container());
      },
    );
  }

  checkTermsFunction(bool terms) {
    currentBloc.add(PlanCheckTermsEvent(terms));
  }

  onClickToPay() {
    AppBottomSheet.openAppBottomSheet(
        context: context,
        child: Column(
          children: [
            _methodWidget(translate(LocalizationKeys.onlinePayment)!,
                AppAssetPaths.creditCardIcon, () {
              currentBloc.add(
                PaySubscriptionEvent(
                  PaySubscriptionSendModel(
                      invoiceClubDetailsModel?.invoiceId ?? "", false),
                ),
              );
              Navigator.pop(context);
            }),
            _methodWidget(
                translate(LocalizationKeys.cash)!, AppAssetPaths.walletIcon,
                () {
              currentBloc.add(
                PaySubscriptionEvent(
                  PaySubscriptionSendModel(
                      invoiceClubDetailsModel?.invoiceId ?? "", true),
                ),
              );
              Navigator.pop(context);
            }),
          ],
        ),
        title: "Pay Methods");
  }

  Widget _methodWidget(String title, String logoPath, VoidCallback onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFF5F5F5)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(logoPath),
              SizedBox(width: 16.w),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF606060),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_outlined,
                  color: Color(0xff1D2939)),
            ],
          ),
        ),
      ),
    );
  }
}

class InvoiceCardWithNotches extends BaseStatelessWidget {
  final InvoiceClubDetailsModel invoiceClubDetailsModel;

  final Function(bool terms) checkTermsFunction;
  final Function() onClickPayNow;

  InvoiceCardWithNotches(this.invoiceClubDetailsModel, this.checkTerms,
      this.checkTermsFunction, this.onClickPayNow,
      {super.key});

  final double height = 480.r;

  bool checkTerms;

  // Cutout positions
  double firstCutoutY = 480.r * 0.16;
  double secondCutoutY = 480.r * 0.45;
  double thirdCutoutY = 480.r * 0.75;

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground2,
      appBar: AppBar(title: Text(translate(LocalizationKeys.invoice) ?? " ")),
      body: Container(
        margin: EdgeInsets.all(SizeManager.sizeSp16),
        child: SingleChildScrollView(
          child: CustomCard(
            height: height,
            firstCutoutY: firstCutoutY,
            secondCutoutY: secondCutoutY,
            thirdCutoutY: thirdCutoutY,
            borderRadius: 16,
            cutoutRadius: 12,
            backgroundColor: AppColors.textWhite,
            child: Stack(
              children: [
                // Plan Header
                Positioned(
                  top: height * .05,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30.r,
                            height: 30.r,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeManager.sizeSp4,
                                vertical: SizeManager.sizeSp6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(SizeManager.circularRadius8),
                              color: getColor(invoiceClubDetailsModel)
                                  .withOpacity(0.1),
                            ),
                            child: SvgPicture.asset(
                              getAsset(invoiceClubDetailsModel),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextApp(
                            text: invoiceClubDetailsModel.planName ?? "",
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackgroundEvent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: TextApp(
                          text: "${invoiceClubDetailsModel.paymentStatus}",
                          color: AppColors.cardBorderGreen,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Payment and Invoice Details
                Positioned(
                  top: height * .2,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildColumn("Payment Date",
                              invoiceClubDetailsModel.paymentDate ?? ""),
                          SizedBox(
                            height: SizeManager.sizeSp8,
                          ),
                          _buildColumn("Start Date",
                              invoiceClubDetailsModel.paymentDate ?? ""),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildColumn("Invoice No.",
                              invoiceClubDetailsModel.invoiceNo ?? ""),
                          SizedBox(
                            height: SizeManager.sizeSp8,
                          ),
                          _buildColumn("Renewal Date",
                              invoiceClubDetailsModel.renewelDate ?? ""),
                        ],
                      ),
                    ],
                  ),
                ),
                // Payment Details
                Positioned(
                  top: height * .48,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextApp(
                        text: LocalizationKeys.paymentDetails,
                        multiLang: true,
                        fontWeight: FontWeight.w500,
                        fontSize: FontSize.fontSize14,
                        color: AppColors.textMainColor,
                      ),
                      SizedBox(height: SizeManager.sizeSp8),
                      _buildPaymentRow(LocalizationKeys.planPrice,
                          "€ ${invoiceClubDetailsModel.subTotal ?? ""}",
                          withPadding: true),
                      SizedBox(height: SizeManager.sizeSp8),
                      _buildPaymentRow(LocalizationKeys.vat,
                          "€ ${invoiceClubDetailsModel.vat ?? ""}",
                          withPadding: true),
                      SizedBox(height: SizeManager.sizeSp8),
                      _buildPaymentTotalRow(LocalizationKeys.total,
                          "€ ${invoiceClubDetailsModel.total ?? ""}"),
                    ],
                  ),
                ),
                // Download Invoice Button
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeManager.sizeSp16),
                    child: invoiceClubDetailsModel.paymentStatus == "Pending"
                        ? Row(
                            children: [
                              Checkbox(
                                  value: checkTerms,
                                  activeColor: AppColors.colorPrimary,
                                  onChanged: (v) {
                                    if (v != null) {
                                      checkTermsFunction(v);
                                    }
                                  }),
                              GestureDetector(
                                onTap: () {
                                  if (checkTerms) {
                                  } else {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return ClubTerms();
                                    }));
                                  }
                                },
                                child: const SizedBox(
                                  width: 266,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'I agree with',
                                          style: TextStyle(
                                            color: Color(0xFF0A0C0F),
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            height: 1.50,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                            color: Color(0xFF0A0C0F),
                                            fontSize: 13,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            height: 1.38,
                                            letterSpacing: -0.08,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Terms',
                                          style: TextStyle(
                                            color: Color(0xFF1151B4),
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            height: 1.50,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                            color: AppColors.colorPrimary,
                                            fontSize: 13,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            height: 1.38,
                                            letterSpacing: -0.08,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'and ',
                                          style: TextStyle(
                                            color: AppColors.colorPrimary,
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            height: 1.50,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Conditions.',
                                          style: TextStyle(
                                            color: AppColors.colorPrimary,
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            height: 1.50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextApp(
                                    text: LocalizationKeys.paymentMethod,
                                    multiLang: true,
                                    fontSize: FontSize.fontSize14,
                                  ),
                                  TextApp(
                                    text:
                                        invoiceClubDetailsModel.paymentMethod ??
                                            "",
                                    fontSize: FontSize.fontSize14,
                                  ),
                                ],
                              ),
                              SizedBox(height: SizeManager.sizeSp25),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.colorPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  onPressed: () async {
                                    // Add your download invoice logic here
                                    if ((invoiceClubDetailsModel.url?.isLink ??
                                            false) &&
                                        await canLaunchUrl(Uri.parse(
                                            invoiceClubDetailsModel.url ??
                                                ""))) {
                                      await launchUrl(Uri.parse(
                                          invoiceClubDetailsModel.url ?? ""));
                                    } else {
                                      showFeedbackMessage("Download Failed");
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                      AppAssetPaths.communityDownloadIcon),
                                  label: TextApp(
                                    text: "Download Invoice",
                                    color: AppColors.textWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:invoiceClubDetailsModel.paymentStatus == "Pending"
          ? SizedBox(
        height: 110.r,
        child: SubmitButtonWidget(
            titleStyle: TextStyle(
              color: checkTerms ? AppColors.textWhite : AppColors.textMainColor,
            ),
            buttonColor:
                checkTerms ? AppColors.colorPrimary : AppColors.buttonGrey,
            title: translate(LocalizationKeys.payNow) ?? "",
            onClicked: () {
              if (checkTerms) {
                onClickPayNow();
              } else {
                ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.info,
                        text:
                            "To pay your Subscription , please read and confirm our terms and conditions."));
              }
            }),
      ) : null,
    );
  }

  String getAsset(InvoiceClubDetailsModel? item) {
    switch (item?.planDurationInMonth) {
      case 12:
        return AppAssetPaths.rateIcon;
      case 1:
        return AppAssetPaths.personIcon;
      default:
        return AppAssetPaths.calenderIcon2;
    }
  }

  Color getColor(InvoiceClubDetailsModel? item) {
    switch (item?.planDurationInMonth) {
      case 12:
        return AppColors.cardBorderGold;
      case 1:
        return AppColors.cardBorderGreen;
      default:
        return AppColors.colorPrimary;
    }
  }

  Widget _buildColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextApp(
          text: title,
          fontSize: FontSize.fontSize14,
          color: AppColors.textNatural700,
        ),
        const SizedBox(height: 4),
        TextApp(
          text: value,
          fontWeight: FontWeight.w500,
          fontSize: FontSize.fontSize14,
          color: AppColors.textMainColor,
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String amount,
      {bool withPadding = false}) {
    return Padding(
      padding: withPadding
          ? EdgeInsets.symmetric(horizontal: SizeManager.sizeSp8)
          : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextApp(
            text: label,
            multiLang: true,
            fontSize: FontSize.fontSize14,
            color: AppColors.textNatural700,
          ),
          TextApp(
            text: amount,
            fontSize: FontSize.fontSize14,
            color: AppColors.textMainColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTotalRow(String label, String amount) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeManager.sizeSp8, vertical: SizeManager.sizeSp12),
      decoration: BoxDecoration(
        color: AppColors.colorPrimaryLight,
        borderRadius: BorderRadius.all(
          SizeManager.circularRadius8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextApp(
            text: label,
            multiLang: true,
            fontWeight: FontWeight.w500,
            fontSize: FontSize.fontSize14,
            color: AppColors.colorPrimary,
          ),
          TextApp(
            text: amount,
            fontWeight: FontWeight.w500,
            fontSize: FontSize.fontSize14,
            color: AppColors.colorPrimary,
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final double height;
  final double borderRadius;
  final double cutoutRadius;
  final Color backgroundColor;
  final Widget child;
  final double firstCutoutY;
  final double secondCutoutY;
  final double thirdCutoutY;

  const CustomCard({
    Key? key,
    required this.height,
    required this.child,
    required this.firstCutoutY,
    required this.secondCutoutY,
    required this.thirdCutoutY,
    this.borderRadius = 8,
    this.cutoutRadius = 8,
    this.backgroundColor = const Color(0xFFEAF3FF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CardPainter(
          borderRadius: borderRadius,
          cutoutRadius: cutoutRadius,
          backgroundColor: backgroundColor,
          dashColor: AppColors.cardBorderPrimary100,
          dashWidth: 8.r,
          dashSpace: 3.r,
          firstCutoutY: firstCutoutY,
          secondCutoutY: secondCutoutY,
          thirdCutoutY: thirdCutoutY),
      child: Container(
        height: height,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: SizeManager.sizeSp16),
        child: child,
      ),
    );
  }
}

class CardPainter extends CustomPainter {
  final double cutoutRadius;
  final double borderRadius;
  final Color backgroundColor;
  final Color dashColor;
  final double dashWidth;
  final double dashSpace;
  final double firstCutoutY;
  final double secondCutoutY;
  final double thirdCutoutY;

  CardPainter({
    required this.cutoutRadius,
    required this.borderRadius,
    required this.backgroundColor,
    required this.dashColor,
    required this.dashWidth,
    required this.dashSpace,
    required this.firstCutoutY,
    required this.secondCutoutY,
    required this.thirdCutoutY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the background
    final paint = Paint()..color = backgroundColor;

    // Paint for the dashed line
    final dashPaint = Paint()
      ..color = dashColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Define the path for the card background
    final path = Path();

    // // Cutout positions
    // final firstCutoutY = size.height * 0.14;
    // final secondCutoutY = size.height * 0.5;
    // final thirdCutoutY = size.height * 0.76;

    path
      ..moveTo(borderRadius, 0) // Start at the top-left corner with rounding
      ..lineTo(size.width - borderRadius, 0)
      ..arcToPoint(
        Offset(size.width, borderRadius),
        radius: Radius.circular(borderRadius),
      )
      // ..lineTo(size.width, firstCutoutY - cutoutRadius)
      // ..arcToPoint(
      //   Offset(size.width, firstCutoutY + cutoutRadius),
      //   radius: Radius.circular(cutoutRadius),
      //   clockwise: false,
      // )
      ..lineTo(size.width, secondCutoutY - cutoutRadius)
      ..arcToPoint(
        Offset(size.width, secondCutoutY + cutoutRadius),
        radius: Radius.circular(cutoutRadius),
        clockwise: false,
      )
      ..lineTo(size.width, thirdCutoutY - cutoutRadius)
      ..arcToPoint(
        Offset(size.width, thirdCutoutY + cutoutRadius),
        radius: Radius.circular(cutoutRadius),
        clockwise: false,
      )
      ..lineTo(size.width, size.height - borderRadius)
      ..arcToPoint(
        Offset(size.width - borderRadius, size.height),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(borderRadius, size.height)
      ..arcToPoint(
        Offset(0, size.height - borderRadius),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(0, thirdCutoutY + cutoutRadius)
      ..arcToPoint(
        Offset(0, thirdCutoutY - cutoutRadius),
        radius: Radius.circular(cutoutRadius),
        clockwise: false,
      )
      ..lineTo(0, secondCutoutY + cutoutRadius)
      ..arcToPoint(
        Offset(0, secondCutoutY - cutoutRadius),
        radius: Radius.circular(cutoutRadius),
        clockwise: false,
      )
      // ..lineTo(0, firstCutoutY + cutoutRadius)
      // ..arcToPoint(
      //   Offset(0, firstCutoutY - cutoutRadius),
      //   radius: Radius.circular(cutoutRadius),
      //   clockwise: false,
      // )
      ..lineTo(0, borderRadius)
      ..arcToPoint(
        Offset(borderRadius, 0),
        radius: Radius.circular(borderRadius),
      )
      ..close();

    // Draw the background
    canvas.drawPath(path, paint);

    // Draw dashed lines at the cutout positions
    _drawDashedLine(canvas, dashPaint, Offset(0, firstCutoutY),
        Offset(size.width, firstCutoutY));
    _drawDashedLine(canvas, dashPaint, Offset(cutoutRadius, secondCutoutY),
        Offset(size.width - cutoutRadius, secondCutoutY));
    _drawDashedLine(canvas, dashPaint, Offset(cutoutRadius, thirdCutoutY),
        Offset(size.width - cutoutRadius, thirdCutoutY));
  }

  // Helper method to draw a dashed line
  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    final totalWidth = (end - start).distance;
    final dashCount = (totalWidth / (dashWidth + dashSpace)).floor();
    final dx = (end.dx - start.dx) / totalWidth;
    final dy = (end.dy - start.dy) / totalWidth;

    double currentDistance = 0;
    for (int i = 0; i < dashCount; i++) {
      final dashStart = Offset(
        start.dx + dx * currentDistance,
        start.dy + dy * currentDistance,
      );
      currentDistance += dashWidth;
      final dashEnd = Offset(
        start.dx + dx * currentDistance,
        start.dy + dy * currentDistance,
      );
      currentDistance += dashSpace;
      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
