import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/feature/Community/Data/Managers/activity_enum.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/paginated_club_activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/club_activity_model.dart';
import 'package:vivas/feature/Community/Data/Repository/ClubActivites/club_activities_repository.dart';

part 'club_activity_event.dart';

part 'club_activity_state.dart';

class ClubActivityBloc extends Bloc<ClubActivityEvent, ClubActivityState> {
  ClubActivitiesRepository repository;

  ClubActivityBloc(this.repository) : super(ClubActivityInitial()) {
    on<GetClubActivityEvent>(_getClubActivities);
    on<ChangeFilterActivityType>(_changeType);
  }

  _getClubActivities(
      GetClubActivityEvent event, Emitter<ClubActivityState> emit) async {
    emit(ClubActivityLoading());
    emit(await repository.getClubActivities(event.model));
  }

  _changeType(
      ChangeFilterActivityType event, Emitter<ClubActivityState> emit) async {
    emit(ChangeActivityTypeState(event.type));
  }
}
