import 'package:vivas/apis/managers/my_documents_api_manger.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/my_documents/bloc/my_documents_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseMyDocumentsRepository {
  Future<MyDocumentsState> getMyDocumentsApi(int pageNumber);
}

class MyDocumentsRepository implements BaseMyDocumentsRepository {
  final PreferencesManager preferencesManager;
  final MyDocumentsApiManger myDocumentsApiManger;

  MyDocumentsRepository({
    required this.preferencesManager,
    required this.myDocumentsApiManger,
  });

  @override
  Future<MyDocumentsState> getMyDocumentsApi(int pageNumber) async {
    late MyDocumentsState myDocumentsState;
    await myDocumentsApiManger.getMyDocumentsApi(
        PagingListSendModel(pageNumber: pageNumber), (invoicesListWrapper) {
      myDocumentsState =
          MyDocumentsLoadedState(invoicesListWrapper.data, MetaModel.demo());
    }, (errorApiModel) {
      myDocumentsState = MyDocumentsErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return myDocumentsState;
  }
}
