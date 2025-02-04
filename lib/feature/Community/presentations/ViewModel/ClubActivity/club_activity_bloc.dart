import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'club_activity_event.dart';
part 'club_activity_state.dart';

class ClubActivityBloc extends Bloc<ClubActivityEvent, ClubActivityState> {

  ClubActivityBloc() : super(ClubActivityInitial()) {
    on<ClubActivityEvent>((event, emit) {

    });
  }
}
