import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vivas/res/app_asset_paths.dart';

import '../bloc/add_remove_wish_bloc.dart';

class WishIconButton extends StatefulWidget {
  final String uuid;
  final bool isWish;
  final double? height;
  final double? width;
  final double? iconSize;

  const WishIconButton({
    super.key,
    required this.uuid,
    required this.isWish,
    this.height,
    this.width,
    this.iconSize,
  });

  @override
  State<WishIconButton> createState() => _WishIconButtonState();
}

class _WishIconButtonState extends State<WishIconButton> {
  late bool isWish;

  @override
  void initState() {
    isWish = widget.isWish;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: InkWell(
        radius: 100.r,
        onTap: _onChangeBookmark,
        child: BlocConsumer<AddRemoveWishBloc, AddRemoveWishState>(
          buildWhen: (previous, current) => current.id == widget.uuid,
          listenWhen: (previous, current) => current.id == widget.uuid,
          listener: (context, state) {
            if (state is WishAddedState) {
              isWish = true;
            } else if (state is BookmarkRemoveState) {
              isWish = false;
            }
          },
          builder: (context, state) {
            if (state is AddRemoveWishLoadingState) {
              return const RepaintBoundary(child: CircularProgressIndicator());
            }
            return CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20.r,
              child: Padding(
                padding: EdgeInsets.all(5.h),
                child: SvgPicture.asset(
                  width: 20.w,
                  height: 20.h,
                  isWish
                      ? AppAssetPaths.heartRedIcon
                      : AppAssetPaths.heartBlankIcon,
                ),
              ),
            );

            // Icon(
            //   isWish ? Icons.bookmark_outlined : Icons.bookmark_border,
            //   size: widget.iconSize,
            // );
          },
        ),
      ),
    );
  }

  void _onChangeBookmark() {
    context.read<AddRemoveWishBloc>().add(
          ToggleWishEvent(
            id: widget.uuid,
            isAddedToBookmarks: isWish,
          ),
        );
  }
}
