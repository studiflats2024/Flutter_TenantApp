import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:vivas/apis/errors/error_api_model.dart';
import 'package:vivas/feature/splash/bloc/splash_repository.dart';


part 'app_version_event.dart';
part 'app_version_state.dart';

class AppVersionBloc extends Bloc<AppVersionEvent, AppVersionState> {
  final BaseSplashRepository splashRepository;

  AppVersionBloc(this.splashRepository) : super(AppVersionInitial()) {
    on<GetVersion>(_checkVersion);
  }


  _checkVersion(GetVersion event, Emitter<AppVersionState> emit) async {
    emit(await splashRepository.checkingVersionApi(event.version));
  }
}
