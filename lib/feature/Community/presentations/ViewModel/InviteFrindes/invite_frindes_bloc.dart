import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/invite_frind_send_model.dart';
import 'package:vivas/feature/Community/Data/Models/invitations_history_model.dart';
import 'package:vivas/feature/Community/Data/Models/my_plan_model.dart';
import 'package:vivas/feature/Community/Data/Repository/InviteFriend/invite_friend_repository.dart';

part 'invite_frindes_event.dart';

part 'invite_frindes_state.dart';

class InviteFrindesBloc extends Bloc<InviteFrindesEvent, InviteFrindesState> {
  InviteFriendRepository repository;

  InviteFrindesBloc(this.repository) : super(InviteFrindesInitial()) {
    on<InviteFriendEvent>(_invite);
    on<GetMyPlanEvent>(_getPlan);
    on<GetInvitationsHistoryEvent>(_getInvitationsHistoryEvent);
    on<ChooseDateEvent>(_chooseDate);
  }

  _getPlan(GetMyPlanEvent event, Emitter<InviteFrindesState> emit) async {
    emit(InviteFriendsLoading());
    emit(await repository.getMyPlan());
  }

  FutureOr<void> _invite(
      InviteFriendEvent event, Emitter<InviteFrindesState> emit) async {
    emit(InviteFriendsLoading());
    emit(await repository.inviteFriend(event.model));
  }

  FutureOr<void> _getInvitationsHistoryEvent(GetInvitationsHistoryEvent event,
      Emitter<InviteFrindesState> emit) async {
    emit(InviteFriendsLoading());
    emit(await repository.getHistoryFriend(event.pagingListSendModel));
  }

  _chooseDate(ChooseDateEvent event, Emitter<InviteFrindesState> emit) {
    emit(ChooseDateState(event.date));
  }
}
