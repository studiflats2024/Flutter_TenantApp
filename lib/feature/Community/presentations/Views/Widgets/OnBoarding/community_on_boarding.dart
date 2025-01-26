import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/Community/Data/Models/on_boarding_model.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/on_boarding_bloc.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_app.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/size_manager.dart';

// class AboutCommunity extends BaseStatefulScreenWidget {
//   const AboutCommunity({super.key});
//
//   @override
//   BaseScreenState<BaseStatefulScreenWidget> baseScreenCreateState() {
//     return _AboutCommunity();
//   }
// }
//
// class _AboutCommunity extends BaseScreenState<AboutCommunity> {
//   PageController controller = PageController();
//
//   List<OnBoardingModel> onBoardingList = [
//     OnBoardingModel(
//       asset: AppAssetPaths.onBoardingCommunity1,
//       title: "Welcome to the community club!",
//       description:
//       "The Community Club is a social hub for our tenants to connect and unwind in a relaxed environment",
//     ),
//     OnBoardingModel(
//       asset: AppAssetPaths.onBoardingCommunity2,
//       title: "Fun and Socializing",
//       description:
//       "Enjoy games and social events at the club, where you can relax, meet new friends, and have fun",
//     ),
//     OnBoardingModel(
//       asset: AppAssetPaths.onBoardingCommunity3,
//       title: "Explore Our Courses",
//       description:
//       "Join various courses, including German language classes, designed to help you learn and grow.",
//     ),
//     OnBoardingModel(
//       asset: AppAssetPaths.onBoardingCommunity4,
//       title: "Workshop For Success",
//       description:
//       "Attend workshops that guide you through life in Germany and help you land your dream job",
//     ),
//     OnBoardingModel(
//       asset: AppAssetPaths.onBoardingCommunity5,
//       title: "Expert Consultants To Guide You",
//       description:
//       "Get professional advice from specialists in various fields like legal, career, and more to solve your problems efficiently.",
//     ),
//   ];
//
//   @override
//   Widget baseScreenBuild(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(
//         maxWidth: 300.w,
//       ),
//       child: aboutItem(
//         onBoardingList[0].asset,
//         onBoardingList[0].title,
//         onBoardingList[0].description,
//       ),
//       // child: PageView.builder(
//       //
//       //     itemBuilder: (context, index) {
//       //   var item = onBoardingList[index];
//       //   return aboutItem(
//       //     item.asset,
//       //     item.title,
//       //     item.description,
//       //   );
//       // }),
//     );
//   }
//
//   aboutItem(
//     String asset,
//     String title,
//     String description, {
//     Function()? onPrevious,
//     Function()? onNext,
//   }) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               // borderRadius: BorderRadius.only(
//               //   topRight: SizeManager.circularRadius25,
//               //   topLeft: SizeManager.circularRadius25,
//               // ),
//               image: DecorationImage(
//                 image: AssetImage(asset),
//                 fit: BoxFit.cover,
//               )),
//           width: double.infinity,
//           height: 220.r,
//         ),
//         Container(
//           decoration: BoxDecoration(
//             // borderRadius: BorderRadius.only(
//             //   bottomRight: SizeManager.circularRadius25,
//             //   bottomLeft: SizeManager.circularRadius25,
//             // ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextApp(
//                 text: title,
//                 style: textTheme.headlineLarge
//                     ?.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w800),
//               ),
//               TextApp(
//                 text: description,
//                 style: textTheme.bodyMedium,
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

class AboutCommunity extends BaseStatelessWidget {
  AboutCommunity({super.key});

  PageController controller = PageController();

  static List<OnBoardingModel> onBoardingList = [
    OnBoardingModel(
      asset: AppAssetPaths.onBoardingCommunity1,
      title: "Welcome to the Community Club!",
      description:
          "The Community Club is a social hub for our tenants to connect and unwind in a relaxed environment",
    ),
    OnBoardingModel(
      asset: AppAssetPaths.onBoardingCommunity2,
      title: "Fun and Socializing",
      description:
          "Enjoy games and social events at the club, where you can relax, meet new friends, and have fun",
    ),
    OnBoardingModel(
      asset: AppAssetPaths.onBoardingCommunity3,
      title: "Explore Our Courses",
      description:
          "Join various courses, including German language classes, designed to help you learn and grow.",
    ),
    OnBoardingModel(
      asset: AppAssetPaths.onBoardingCommunity4,
      title: "Workshop For Success",
      description:
          "Attend workshops that guide you through life in Germany and help you land your dream job",
    ),
    OnBoardingModel(
      asset: AppAssetPaths.onBoardingCommunity5,
      title: "Expert Consultants To Guide You",
      description:
          "Get professional advice from specialists in various fields like legal, career, and more to solve your problems efficiently.",
    ),
  ];

  static showOnBoarding(BuildContext context,bool canDismiss) {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: canDismiss,
      builder: (context) {
        return AlertDialog(
          clipBehavior: Clip.none,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(SizeManager.circularRadius25)),
          content: AboutCommunity(),
          insetPadding: EdgeInsets.only(
            right: SizeManager.sizeSp16,
            left: SizeManager.sizeSp16,
            bottom: 140.r,
          ),
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }

  int currentIndex = 0;

  @override
  Widget baseBuild(BuildContext context) {
    return BlocProvider(
      create: (_) => OnBoardingBloc(),
      child: SizedBox(
        height: 540.h,
        width: 400.w,
        child: Column(
          children: [
            SizedBox(
              height: 440.h,
              width: 400.w,
              child: PageView.builder(
                  controller: controller,
                  itemCount: onBoardingList.length,
                  itemBuilder: (context, index) {
                    var item = onBoardingList[index];
                    return aboutItem(
                      item.asset,
                      item.title,
                      item.description,
                    );
                  }),
            ),
            SizedBox(
              height: SizeManager.sizeSp54,
            ),
            BlocConsumer<OnBoardingBloc, OnBoardingState>(
              listener: (context, state) {
                if (state is OnBoardingChangePage) {
                  if (state.prev) {
                    controller.previousPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut);
                    currentIndex = state.pageIndex;
                  } else {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceOut);
                    currentIndex = state.pageIndex;
                  }
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeManager.sizeSp16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (controller.page != null && controller.page != 0) {
                            currentBloc(context).add(
                              ChangePageEvent(
                                (controller.page ?? 0).toInt() - 1,
                                true,
                              ),
                            );
                          }
                        },
                        child: TextApp(
                          multiLang: true,
                          text: LocalizationKeys.previous,
                          color: currentIndex != 0
                              ? AppColors.colorPrimary
                              : AppColors.textNatural400,
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: controller,
                        count: onBoardingList.length,
                        effect: ExpandingDotsEffect(
                          expansionFactor: 4,
                          dotHeight: SizeManager.sizeSp6,
                          dotWidth: SizeManager.sizeSp6,
                          radius: SizeManager.sizeSp6,
                        ),
                      ),
                      if (currentIndex == onBoardingList.length - 1) ...[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            // onPressed: () {
                            //   Navigator.of(context).pop();
                            // },
                            padding: EdgeInsets.symmetric(horizontal:SizeManager.sizeSp16, vertical: SizeManager.sizeSp8),
                            decoration: BoxDecoration(
                                color: AppColors.colorPrimary,
                                borderRadius: BorderRadius.all(
                                    SizeManager.circularRadius10)),
                            child: TextApp(
                              multiLang: true,
                              fontSize: 14.sp,
                              text: LocalizationKeys.start,
                              color: AppColors.textWhite,

                            ),
                          ),
                        ),
                      ] else ...[
                        InkWell(
                          onTap: () {
                            if (controller.page != null &&
                                controller.page! <
                                    (onBoardingList.length - 1)) {
                              currentBloc(context).add(ChangePageEvent(
                                  (controller.page ?? 0).toInt() + 1, false));
                            }
                          },
                          child: TextApp(
                            multiLang: true,
                            text: LocalizationKeys.next,
                            color: AppColors.colorPrimary,
                          ),
                        )
                      ]
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  bool isLastPage() {
    return controller.page?.round() == onBoardingList.length - 1;
  }

  aboutItem(
    String asset,
    String title,
    String description, {
    Function()? onPrevious,
    Function()? onNext,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: SizeManager.circularRadius25,
                topLeft: SizeManager.circularRadius25,
              ),
              image: DecorationImage(
                image: AssetImage(asset),
                fit: BoxFit.cover,
              )),
          width: double.infinity,
          height: 300.r,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 160.r,
            decoration: BoxDecoration(
              color: AppColors.textWhite,
              borderRadius: BorderRadius.all(
                SizeManager.circularRadius25,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeManager.sizeSp16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeManager.sizeSp32,
                ),
                SizedBox(
                  width: 200.r,
                  child: TextApp(
                    text: title,
                    style: textTheme.headlineLarge?.copyWith(
                        fontSize: 20.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: SizeManager.sizeSp18,
                ),
                SizedBox(
                  child: TextApp(
                    text: description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.cardTextNatural700,
                        fontSize: 16.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  OnBoardingBloc currentBloc(BuildContext context) =>
      BlocProvider.of<OnBoardingBloc>(context);
}
