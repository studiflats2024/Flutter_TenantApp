import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/chat_api_manger.dart';
import 'package:vivas/apis/managers/file_api_mangers.dart';
import 'package:vivas/apis/models/general/faq_list_wrapper.dart';
import 'package:vivas/feature/app_pages/screen/faq_list_screen.dart';
import 'package:vivas/feature/contact_support/bloc/contact_support_bloc.dart';
import 'package:vivas/feature/contact_support/bloc/contact_support_repository.dart';
import 'package:vivas/feature/contact_support/screen/chat_history_screen.dart';
import 'package:vivas/feature/contact_support/widgets/common_faq_item_widget.dart';
import 'package:vivas/feature/problem/screen/select_apartment_problem_screen.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/loaders/loader_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ContactSupportScreen extends StatelessWidget {
  ContactSupportScreen({Key? key}) : super(key: key);
  static const routeName = '/contact-support-screen';

  static open(BuildContext context) async {
    await Navigator.of(context).pushNamed(routeName);
  }

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactSupportBloc>(
      create: (context) => ContactSupportBloc(ContactSupportRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        chatApiManger: ChatApiManger(dioApiManager , context),
        uploadFileApiManager: UploadFileApiManager(dioApiManager , context),
      )),
      child: const ContactSupportScreenWithBloc(),
    );
  }
}

class ContactSupportScreenWithBloc extends BaseStatefulScreenWidget {
  const ContactSupportScreenWithBloc({super.key});

  @override
  BaseScreenState<ContactSupportScreenWithBloc> baseScreenCreateState() {
    return _ContactSupportScreenWithBloc();
  }
}

class _ContactSupportScreenWithBloc
    extends BaseScreenState<ContactSupportScreenWithBloc> {
  List<FAQModel> _commonFaqList = [];
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getCommonFaqApiEvent());
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(LocalizationKeys.contactSupport)!),
      ),
      body: BlocListener<ContactSupportBloc, ContactSupportState>(
        listener: (context, state) {
          if (state is ContactSupportLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state is ContactSupportErrorState) {
            showFeedbackMessage(state.isLocalizationKey
                ? translate(state.errorMassage)!
                : state.errorMassage);
          } else if (state is CommonFaqListLoadedState) {
            _commonFaqList = state.list;
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              _titleWidget(),
              _complaintsWidget(),
              _chatNowWidget(),
              const SizedBox(height: 10),
              _chatHistoryWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatNowWidget() {
    return GestureDetector(
      onTap: _chatNowClicked,
      child: Card(
        color: AppColors.colorPrimary,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Row(
            children: [
              SvgPicture.asset(
                AppAssetPaths.chatIcon,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(LocalizationKeys.chatNow)!,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 5.w),
                    Text(
                      translate(LocalizationKeys.needHelpChatWithUs)!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatHistoryWidget() {
    return GestureDetector(
      onTap: _chaHistoryClicked,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Row(
            children: [
              SvgPicture.asset(
                AppAssetPaths.chatIcon,
                colorFilter: const ColorFilter.mode(
                    AppColors.colorPrimary, BlendMode.srcIn),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(LocalizationKeys.chatHistory)!,
                      style: const TextStyle(
                          color: AppColors.colorPrimary, fontSize: 18),
                    ),
                    SizedBox(height: 5.w),
                    Text(
                      translate(LocalizationKeys.viewConversationHistory)!,
                      style: const TextStyle(
                          color: AppColors.colorPrimary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.colorPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Widget methods ///////////////////////
  ///////////////////////////////////////////////////////////

  Widget _complaintsWidget() {
    return BlocBuilder<ContactSupportBloc, ContactSupportState>(
      buildWhen: (previous, current) {
        if (current is CommonFaqListLoadedState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is CommonFaqListLoadedState) {
          return _buildListLoaded();
        } else {
          return const LoaderWidget();
        }
      },
    );
  }

  Widget _buildListLoaded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ..._commonFaqList
            .sublist(0, _commonFaqList.length > 5 ? 5 : _commonFaqList.length)
            .map((e) => CommonFaqItemWidget(faqModel: e))
            .toList(),
        AppTextButton.withTitle(
          title: translate(LocalizationKeys.showAllFaq)!,
          onPressed: _openAllFaqScreen,
        )
      ],
    );
  }

  Widget _titleWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          translate(LocalizationKeys.commonQuestions)!,
          style: const TextStyle(
            color: Color(0xFF505050),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          translate(LocalizationKeys.youCanFindAnAnswerToYourQuestionHere)!,
          style: const TextStyle(
            color: Color(0xFF676767),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  ContactSupportBloc get currentBloc =>
      BlocProvider.of<ContactSupportBloc>(context);

  void _getCommonFaqApiEvent() {
    currentBloc.add(const GetCommonFaqApiEvent());
  }

  void _chaHistoryClicked() {
    ChatHistoryScreen.open(context);
  }

  void _chatNowClicked() {
    SelectApartmentProblemScreen.open(context, openChatScreen: true);
  }

  void _openAllFaqScreen() {
    FaqListScreen.open(context);
  }
}
