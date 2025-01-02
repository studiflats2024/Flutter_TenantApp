import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class PersonWidget extends BaseStatefulWidget {
  void Function(int) changePersonNumberCallBack;
  final int? selected;

  PersonWidget(
      {required this.changePersonNumberCallBack, super.key, this.selected});

  @override
  BaseState<PersonWidget> baseCreateState() => _PersonWidgetState();
}

class _PersonWidgetState extends BaseState<PersonWidget> {
  int _counter = 0;
  bool _counterChanged = false;

  @override
  void initState() {
    _counter = widget.selected ?? 0;
    _counterChanged = _counter != 0;
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Expandable(
          collapsed: buildCollapsed(),
          expanded: buildExpanded(),
        ),
      ),
    ));
  }

  Widget buildCollapsed() {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () => _toggleExpanded(context),
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 15,
            right: 19,
            bottom: 20,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0xFFD0D0DD)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.who)!,
                style: const TextStyle(
                  color: Color(0xFF878787),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _counterChanged
                  ? Text(
                      "$_counter ${translate(LocalizationKeys.persons)}",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 103, 103, 103),
                        fontSize: 12.spMin,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      translate(LocalizationKeys.addPersons)!,
                      style: const TextStyle(
                        color: Color(0xFF0F0F0F),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildExpanded() {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFFD0D0DD)),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              child: GestureDetector(
                onTap: () => _toggleExpanded(context),
                child: Text(
                  translate(LocalizationKeys.whoIsComing)!,
                  style: const TextStyle(
                    color: Color(0xFF0F0F0F),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(LocalizationKeys.person)!,
                  style: const TextStyle(
                    color: Color(0xFF1F4068),
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
    });
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
                side: BorderSide(width: 0.25, color: Color(0xFF4C77AB)),
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
    if (_counter != 10) {
      setState(() {
        _counter++;
        _counterChanged = true;
        widget.changePersonNumberCallBack(_counter);
      });
    }
  }

  void _decrementClicked() {
    if (_counter != 0) {
      setState(() {
        _counter--;
        _counterChanged = true;
        widget.changePersonNumberCallBack(_counter);
      });
    }
  }
}
