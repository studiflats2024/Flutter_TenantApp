import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class RoomsAndBedsWidget extends BaseStatefulWidget {
  final int? selectedRoom;
  final int? selectedBed;
  final void Function(int?) changeSelectRoomCallBack;
  final void Function(int?) changeSelectBedCallBack;
  const RoomsAndBedsWidget({
    required this.selectedRoom,
    required this.selectedBed,
    required this.changeSelectRoomCallBack,
    required this.changeSelectBedCallBack,
    super.key,
  });

  @override
  BaseState<RoomsAndBedsWidget> baseCreateState() => _RoomsAndBedsWidgetState();
}

class _RoomsAndBedsWidgetState extends BaseState<RoomsAndBedsWidget> {
  int? selectedRoom;
  int? selectedBed;
  @override
  void initState() {
    selectedRoom = widget.selectedRoom;
    selectedBed = widget.selectedBed;
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   translate(LocalizationKeys.roomsAndBeds)!,
        //   style: const TextStyle(
        //     color: Color(0xFF0F0F0F),
        //     fontSize: 16,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        // SizedBox(height: 16.h),
        // Text(
        //   translate(LocalizationKeys.rooms)!,
        //   style: const TextStyle(
        //     color: Color(0xFF0F0F0F),
        //     fontSize: 14,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
        // SizedBox(height: 12.h),
        // _roomNumbersWidget(),
        // SizedBox(height: 16.h),
        Text(
          translate(LocalizationKeys.beds)!,
          style: const TextStyle(
            color: Color(0xFF0F0F0F),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 12.h),
        _bedNumbersWidget(),
      ],
    );
  }

  List<int> bedNumber = List.generate(10, (index) => index + 1);
  List<int> roomNumber = List.generate(10, (index) => index + 1);
  Widget _roomNumbersWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _anyRoomItem(),
          ...roomNumber.map((e) => _roomNumberItemWidget(e)).toList(),
        ],
      ),
    );
  }

  Widget _bedNumbersWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _anyBedItem(),
          ...bedNumber.map((e) => _bedNumberItemWidget(e)).toList(),
        ],
      ),
    );
  }

  Widget _anyRoomItem() {
    return GestureDetector(
      onTap: () => _changeRoomSelect(null),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: ShapeDecoration(
          color: getRoomsBGColor(null),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFF1151B4)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Center(
          child: Text(
            translate(LocalizationKeys.any)!,
            style: TextStyle(
              color: getRoomsColor(null),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _anyBedItem() {
    return GestureDetector(
      onTap: () => _changeBedSelect(null),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: ShapeDecoration(
          color: getBedBGColor(null),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFF1151B4)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Center(
          child: Text(
            translate(LocalizationKeys.any)!,
            style: TextStyle(
              color: getBedColor(null),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _roomNumberItemWidget(int number) {
    return GestureDetector(
      onTap: () => _changeRoomSelect(number),
      child: Container(
        width: 32.w,
        height: 32.h,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: ShapeDecoration(
          color: getRoomsBGColor(number),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFF1151B4)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              color: getRoomsColor(number),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bedNumberItemWidget(int number) {
    return GestureDetector(
      onTap: () => _changeBedSelect(number),
      child: Container(
        width: 32.w,
        height: 32.h,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: ShapeDecoration(
          color: getBedBGColor(number),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0xFF1151B4)),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              color: getBedColor(number),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Color getBedColor(int? value) {
    if (value == selectedBed) {
      return Colors.white;
    } else {
      return const Color(0xFF0E4190);
    }
  }

  Color getBedBGColor(int? value) {
    if (value == selectedBed) {
      return const Color(0xFF0E4190);
    } else {
      return Colors.white;
    }
  }

  Color getRoomsColor(int? value) {
    if (value == selectedRoom) {
      return Colors.white;
    } else {
      return const Color(0xFF0E4190);
    }
  }

  Color getRoomsBGColor(int? value) {
    if (value == selectedRoom) {
      return const Color(0xFF0E4190);
    } else {
      return Colors.white;
    }
  }

  void _changeRoomSelect(int? roomNumber) {
    setState(() {
      selectedRoom = roomNumber;
      widget.changeSelectRoomCallBack(selectedRoom);
    });
  }

  void _changeBedSelect(int? bedNumber) {
    setState(() {
      selectedBed = bedNumber;
      widget.changeSelectBedCallBack(selectedBed);
    });
  }
}
