import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:vivas/feature/home/bloc/home_bloc.dart';
import 'package:vivas/res/app_colors.dart';

import '../../../utils/locale/app_localization_keys.dart';

class ApartmentQrCodeDetails extends BaseStatefulScreenWidget {
  static const routeName = '/scan-apartment-qr-code';
  static const argumentHomeBloc = 'home-bloc';

  ApartmentQrCodeDetails({super.key});

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  static Future<void> open(BuildContext context, HomeBloc homeBloc) async {
    await Navigator.pushNamed(context, routeName,
        arguments: {argumentHomeBloc: homeBloc});
  }

  HomeBloc bookingDetails(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[ApartmentQrCodeDetails.argumentHomeBloc] as HomeBloc;

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return ApartmentQrCodeDetailsState();
  }
}

class ApartmentQrCodeDetailsState
    extends BaseScreenState<ApartmentQrCodeDetails> {
  int x = 0;
  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocProvider.value(
          value: widget.bookingDetails(context),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.transparent),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: AppColors.colorPrimary,
                          size: 20.r,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          translate(LocalizationKeys.back)!,
                          style: TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 18.sp),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      "${translate(LocalizationKeys.scanQrCode)!} ${translate(LocalizationKeys.apartment)!}",
                      style: TextStyle(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 18.sp),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 400.h,
                      child: QRView(
                        key: widget.qrKey,
                        formatsAllowed: const [BarcodeFormat.qrcode],
                        overlay: QrScannerOverlayShape(),
                        onQRViewCreated: (QRViewController controller) {
                          controller.scannedDataStream.listen((scanData) {
                            if (scanData.code != null && x ==0) {
                              setState(() {
                                x=1;
                              });
                              currentBloc
                                  .add(GetQrDetailsEvent(scanData.code ?? ""));
                              Navigator.pop(context);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  HomeBloc get currentBloc => widget.bookingDetails(context);
}
