import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/models/booking/booking_details_model.dart';
import 'package:vivas/feature/bookings/bloc/qr_bloc.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

import '../../../res/app_colors.dart';
import '../../../utils/locale/app_localization_keys.dart';

class QrScannerScreen extends StatelessWidget {
  static const routeName = '/qr-scanner';

  static const argumentsGuest = 'guest';
  static const argumentsBookingDetails = 'bookingDetails';
  static const argumentsBloc = 'Block';

  const QrScannerScreen({super.key});

  static Future open(BuildContext context, BookingDetailsModel bookingDetails,
      Guest guest, QrBloc qrBloc) async {
    await Navigator.of(context).pushNamed(routeName, arguments: {
      argumentsGuest: guest,
      argumentsBookingDetails: bookingDetails,
      argumentsBloc: qrBloc
    });
  }

  Guest guest(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[QrScannerScreen.argumentsGuest] as Guest;

  BookingDetailsModel bookingDetails(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
              as Map)[QrScannerScreen.argumentsBookingDetails]
          as BookingDetailsModel;

  QrBloc qrBloc(BuildContext context) =>
      (ModalRoute.of(context)!.settings.arguments
          as Map)[QrScannerScreen.argumentsBloc] as QrBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: qrBloc(context),
      child: QrScannerScreenState(
        guest: guest(context),
        bookingDetails: bookingDetails(context),
      ),
    );
  }
}

class QrScannerScreenState extends BaseStatefulScreenWidget {
  const QrScannerScreenState({
    required this.guest,
    required this.bookingDetails,
    super.key,
  });

  final Guest guest;
  final BookingDetailsModel bookingDetails;

  @override
  BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
    return _QrScannerScreenStateState();
  }
}

class _QrScannerScreenStateState extends BaseScreenState<QrScannerScreenState> {
  late QrBloc currentBloc;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  int x = 0;

  @override
  void initState() {
    // currentBloc = context.read<QrBloc>();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
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
                    translate(LocalizationKeys.scanQrCode)!,
                    style: TextStyle(
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 18.sp),
                  ),
                  SizedBox(height: 20.h,),
                  SizedBox(
                    width: double.infinity,
                    height: 400.h,
                    child: QRView(
                      key: qrKey,
                      formatsAllowed: const [BarcodeFormat.qrcode],
                      overlay: QrScannerOverlayShape(),
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if(x==0){
        setState(() {
          x=1;
        });
        if (scanData.code != widget.guest.qRCode) {
          Navigator.pop(context, false);
        } else {
          Navigator.pop(context, true);
        }

      }

    });
  }
}
