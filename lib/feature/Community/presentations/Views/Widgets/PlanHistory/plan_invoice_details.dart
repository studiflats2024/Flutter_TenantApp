import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/apartment_requests/request_invoice/invoice_api_model.dart';
import 'package:vivas/feature/Community/presentations/Component/custom_app_bar.dart';
import 'package:vivas/feature/invoices/widgets/invoice_state_widget.dart';
import 'package:vivas/feature/widgets/dash_divider/dash_divider_widget.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/res/font_size.dart';

import 'package:vivas/utils/format/app_date_format.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// ignore: must_be_immutable
class CommunityInvoiceDetails extends BaseStatelessWidget {
  // final InvoiceApiModel invoiceApiModel;
  // final bool isMonthlyInvoice;
  //
  // final VoidCallback downloadClickedCallBack;
  // final VoidCallback payNowClickedCallBack;
  CommunityInvoiceDetails({
    super.key,
    // required this.invoiceApiModel,
    // required this.isMonthlyInvoice,
    // required this.downloadClickedCallBack,
    // required this.payNowClickedCallBack,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return InvoiceCardWithNotches();
    /*  Scaffold(
      backgroundColor: AppColors.scaffoldBackground2,
      appBar: CustomAppBar(
        title: LocalizationKeys.invoiceDetails,
        withBackButton: true,
        onBack: (){
          Navigator.pop(context);
        },
      ),
      body: Container(
        margin: EdgeInsets.all(SizeManager.sizeSp16),
        child: CustomPaint(
          size: Size(double.infinity, 500.r),
          painter: InvoicePainter(),
          child: Container(),
        ),
      ),
    );*/
  }

// Widget _titleWidget() {
//   return Row(
//     children: [
//       Expanded(
//         child: Column(
//           children: [
//             Text(
//               invoiceApiModel.aptName,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Color(0xFF1B1B2F),
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Text(
//               invoiceApiModel.aptAddress,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Color(0xFF475466),
//                 fontSize: 12,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       ),
//       const SizedBox(width: 5),
//       InvoiceStateWidget(invoiceApiModel.invPaid),
//     ],
//   );
// }
//
// Widget _invoiceInfoItem(String title, String value) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         title,
//         style: const TextStyle(
//           color: Color(0xFF475466),
//           fontSize: 12,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//       SizedBox(height: 4.h),
//       Text(
//         value,
//         style: const TextStyle(
//           color: Color(0xFF1B1B2F),
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     ],
//   );
// }
//
// Widget _invoicePaymentItem(String title, String value, {String? subTitle}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: Color(0xFF344053),
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             value,
//             style: const TextStyle(
//               color: Color(0xFF0F1728),
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//       if (subTitle != null)
//         Text(
//           subTitle,
//           style: const TextStyle(
//             color: Color(0xFF667084),
//             fontSize: 10,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//     ],
//   );
// }
//
// Widget _invoiceTotal(num total) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(
//         translate(LocalizationKeys.total)!,
//         style: const TextStyle(
//           color: Color(0xFF344053),
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       SizedBox(height: 4.h),
//       Text(
//         "€${total.toStringAsFixed(2)}",
//         style: const TextStyle(
//           color: Color(0xFF0F1728),
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ],
//   );
// }
//
// Widget _noteWidget() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         translate(LocalizationKeys.note)!,
//         style: const TextStyle(
//           color: Color(0xFF667084),
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       SizedBox(height: 4.h),
//       Text(
//         translate(LocalizationKeys
//             .afterTheLeasePeriodEndsYouCanRefundYourSecurityDeposit)!,
//         style: const TextStyle(
//           color: Color(0xFF667084),
//           fontSize: 13,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     ],
//   );
// }
//
// Widget _downloadButton() {
//   return InkWell(
//     borderRadius: BorderRadius.circular(25),
//     onTap: downloadClickedCallBack,
//     child: Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25),
//       ),
//       color: const Color(0xFFEAEEF3),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 10.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SvgPicture.asset(AppAssetPaths.downloadIcon),
//             SizedBox(width: 10.w),
//             Text(
//               translate(LocalizationKeys.downloadInvoice)!,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Color(0xFF2D4568),
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// Widget _payNowButton() {
//   return InkWell(
//     borderRadius: BorderRadius.circular(25),
//     onTap: payNowClickedCallBack,
//     child: Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25),
//       ),
//       color: const Color(0xFF1151B4),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 10.h),
//         child: Text(
//           translate(LocalizationKeys.payNow)!,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ),
//     ),
//   );
// }
}

class InvoiceCardWithNotches extends StatelessWidget {
  final double height = 480.r;

  // Cutout positions
  double firstCutoutY = 480.r * 0.16;
  double secondCutoutY = 480.r * 0.45;
  double thirdCutoutY = 480.r * 0.75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground2,
      appBar: AppBar(title: Text("Invoice")),
      body: Container(
        margin: EdgeInsets.all(SizeManager.sizeSp16),
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
                          width: 35.r,
                          height: 35.r,
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeManager.sizeSp4,
                              vertical: SizeManager.sizeSp8),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(SizeManager.circularRadius10),
                            color: AppColors.cardBorderGold.withOpacity(0.1),
                          ),
                          child: SvgPicture.asset(
                            AppAssetPaths.rateIcon,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextApp(
                          text: "Annual Plan",
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
                        text: "Paid",
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
                        _buildColumn("Payment Date", "Feb 25, 2025"),
                        SizedBox(
                          height: SizeManager.sizeSp8,
                        ),
                        _buildColumn("Start Date", "Feb 25, 2025"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildColumn("Invoice No.", "00125985"),
                        SizedBox(
                          height: SizeManager.sizeSp8,
                        ),
                        _buildColumn("Renewal Date", "Feb 25, 2026"),
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
                    _buildPaymentRow(LocalizationKeys.planPrice, "€ 380",
                        withPadding: true),
                    SizedBox(height: SizeManager.sizeSp8),
                    _buildPaymentRow(LocalizationKeys.vat, "€ 100",
                        withPadding: true),
                    SizedBox(height: SizeManager.sizeSp8),
                    _buildPaymentTotalRow(LocalizationKeys.total, "€ 480"),
                  ],
                ),
              ),
              // Download Invoice Button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeManager.sizeSp16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: LocalizationKeys.paymentMethod,
                            multiLang: true,
                            fontSize: FontSize.fontSize14,
                          ),
                          TextApp(
                            text: "Cash",
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            // Add your download invoice logic here
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
    );
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
