import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/Community/Data/Managers/community_manager.dart';
import 'package:vivas/feature/Community/Data/Models/SendModels/invite_frind_send_model.dart';
import 'package:vivas/feature/Community/Data/Repository/InviteFriend/invite_friend_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/InviteFrindes/invite_frindes_bloc.dart';

class InviteFriendRepositoryImplementation implements InviteFriendRepository {
  final CommunityManager communityManager;

  InviteFriendRepositoryImplementation(this.communityManager);

  @override
  Future<InviteFrindesState> inviteFriend(InviteFriendSendModel model) async {
    InviteFrindesState state = InviteFrindesInitial();

    await communityManager.inviteFriend(
      model,
      (successModel) {
        state = InviteFriendState();
      },
      (fail) {
        state = ErrorInviteFriendState(
          fail.message,
          fail.isMessageLocalizationKey,
        );
      },
    );

    return state;
  }

  @override
  Future<InviteFrindesState> getMyPlan() async {
    InviteFrindesState state = InviteFrindesInitial();

    await communityManager.getMyPlan((details) {
      state = GetMyPlanState(details);
    }, (fail) {
      state =
          ErrorInviteFriendState(fail.message, fail.isMessageLocalizationKey);
    });
    return state;
  }

  @override
  Future<InviteFrindesState> getHistoryFriend(PagingListSendModel model) async{
    InviteFrindesState state = InviteFrindesInitial();

    await communityManager.invitationsHistory(model,(details) {
      state = InviteHistoryFriendState(details);
    }, (fail) {
      state =
          ErrorInviteFriendState(fail.message, fail.isMessageLocalizationKey);
    });
    return state;
  }
}
