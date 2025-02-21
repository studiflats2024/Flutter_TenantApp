import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/apis/models/_base/base_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/activity_details_send.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/enroll_activity_send_model.dart';
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
    on<EnrollEvent>(_enroll);
    on<ChooseDayTimeEvent>(_chooseDay);
    on<ChooseTimeEvent>(_chooseTime);
    on<FilterRatingEvent>(_filterRating);
  }

  FutureOr<void> _getActivityDetails(
      GetActivityDetailsEvent event, Emitter<ActivityDetailsState> emit) async {
    emit(ActivityDetailsLoadingState());
    emit(await activityDetailsRepository
        .getActivityDetails(event.activityDetailsSendModel));
  }

  FutureOr<void> _enroll(
      EnrollEvent event, Emitter<ActivityDetailsState> emit) async {
    emit(ActivityDetailsLoadingState());
    emit(await activityDetailsRepository.enroll(event.model));
  }

  void _chooseDay(
      ChooseDayTimeEvent event, Emitter<ActivityDetailsState> emit) {

    emit(ChooseDayTimeState(event.day));
  }

  void _chooseTime(
      ChooseTimeEvent event, Emitter<ActivityDetailsState> emit) {

    emit(ChooseTimeState(event.time));
  }
  void _filterRating(
      FilterRatingEvent event, Emitter<ActivityDetailsState> emit) {

    emit(FilterRatingState(event.filter));
  }
}
