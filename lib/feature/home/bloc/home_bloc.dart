import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vivas/apis/models/apartments/ApartmentQrDetails/apartment_qr_details_model.dart';
import 'package:vivas/apis/models/apartments/apartment_list/apartment_item_api_model.dart';
import 'package:vivas/apis/models/general/home_ads_list_wrapper.dart';
import 'package:vivas/feature/home/bloc/home_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BaseHomeRepository homeRepository;

  HomeBloc(this.homeRepository) : super(HomeInitial()) {
    on<GetSliderInfoApiEvent>(_getSliderInfoApiEvent);
    on<GetBestOfferInfoApiEvent>(_getBestOfferInfoApiEvent);
    on<BestOfferSeeAllClickedEvent>(_bestOfferSeeAllClickedEvent);
    on<GetNotificationCountApiEvent>(_getNotificationCountApiEvent);
    on<GetQrDetailsEvent>(_getQrDetails);
  }

  FutureOr<void> _getSliderInfoApiEvent(
      GetSliderInfoApiEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    emit(await homeRepository.getSliderInfo());
  }

  FutureOr<void> _getBestOfferInfoApiEvent(
      GetBestOfferInfoApiEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    emit(await homeRepository.getBestOfferInfoApi());
  }

  FutureOr<void> _bestOfferSeeAllClickedEvent(
      BestOfferSeeAllClickedEvent event, Emitter<HomeState> emit) async {
    emit(OpenUnitListScreenState());
  }

  FutureOr<void> _getNotificationCountApiEvent(
      GetNotificationCountApiEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    emit(await homeRepository.getNotificationCountApi());
  }

  FutureOr<void> _getQrDetails(
      GetQrDetailsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    emit(await homeRepository.getQrDetailsApi(qrCode: event.qrCode));
  }


}
