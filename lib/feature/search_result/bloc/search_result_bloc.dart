import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/apartments/apartment_list/apartment_item_api_model.dart';
import 'package:vivas/apis/models/meta/meta_model.dart';
import 'package:vivas/feature/filter/model/filter_model.dart';
import 'package:vivas/feature/search/model/search_model.dart';
import 'package:vivas/feature/search_result/bloc/search_result_repository.dart';

part 'search_result_event.dart';
part 'search_result_state.dart';

class SearchResultBloc extends Bloc<SearchResultEvent, SearchResultState> {
  final BaseSearchResultRepository searchResultRepository;
  SearchResultBloc(this.searchResultRepository) : super(SearchResultInitial()) {
    on<GetUniListWithSearchApiEvent>(_getUniListWithSearchApiEvent);
  }

  FutureOr<void> _getUniListWithSearchApiEvent(
      GetUniListWithSearchApiEvent event,
      Emitter<SearchResultState> emit) async {
    emit(SearchResultLoadingState());
    if (!event.isSwipeToRefresh) {
      emit((event.isFirstLoad())
          ? SearchResultLoadingState()
          : SearchResultLoadingAsPagingState());
    }
    emit(await searchResultRepository.getSearchResultApi(event.pageNumber,
        event.searchModel, event.filterModel, event.useAreaFromFlitter));
  }
}
