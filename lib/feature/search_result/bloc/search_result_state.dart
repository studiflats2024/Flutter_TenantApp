part of 'search_result_bloc.dart';

sealed class SearchResultState extends Equatable {
  const SearchResultState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class SearchResultInitial extends SearchResultState {}

class SearchResultLoadingAsPagingState extends SearchResultState {}

class SearchResultLoadingState extends SearchResultState {}

class SearchResultErrorState extends SearchResultState {
  final String errorMassage;
  final bool isLocalizationKey;
  const SearchResultErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class SearchResultLoadedState extends SearchResultState {
  final List<ApartmentItemApiModel> list;
  final MetaModel pagingInfo;

  const SearchResultLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list, pagingInfo];
}
