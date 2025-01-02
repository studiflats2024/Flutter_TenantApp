import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class SelectPercentageWidget extends BaseStatefulWidget {
  final void Function(int) changeDepositCallBack;
  final int selectedPercentageDeposit;
  const SelectPercentageWidget(
      this.changeDepositCallBack, this.selectedPercentageDeposit,
      {super.key});

  @override
  BaseState<SelectPercentageWidget> baseCreateState() =>
      _SelectPercentageWidgetState();
}

class _SelectPercentageWidgetState extends BaseState<SelectPercentageWidget> {
  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 15,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          _itemWidget(25, translate(LocalizationKeys.pay25Now)!),
          SizedBox(height: 12.h),
          _itemWidget(50, translate(LocalizationKeys.pay50Now)!),
          SizedBox(height: 12.h),
          _itemWidget(100, translate(LocalizationKeys.pay100Now)!),
        ],
      ),
    );
  }

  Widget _itemWidget(int value, String title) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _changeSelected(value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1,
                color: isSelected(value)
                    ? const Color(0xFF1151B4)
                    : const Color(0xFFCFDCF0)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isSelected(value)
                ? const Icon(Icons.radio_button_checked_outlined)
                : const Icon(
                    Icons.radio_button_off_outlined,
                    color: Color(0xFFCFD4DC),
                  ),
            const SizedBox(width: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF606060),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isSelected(int value) => value == widget.selectedPercentageDeposit;

  void _changeSelected(int value) {
    widget.changeDepositCallBack(value);
  }
}
