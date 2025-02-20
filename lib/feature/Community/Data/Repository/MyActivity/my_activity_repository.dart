import 'package:vivas/feature/Community/Data/Models/SendModels/my_activity_rating_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/my_activity_send_model.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/MyActivity/my_activity_bloc.dart';

abstract class MyActivityRepository {
  Future<MyActivityState> getMyActivity(
      MyActivitySendModel model, bool isFirst);

  Future<MyActivityState> unEnrollMyActivity(String id, int position);

  Future<MyActivityState> reviewMyActivity(
      MyActivityRatingSendModel model, int position);
}
