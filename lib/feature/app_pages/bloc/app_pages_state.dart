part of 'app_pages_bloc.dart';

sealed class AppPagesState extends Equatable {
  const AppPagesState();

  @override
  List<Object> get props => [];
}

final class AppPagesInitial extends AppPagesState {}

class AppPageLoadingState extends AppPagesState {}

class AppPageErrorState extends AppPagesState {
  final String errorMassage;
  final bool isLocalizationKey;
  const AppPageErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class TermsConditionsLoadedState extends AppPagesState {
  final TermsConditionsModel termsConditions;

  const TermsConditionsLoadedState(this.termsConditions);
  @override
  List<Object> get props => [termsConditions];
}

class PrivacyPrivacyLoadedState extends AppPagesState {
  final PrivacyPrivacyModel privacyModel;

  const PrivacyPrivacyLoadedState(this.privacyModel);
  @override
  List<Object> get props => [privacyModel];
}

class FaqListLoadedState extends AppPagesState {
  final List<FAQModel> list;

  const FaqListLoadedState(this.list);
  @override
  List<Object> get props => [list];
}
