import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galleryimage/gallery_image_view_wrapper.dart';
import 'package:galleryimage/gallery_item_model.dart';
import 'package:vivas/apis/models/apartments/apartment_details/apartment_details_api_model_v2.dart';
import 'package:vivas/apis/models/apartments/apartment_details/unit_details_api_model.dart';
import 'package:vivas/feature/unit_details/widget/details_header_action_widget.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';

class UnitImageSliderWidget extends StatefulWidget {
  final UnitDetailsApiModel unitDetailsApiModel;
  final Function(UnitDetailsApiModel model) shareClicked;

  const UnitImageSliderWidget({
    super.key,
    required this.unitDetailsApiModel,
    required this.shareClicked,
  });

  @override
  State<UnitImageSliderWidget> createState() => _UnitImageSliderWidgetState();
}

class _UnitImageSliderWidgetState extends State<UnitImageSliderWidget> {
  int currentIndex = 0;

  List<GalleryItemModel> get _buildGalleryItems {
    List<GalleryItemModel> galleryItems = [];
    for (var item in widget.unitDetailsApiModel.generalInfo.propertyImgs) {
      galleryItems.add(
        GalleryItemModel(
            id: item,
            imageUrl: item,
            index: widget.unitDetailsApiModel.generalInfo.propertyImgs
                .indexOf(item)),
      );
    }
    return galleryItems;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryImageViewWrapper(
              titleGallery: widget.unitDetailsApiModel.generalInfo.aptName,
              galleryItems: _buildGalleryItems,
              initialIndex: currentIndex,
              backgroundColor: Colors.black,
              loadingWidget: null,
              errorWidget: null,
              minScale: .7,
              maxScale: 3,
              radius: 0,
              reverse: false,
              showListInGalley: true,
              showAppBar: true,
              closeWhenSwipeUp: false,
              closeWhenSwipeDown: false,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
                autoPlay: false,
                scrollPhysics:
                    _onlyOneImage ? const NeverScrollableScrollPhysics() : null,
                enlargeCenterPage: true,
                viewportFraction: 1,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                aspectRatio: 8 / 6,
                onPageChanged: (index, _) {
                  setState(() {
                    currentIndex = index;
                  });
                }),
            itemCount:
                widget.unitDetailsApiModel.generalInfo.propertyImgs.length,
            itemBuilder: (_, index, __) {
              return AppCachedNetworkImage(
                imageUrl:
                    widget.unitDetailsApiModel.generalInfo.propertyImgs[index],
                height: double.infinity,
                width: double.infinity,
                boxFit: BoxFit.fill,
              );
            },
          ),
          PositionedDirectional(
              bottom: 10,
              end: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0x7F0F1728),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: Text(
                  '${currentIndex + 1} / ${widget.unitDetailsApiModel.generalInfo.propertyImgs.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
          PositionedDirectional(
            end: 30,
            top: kToolbarHeight,
            start: 30,
            child: DetailsHeaderActionWidget(
                shareClicked: widget.shareClicked,
                unitDetailsApiModel: widget.unitDetailsApiModel),
          ),
        ],
      ),
    );
  }

  bool get _onlyOneImage =>
      widget.unitDetailsApiModel.generalInfo.propertyImgs.length == 1;
}

class UnitImageSliderWidgetV2 extends StatefulWidget {
  final ApartmentDetailsApiModelV2 unitDetailsApiModel;
  final Function(ApartmentDetailsApiModelV2 model) shareClicked;
  final Function() onBack;

  const UnitImageSliderWidgetV2({
    super.key,
    required this.unitDetailsApiModel,
    required this.shareClicked,
    required this.onBack,
  });

  @override
  State<UnitImageSliderWidgetV2> createState() =>
      _UnitImageSliderWidgetStateV2();
}

class _UnitImageSliderWidgetStateV2 extends State<UnitImageSliderWidgetV2> {
  int currentIndex = 0;

  List<GalleryItemModel> get _buildGalleryItems {
    List<GalleryItemModel> galleryItems = [];
    for (ApartmentImages item in widget.unitDetailsApiModel.apartmentImages ?? []) {
      galleryItems.add(
        GalleryItemModel(
            id: item.title??"",
            imageUrl: item.url??"",
            index:
                widget.unitDetailsApiModel.apartmentImages?.indexOf(item) ?? 0),
      );
    }
    return galleryItems;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryImageViewWrapper(
              titleGallery: widget.unitDetailsApiModel.apartmentName ?? '',
              galleryItems: _buildGalleryItems,
              initialIndex: currentIndex,
              backgroundColor: Colors.black,
              loadingWidget: null,
              errorWidget: null,
              minScale: .7,
              maxScale: 3,
              radius: 0,
              reverse: false,
              showListInGalley: true,
              showAppBar: true,
              closeWhenSwipeUp: false,
              closeWhenSwipeDown: false,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
                autoPlay: false,
                scrollPhysics:
                    _onlyOneImage ? const NeverScrollableScrollPhysics() : null,
                enlargeCenterPage: true,
                viewportFraction: 1,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                aspectRatio: 8 / 6,
                onPageChanged: (index, _) {
                  setState(() {
                    currentIndex = index;
                  });
                }),
            itemCount: widget.unitDetailsApiModel.apartmentImages?.length ?? 0,
            itemBuilder: (_, index, __) {
              return AppCachedNetworkImage(
                title:  widget.unitDetailsApiModel.apartmentImages?[index].title ?? "",
                imageUrl:
                    widget.unitDetailsApiModel.apartmentImages?[index].url ?? "",
                height: double.infinity,
                width: double.infinity,
                boxFit: BoxFit.fill,
                // borderRadiusValue: BorderRadius.only(
                //   topRight: Radius.circular(15),
                //   topLeft: Radius.circular(15),
                // ),
              );
            },
          ),
          PositionedDirectional(
              bottom: 10,
              end: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0x7F0F1728),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: Text(
                  '${currentIndex + 1} / ${widget.unitDetailsApiModel.apartmentImages?.length ?? 0}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
          PositionedDirectional(
            end: 30,
            top: kToolbarHeight,
            start: 30,
            child: DetailsHeaderActionWidgetV2(
                shareClicked: widget.shareClicked,
                unitDetailsApiModel: widget.unitDetailsApiModel, onBack: widget.onBack,),
          ),
        ],
      ),
    );
  }

  bool get _onlyOneImage =>
      widget.unitDetailsApiModel.apartmentImages?.length == 1;
}
