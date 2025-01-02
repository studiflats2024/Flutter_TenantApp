import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/apis/models/my_documents/document_api_model.dart';
import 'package:vivas/feature/my_documents/bloc/my_documents_repository.dart';

part 'my_documents_event.dart';
part 'my_documents_state.dart';

class MyDocumentsBloc extends Bloc<MyDocumentsEvent, MyDocumentsState> {
  final BaseMyDocumentsRepository myDocumentsRepository;
  MyDocumentsBloc(this.myDocumentsRepository) : super(MyDocumentsInitial()) {
    on<GetMyDocumentsApiEvent>(_getInvoicesApiEvent);
  }

  FutureOr<void> _getInvoicesApiEvent(
      GetMyDocumentsApiEvent event, Emitter<MyDocumentsState> emit) async {
    emit(MyDocumentsLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? MyDocumentsLoadingState()
          : MyDocumentsLoadingAsPagingState());
    }
    emit(await myDocumentsRepository.getMyDocumentsApi(event.pageNumber));
  }
}
