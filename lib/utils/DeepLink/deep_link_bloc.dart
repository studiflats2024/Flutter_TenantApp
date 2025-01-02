import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/apis/models/auth/login/login_successful_response.dart';

part 'deep_link_event.dart';
part 'deep_link_state.dart';

class DeepLinkBloc extends Bloc<DeepLinkEvent, DeepLinkState> {
  DeepLinkBloc() : super(DeepLinkInitial()){
    on<LogInEvent>(_autoLogin);
  }

  LoginSuccessfulResponse? loginSuccessfulResponse;


 _autoLogin(LogInEvent event ,Emitter<DeepLinkState>  emit){
    if(event.token == null && event.loginSuccessfulResponse != null ){
      loginSuccessfulResponse  = event.loginSuccessfulResponse;
      emit(LoginDeepLinkSuccess());
    } else{
      emit(LoginDeepLinkFailed());
    }
 }
}
