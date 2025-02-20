import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/my_activity_rating_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/my_activity_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/my_activity_response.dart';
import 'package:vivas/feature/Community/Data/Repository/MyActivity/my_activity_repository.dart';

part 'my_activity_event.dart';

part 'my_activity_state.dart';

class MyActivityBloc extends Bloc<MyActivityEvent, MyActivityState> {
  MyActivityRepository repository;

  MyActivityBloc(this.repository) : super(MyActivityInitial()) {
    on<GetMyActivityEvent>(_getMyActivity);

    on<UnEnrollEvent>(_unEnrollMyActivity);

    on<ReviewEvent>(_reviewMyActivity);
  }

  FutureOr<void> _getMyActivity(
      GetMyActivityEvent event, Emitter<MyActivityState> emit) async {
    emit(MyActivityLoading());
    emit(await repository.getMyActivity(event.model, event.isFirst));
  }

  FutureOr<void> _unEnrollMyActivity(
      UnEnrollEvent event, Emitter<MyActivityState> emit) async {
    emit(MyActivityLoading());
    emit(await repository.unEnrollMyActivity(event.id, event.position));
  }

  FutureOr<void> _reviewMyActivity(
      ReviewEvent event, Emitter<MyActivityState> emit) async {
    emit(MyActivityLoading());
    emit(await repository.reviewMyActivity(event.model, event.position));
  }
}
