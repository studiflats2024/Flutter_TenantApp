import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class NewPersonWidget extends BaseStatefulWidget {
  void Function(int) changePersonNumberCallBack;
  final int? selected;
  final int? max;

  NewPersonWidget(
      {required this.changePersonNumberCallBack,
      super.key,
      this.selected,
      this.max,});

  @override
  BaseState<NewPersonWidget> baseCreateState() => _PersonWidgetState();
}

class _PersonWidgetState extends BaseState<NewPersonWidget> {
  int _counter = 0;

  @override
  void initState() {
    _counter = widget.selected ?? 0;

    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.5, color: Color(0xFFD0D0DD)),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(AppAssetPaths.navProfileIcon,
                  colorFilter: const ColorFilter.mode(
                      AppColors.suffixIcon, BlendMode.srcIn)),
              const SizedBox(width: 10),
              Text(
                translate(LocalizationKeys.guest)!,
                style: const TextStyle(
                  color: AppColors.formFieldHintText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _counterWidget(),
              SizedBox(width: 5.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterWidget() {
    return Row(
      children: [
        GestureDetector(
          onTap: _decrementClicked,
          child: Container(
            width: 24,
            height: 24,
            decoration: const ShapeDecoration(
              shape: OvalBorder(
                side: BorderSide(width: 0.25, color: Color(0xFF4C77AB)),
              ),
            ),
            child: const Icon(
              Icons.remove,
              size: 20,
              color: Color(0xFF1B1B2F),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          _counter.toString(),
          style: const TextStyle(
            color: Color(0xFF1B1B2F),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 16.w),
        GestureDetector(
          onTap: _incrementClicked,
          child: Container(
            width: 24,
            height: 24,
            decoration: const ShapeDecoration(
              shape: OvalBorder(
                side: BorderSide(width: 0.5, color: Color(0xFF4C77AB)),
              ),
            ),
            child: const Icon(
              Icons.add,
              size: 20,
              color: Color(0xFF1B1B2F),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleExpanded(BuildContext context) {
    var controller = ExpandableController.of(context, required: true)!;
    controller.toggle();
  }

  void _incrementClicked() {
    if (widget.max != null ) {
      if (_counter < widget.max!) {
        setState(() {
          _counter++;
          widget.changePersonNumberCallBack(_counter);
        });
      }
    } else {
      if (_counter != 10) {
        setState(() {
          _counter++;
          widget.changePersonNumberCallBack(_counter);
        });
      }
    }
  }

  void _decrementClicked() {
    if (_counter != 0) {
      setState(() {
        _counter--;
        widget.changePersonNumberCallBack(_counter);
      });
    }
  }
}
