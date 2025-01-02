import 'package:vivas/apis/managers/general_api_manger.dart';
import 'package:vivas/feature/app_pages/bloc/app_pages_bloc.dart';

abstract class BaseAppPagesRepository {
  Future<AppPagesState> getTermsConditionsApi();
  Future<AppPagesState> getPrivacyPrivacyApi();
  Future<AppPagesState> faqListApi();
}

class AppPagesRepository implements BaseAppPagesRepository {
  final GeneralApiManger generalApiManger;

  AppPagesRepository({required this.generalApiManger});

  @override
  Future<AppPagesState> getTermsConditionsApi() async {
    late AppPagesState appPagesState;

    await generalApiManger.getTermsConditionsApi((termsConditions) {
      appPagesState = TermsConditionsLoadedState(termsConditions);
    }, (errorApiModel) {
      appPagesState = AppPageErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return appPagesState;
  }

  @override
  Future<AppPagesState> getPrivacyPrivacyApi() async {
    late AppPagesState appPagesState;
    await generalApiManger.getPrivacyPrivacyApi((privacyModel) {
      appPagesState = PrivacyPrivacyLoadedState(privacyModel);
    }, (errorApiModel) {
      appPagesState = AppPageErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return appPagesState;
  }

  @override
  Future<AppPagesState> faqListApi() async {
    late AppPagesState appPagesState;
    await generalApiManger.getFaqApi((fAQListWrapper) {
      appPagesState = FaqListLoadedState(fAQListWrapper.data);
    }, (errorApiModel) {
      appPagesState = AppPageErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });
    return appPagesState;
  }
}
