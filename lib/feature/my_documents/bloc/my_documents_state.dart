part of 'my_documents_bloc.dart';

sealed class MyDocumentsState extends Equatable {
  const MyDocumentsState();

  @override
  List<Object> get props => [identityHashCode(this)];
}

final class MyDocumentsInitial extends MyDocumentsState {}

class MyDocumentsLoadingAsPagingState extends MyDocumentsState {}

class MyDocumentsLoadingState extends MyDocumentsState {}

class MyDocumentsErrorState extends MyDocumentsState {
  final String errorMassage;
  final bool isLocalizationKey;
  const MyDocumentsErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class MyDocumentsLoadedState extends MyDocumentsState {
  final List<DocumentApiModel> list;
  final MetaModel pagingInfo;

  const MyDocumentsLoadedState(this.list, this.pagingInfo);
  @override
  List<Object> get props => [list, pagingInfo];
}
