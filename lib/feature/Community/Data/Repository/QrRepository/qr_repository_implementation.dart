import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Repository/QrRepository/qr_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/QrDetails/qr_bloc.dart';

class QrRepositoryImplementation implements QrRepository {
  QrRepositoryImplementation(this.communityManager);

  CommunityManager communityManager;

  @override
  Future<QrState> getQrDetails() async {
    QrState qrState = QrInitial();
    await communityManager.getMyQr((details) {
      qrState = QrLoadedState(details);
    }, (fail) {
      qrState = QrErrorState(fail.message, fail.isMessageLocalizationKey);
    });
    return qrState;
  }

  @override
  Future<QrState> openDoorLock() async{
    QrState qrState = QrInitial();
    await communityManager.getDoorLock((details) {
      qrState = OpenDoorLockState(details);
    }, (fail) {
      qrState = QrErrorState(fail.message, fail.isMessageLocalizationKey);
    });
    return qrState;
  }

}
