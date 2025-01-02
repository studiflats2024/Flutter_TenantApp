part of 'unit_list_bloc.dart';

sealed class UnitListState extends Equatable {
  const UnitListState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class UnitListInitial extends UnitListState {}

class UnitListLoadingAsPagingState extends UnitListState {}

class UnitListLoadingState extends UnitListState {}

class UnitListErrorState extends UnitListState {
  final String errorMassage;
  final bool isLocalizationKey;
  const UnitListErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class UnitListLoadedState extends UnitListState {
  final List<ApartmentItemApiModel> list;
  final MetaModel pagingInfo;

  const UnitListLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list, pagingInfo];
}
class UnitListLoadedStateV2 extends UnitListState {
  final List<ApartmentItemApiV2Model> list;
  final MetaModel pagingInfo;

  const UnitListLoadedStateV2(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list, pagingInfo];
}
