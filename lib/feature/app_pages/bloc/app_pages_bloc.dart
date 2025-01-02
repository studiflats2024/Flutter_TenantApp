import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/general/faq_list_wrapper.dart';
import 'package:vivas/apis/models/general/privacy_privacy_model.dart';
import 'package:vivas/apis/models/general/terms_conditions_model.dart';
import 'package:vivas/feature/app_pages/bloc/app_pages_repository.dart';

part 'app_pages_event.dart';
part 'app_pages_state.dart';

class AppPagesBloc extends Bloc<AppPagesEvent, AppPagesState> {
  final BaseAppPagesRepository pagesRepository;
  AppPagesBloc(this.pagesRepository) : super(AppPagesInitial()) {
    on<GetTermsConditionsApiEvent>(_getTermsConditionsApiEvent);
    on<GetPrivacyPrivacyApiEvent>(_getPrivacyPrivacyApiEvent);
    on<GetFaqListApiEvent>(_getFaqListApiEvent);
  }

  FutureOr<void> _getTermsConditionsApiEvent(
      GetTermsConditionsApiEvent event, Emitter<AppPagesState> emit) async {
    emit(AppPageLoadingState());
    emit(await pagesRepository.getTermsConditionsApi());
  }

  FutureOr<void> _getPrivacyPrivacyApiEvent(
      GetPrivacyPrivacyApiEvent event, Emitter<AppPagesState> emit) async {
    emit(AppPageLoadingState());
    emit(await pagesRepository.getPrivacyPrivacyApi());
  }

  FutureOr<void> _getFaqListApiEvent(
      GetFaqListApiEvent event, Emitter<AppPagesState> emit) async {
    emit(AppPageLoadingState());
    emit(await pagesRepository.faqListApi());
  }
}
