part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

final class SplashInitial extends SplashState {}

class SplashErrorState extends SplashState {
  final String errorMassage;
  final bool isLocalizationKey;
  const SplashErrorState(this.errorMassage, this.isLocalizationKey);

  @override
  List<Object> get props => [errorMassage, isLocalizationKey];
}

class AreaLoadedState extends SplashState {
  final List<AreaModel> data;
  const AreaLoadedState(this.data);

  @override
  List<Object> get props => [data];
}
class CitiesLoadedState extends SplashState {
  final List<CityModel> data;
  const CitiesLoadedState(this.data);

  @override
  List<Object> get props => [data];
}
