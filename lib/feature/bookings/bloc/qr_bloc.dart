import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/apis/models/booking/qr_request_model.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';

part 'qr_event.dart';

part 'qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  final BaseBookingsRepository baseBookingsRepository;

  QrBloc(this.baseBookingsRepository) : super(QrInitial()) {
    on<QrQuestionEvent>(onQrQuestionEvent);
    on<QrSendingEvent>(sendScannedCode);
    on<QrErrorEvent>(onQrErrorEvent);
  }

  bool question = false;
  bool error = false;

  onQrQuestionEvent(QrQuestionEvent qrQuestionEvent, Emitter<QrState> emit) {
    question = !question;
    emit(QrInitial());
  }

  onQrErrorEvent(QrErrorEvent qrQuestionEvent, Emitter<QrState> emit) {
    error = !error;
    emit(QrInitial());
  }

  sendScannedCode(QrSendingEvent qrSendingEvent, Emitter<QrState> emit) async {
    // 352479
    emit(QrLoading());
    emit(await baseBookingsRepository.scanQrCodeBedApi(
      QrRequestModel(
        bookingId: qrSendingEvent.bookingId,
        bedId: qrSendingEvent.bedId,
        scannedQr: qrSendingEvent.scannedQr,
      ),
    ));
  }
}
