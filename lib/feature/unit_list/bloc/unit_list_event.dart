part of 'unit_list_bloc.dart';

sealed class UnitListEvent extends Equatable {
  const UnitListEvent();

  @override
  List<Object> get props => [];
}

class GetUniListApiEvent extends UnitListEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  const GetUniListApiEvent(this.pageNumber, this.isSwipeToRefresh);

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}
