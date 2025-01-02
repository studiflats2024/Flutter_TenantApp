import 'package:vivas/apis/managers/apartment_api_manger.dart';
import 'package:vivas/apis/models/apartments/apartment_list/search_send_model.dart';
import 'package:vivas/feature/filter/model/filter_model.dart';
import 'package:vivas/feature/search/model/search_model.dart';
import 'package:vivas/feature/search_result/bloc/search_result_bloc.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseSearchResultRepository {
  Future<SearchResultState> getSearchResultApi(
      int pageNumber,
      SearchModel searchModel,
      FilterModel filterModel,
      bool useAreaFromFlitter);
}

class SearchResultRepository implements BaseSearchResultRepository {
  final PreferencesManager preferencesManager;
  final ApartmentApiManger apartmentApiManger;

  SearchResultRepository({
    required this.preferencesManager,
    required this.apartmentApiManger,
  });

  @override
  Future<SearchResultState> getSearchResultApi(
      int pageNumber,
      SearchModel searchModel,
      FilterModel filterModel,
      bool useAreaFromFlitter) async {
    late SearchResultState searchResultState;
    await apartmentApiManger.getSearchApartmentListApi(
        SearchSendModel(
          useAreaFromFlitter: useAreaFromFlitter,
          pageNumber: pageNumber,
          searchModel: searchModel,
          filterModel: filterModel,
        ), (apartmentListWrapper) {
      searchResultState = SearchResultLoadedState(
          apartmentListWrapper.data, apartmentListWrapper.pagingInfo);
    }, (errorApiModel) {
      searchResultState = SearchResultErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return searchResultState;
  }
}
