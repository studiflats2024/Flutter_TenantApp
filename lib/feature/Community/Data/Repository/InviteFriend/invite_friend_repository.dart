import 'package:vivas/feature/Community/Data/Models/SendModels/invite_frind_send_model.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/InviteFrindes/invite_frindes_bloc.dart';

abstract class InviteFriendRepository {
  Future<InviteFrindesState> getMyPlan();

  Future<InviteFrindesState> inviteFriend(InviteFriendSendModel model);
}
