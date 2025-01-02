import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/feature/filter/model/apartment_type_enum.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class ApartmentTypeWidget extends BaseStatefulWidget {
  final List<ApartmentType> selected;
  final void Function(List<ApartmentType>) changeSelectCallBack;
  const ApartmentTypeWidget(
      {required this.selected, required this.changeSelectCallBack, super.key});

  @override
  BaseState<ApartmentTypeWidget> baseCreateState() =>
      _ApartmentTypeWidgetState();
}

class _ApartmentTypeWidgetState extends BaseState<ApartmentTypeWidget> {
  List<ApartmentType> selected = [];
  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.selectApartmentType)!,
          style: const TextStyle(
            color: Color(0xFF0F0F0F),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 90.h,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 160 / 35,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => _selectedApartment(ApartmentType.values[index]),
                child: Container(
                  height: 36,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: ShapeDecoration(
                    color: getBGColor(ApartmentType.values[index]),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 0.50, color: Color(0xFF1151B4)),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset((ApartmentType.values[index].imagePath),
                          colorFilter: ColorFilter.mode(
                              getColor(ApartmentType.values[index]),
                              BlendMode.srcIn)),
                      const SizedBox(width: 8),
                      Text(
                        translate(ApartmentType.values[index].localizedKey)!,
                        style: TextStyle(
                          color: getColor(ApartmentType.values[index]),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: ApartmentType.values.length,
          ),
        ),
      ],
    );
  }

  Color getColor(ApartmentType value) {
    if (isSelected(value)) {
      return Colors.white;
    } else {
      return const Color(0xFF0E4190);
    }
  }

  Color getBGColor(ApartmentType value) {
    if (isSelected(value)) {
      return const Color(0xFF0E4190);
    } else {
      return Colors.white;
    }
  }

  bool isSelected(ApartmentType value) => selected.contains(value);

  void _selectedApartment(ApartmentType value) {
    setState(() {
      if (isSelected(value)) {
        selected.remove(value);
      } else {
        selected.add(value);
      }
    });
  }
}
