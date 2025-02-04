import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/activity_details_send.dart';
import 'package:vivas/feature/Community/Data/Models/activity_details_model.dart';
import 'package:vivas/feature/Community/Data/Repository/ActivityDetails/activity_details_repository.dart';

part 'activity_details_event.dart';

part 'activity_details_state.dart';

class ActivityDetailsBloc
    extends Bloc<ActivityDetailsEvent, ActivityDetailsState> {
  ActivityDetailsRepository activityDetailsRepository;

  ActivityDetailsBloc(this.activityDetailsRepository)
      : super(ActivityDetailsInitial()) {
    on<GetActivityDetailsEvent>(_getActivityDetails);
  }

  FutureOr<void> _getActivityDetails(
      GetActivityDetailsEvent event, Emitter<ActivityDetailsState> emit) async {
    emit(ActivityDetailsLoadingState());
    emit(await activityDetailsRepository
        .getActivityDetails(event.activityDetailsSendModel));
  }

}
