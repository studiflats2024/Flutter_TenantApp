import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/feature/Community/Data/Repository/QrRepository/qr_repository.dart';

part 'qr_event.dart';

part 'qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  QrRepository qrRepository;

  QrBloc(this.qrRepository) : super(QrInitial()) {
    on<GetQrDetails>(_getQrDetails);
  }

  _getQrDetails(GetQrDetails event, Emitter<QrState> emit) async {
    emit(QrLoadingState());
    emit(await qrRepository.getQrDetails());
  }
}
