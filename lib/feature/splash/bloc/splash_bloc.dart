import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivas/apis/models/area_model/area_model.dart';
import 'package:vivas/apis/models/city_model/city_model.dart';
import 'package:vivas/feature/splash/bloc/splash_repository.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final BaseSplashRepository splashRepository;

  SplashBloc(this.splashRepository) : super(SplashInitial()) {
    on<GetAreaListApi>(_getAreaListApi);
    on<GetCityListApi>(_getCityListApi);
  }

  FutureOr<void> _getAreaListApi(
      GetAreaListApi event, Emitter<SplashState> emit) async {
   // emit(await splashRepository.getCityApi());
    emit(await splashRepository.getAreaApi());
  }

  FutureOr<void> _getCityListApi(
      GetCityListApi event, Emitter<SplashState> emit) async {
    emit(await splashRepository.getCityApi());
    // emit(await splashRepository.getAreaApi());
  }
}
