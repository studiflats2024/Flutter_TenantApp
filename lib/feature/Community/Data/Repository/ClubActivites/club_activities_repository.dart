import 'package:vivas/feature/Community/Data/Models/SendModels/paginated_club_activity_model.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/ClubActivity/club_activity_bloc.dart';

abstract class ClubActivitiesRepository {
  Future<ClubActivityState> getClubActivities(PagingCommunityActivitiesListSendModel model);
}