import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vivas/apis/models/general/home_ads_list_wrapper.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class HomeSliderWidget extends StatefulWidget {
  final List<HomeAdsModel> adsList;

  const HomeSliderWidget(this.adsList, {Key? key}) : super(key: key);
  @override
  State<HomeSliderWidget> createState() => _HomeSliderWidgetState();
}

class _HomeSliderWidgetState extends State<HomeSliderWidget> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
              autoPlay: !_onlyOneOffer,
              scrollPhysics:
                  _onlyOneOffer ? const NeverScrollableScrollPhysics() : null,
              enlargeCenterPage: true,
              viewportFraction: 1,
              autoPlayAnimationDuration: const Duration(seconds: 1),
              aspectRatio: 1.8,
              onPageChanged: (index, _) {
                setState(() {
                  currentIndex = index;
                });
              }),
          itemCount: widget.adsList.length,
          itemBuilder: (_, index, __) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: ProductSliderItemWidget(widget.adsList[index]),
            );
          },
        ),
        Positioned(
          bottom: 5.h,
          child: Container(
              alignment: Alignment.bottomCenter,
              child: SliderCarouselIndicator(
                widget.adsList.length,
                currentIndex,
              )),
        ),
      ],
    );
  }

  bool get _onlyOneOffer => widget.adsList.length == 1;
}

class ProductSliderItemWidget extends StatelessWidget {
  final HomeAdsModel homeAdsModel;
  const ProductSliderItemWidget(this.homeAdsModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openPdfFile(context),
      child: AppCachedNetworkImage(
        imageUrl: homeAdsModel.photoAttach,
        width: double.infinity,
        boxFit: BoxFit.fill,
      ),
    );
  }

  Future<void> _openPdfFile(BuildContext context) async {
    try {
      if (await canLaunchUrlString(homeAdsModel.url)) {
        await launchUrlString(homeAdsModel.url,
            mode: LaunchMode.externalApplication);
      } else {
        // ignore: use_build_context_synchronously
        showFeedbackMessage(AppLocalizations.of(context)!
            .translate(LocalizationKeys.unableToOpenLink)!);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showFeedbackMessage(AppLocalizations.of(context)!
          .translate(LocalizationKeys.unableToOpenLink)!);
    }
  }
}

class SliderCarouselIndicator extends StatelessWidget {
  final int photoCount;
  final int activePhotoIndex;

  const SliderCarouselIndicator(this.photoCount, this.activePhotoIndex,
      {super.key});

  Widget _buildDot({bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        height: 5.h,
        width: isActive ? 15.w : 5.w,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.productSliderActiveIndicator
              : AppColors.productSliderDisableIndicator,
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(photoCount, (i) => i)
          .map((i) => _buildDot(isActive: i == activePhotoIndex))
          .toList(),
    );
  }
}
