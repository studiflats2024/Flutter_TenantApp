import 'package:vivas/apis/managers/problems_api_manger.dart';
import 'package:vivas/apis/models/meta/paging_send_model.dart';
import 'package:vivas/feature/problem/bloc/my_problem_bloc.dart';
import 'package:vivas/feature/problem/model/edit_problem_end_model.dart';
import 'package:vivas/feature/problem/model/filter_enum.dart';
import 'package:vivas/feature/problem/model/send_problem_model.dart';
import 'package:vivas/preferences/preferences_manager.dart';

abstract class BaseMyProblemRepository {
  Future<MyProblemState> getMyProblemApi(
      int pageNumber, ProblemFilter problemFilter);
  Future<MyProblemState> getUserApartmentsApi();
  Future<MyProblemState> sendProblemApi(SendProblemModel sendProblemModel);
  Future<MyProblemState> getProblemDetailsApi(String problemId);
  Future<MyProblemState> editDescriptionApi(
      String problemId, String description);
}

class MyProblemRepository implements BaseMyProblemRepository {
  final PreferencesManager preferencesManager;
  final ProblemsApiManger problemsApiManger;

  MyProblemRepository({
    required this.preferencesManager,
    required this.problemsApiManger,
  });

  @override
  Future<MyProblemState> getMyProblemApi(
      int pageNumber, ProblemFilter problemFilter) async {
    late MyProblemState myProblemState;
    await problemsApiManger.getMyProblemsApi(
        PagingListSendModel(
            pageNumber: pageNumber,
            issueStatus: problemFilter.getApiKey), (myProblemListWrapper) {
      myProblemState = MyProblemLoadedState(
          myProblemListWrapper.data, myProblemListWrapper.pagingInfo);
    }, (errorApiModel) {
      myProblemState = MyProblemErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return myProblemState;
  }

  @override
  Future<MyProblemState> getUserApartmentsApi() async {
    late MyProblemState myProblemState;
    await problemsApiManger.getUserApartmentsApi((myProblemListWrapper) {
      myProblemState = UserApartmentsLoadedState(myProblemListWrapper.data);
    }, (errorApiModel) {
      myProblemState = MyProblemErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return myProblemState;
  }

  @override
  Future<MyProblemState> sendProblemApi(
      SendProblemModel sendProblemModel) async {
    late MyProblemState myProblemState;
    await problemsApiManger.sendProblemApi(sendProblemModel,
        (addProblemResponse) {
      myProblemState = const SendProblemSuccessfullyState();
    }, (errorApiModel) {
      myProblemState = MyProblemErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return myProblemState;
  }

  @override
  Future<MyProblemState> getProblemDetailsApi(String problemId) async {
    late MyProblemState myProblemState;
    await problemsApiManger.getProblemDetailsApi(problemId,
        (problemDetailsApiModel) {
      myProblemState = ProblemDetailsLoadedState(problemDetailsApiModel);
    }, (errorApiModel) {
      myProblemState = MyProblemErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return myProblemState;
  }

  @override
  Future<MyProblemState> editDescriptionApi(
      String problemId, String description) async {
    late MyProblemState myProblemState;
    await problemsApiManger.editDescriptionApi(
        EditProblemEndModel(problemId: problemId, newDescription: description),
        (editProblem) {
      myProblemState = EditProblemSuccessfullyState(editProblem);
    }, (errorApiModel) {
      myProblemState = MyProblemErrorState(
          errorApiModel.message, errorApiModel.isMessageLocalizationKey);
    });

    return myProblemState;
  }
}
