import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vivas/feature/Community/Data/Models/club_activity_model.dart';
import 'package:vivas/feature/Community/Data/Models/subscription_plans_model.dart';
import 'package:vivas/feature/Community/Data/Repository/CommunityScreen/community_repository.dart';

part 'community_event.dart';

part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityRepository communityRepository;

  CommunityBloc(this.communityRepository) : super(CommunityInitial()) {
    on<GetCommunityMonthlyActivities>(_getMonthlyActivities);
    on<GetCommunityClubActivities>(_getClubActivities);
    on<GetCommunitySubscriptionPlans>(_getSubscriptionPlans);
    on<CheckLoggedInEvent>(_checkLoggedIn);
  }

  _getMonthlyActivities(GetCommunityMonthlyActivities event, Emitter<CommunityState> emit) async {
    emit(CommunityLoadingState());
    emit(await communityRepository.getMonthlyActivities(event.pageNumber));
  }
  _getClubActivities(GetCommunityClubActivities event, Emitter<CommunityState> emit) async {
    emit(CommunityLoadingState());
    emit(await communityRepository.getClubActivities(event.pageNumber));
  }

  _getSubscriptionPlans(GetCommunitySubscriptionPlans event, Emitter<CommunityState> emit) async {
    emit(CommunityLoadingState());
    emit(await communityRepository.getSubscriptionPlans(event.pageNumber));
  }

  _checkLoggedIn(CheckLoggedInEvent event, Emitter<CommunityState> emit) async {
    emit(await communityRepository.checkLoggedIn());
  }

}
