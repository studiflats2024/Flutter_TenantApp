import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:vivas/res/app_colors.dart';

class PagingSwipeToRefreshGridListWidget extends StatelessWidget {
  final VoidCallback reachedEndOfScroll;
  final Widget Function(int index) itemWidget;
  final Function swipedToRefresh;
  final int listLength;
  final bool showPagingLoader;
  final double? spacing;

  final EdgeInsetsGeometry? listPadding;
  final Widget? bottomOfList;

  const PagingSwipeToRefreshGridListWidget({
    Key? key,
    required this.reachedEndOfScroll,
    required this.itemWidget,
    required this.swipedToRefresh,
    required this.listLength,
    required this.showPagingLoader,
    this.spacing,
    this.listPadding,
    this.bottomOfList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (isReachEndOfScrolling(scrollInfo)) {
                  reachedEndOfScroll();
                }
                return false;
              },
              child: listWidget()),
        ),
        pagingLoadingWidget(showPagingLoader),
      ],
    );
  }

  bool isReachEndOfScrolling(ScrollNotification scrollInfo) {
    return (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent);
  }

  Widget listWidget() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Align(
          alignment: listLength == 1
              ? AlignmentDirectional.center
              : Alignment.center,
          child: Padding(
            padding: listPadding ?? EdgeInsets.only(top: 1.h, bottom: 20.h),
            child: ResponsiveGridList(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                desiredItemWidth: 344.w,
                minSpacing: spacing ?? 10,
                scroll: false,
                children: [
                  ...List.generate(listLength, _buildItemWidget),
                  if (bottomOfList != null) bottomOfList!
                ]),
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget(int index) {
    return itemWidget(index);
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1)).then((_) {});
    swipedToRefresh();
  }

  Widget pagingLoadingWidget(bool isLoading) {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      padding: const EdgeInsets.all(10.0),
      height: isLoading ? 55.0 : 0,
      color: AppColors.paginationLoadingBackground,
      duration: const Duration(milliseconds: 300),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
