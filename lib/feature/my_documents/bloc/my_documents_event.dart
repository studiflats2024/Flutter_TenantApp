part of 'my_documents_bloc.dart';

sealed class MyDocumentsEvent extends Equatable {
  const MyDocumentsEvent();

  @override
  List<Object> get props => [];
}

class GetMyDocumentsApiEvent extends MyDocumentsEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  const GetMyDocumentsApiEvent(this.pageNumber, this.isSwipeToRefresh);

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}
