import 'package:vivas/feature/Community/presentations/ViewModel/QrDetails/qr_bloc.dart';

abstract class QrRepository {
  Future<QrState> getQrDetails();
}
