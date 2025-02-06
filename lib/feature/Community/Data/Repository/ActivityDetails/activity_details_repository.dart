import 'package:vivas/feature/Community/Data/Models/SendModels/activity_details_send.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/enroll_activity_send_model.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/ActivityDetails/activity_details_bloc.dart';

abstract class ActivityDetailsRepository {
  Future<ActivityDetailsState> getActivityDetails(
      ActivityDetailsSendModel activityDetailsSendModel);

  Future<ActivityDetailsState> enroll(EnrollActivitySendModel model);
}
