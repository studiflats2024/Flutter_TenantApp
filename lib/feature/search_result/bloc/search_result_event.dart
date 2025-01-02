part of 'search_result_bloc.dart';

sealed class SearchResultEvent extends Equatable {
  const SearchResultEvent();

  @override
  List<Object> get props => [];
}

class GetUniListWithSearchApiEvent extends SearchResultEvent {
  final int pageNumber;
  final bool isSwipeToRefresh;
  final bool useAreaFromFlitter;
  final SearchModel searchModel;
  final FilterModel filterModel;

  const GetUniListWithSearchApiEvent({
    required this.pageNumber,
    required this.isSwipeToRefresh,
    required this.searchModel,
    required this.filterModel,
    required this.useAreaFromFlitter,
  });

  bool isFirstLoad() => (pageNumber == 1) ? true : false;
  @override
  List<Object> get props => [pageNumber, isSwipeToRefresh];
}
