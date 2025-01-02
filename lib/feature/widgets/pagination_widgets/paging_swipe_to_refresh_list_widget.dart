import 'package:flutter/material.dart';
import 'package:vivas/res/app_colors.dart';

class PagingSwipeToRefreshListWidget extends StatelessWidget {
  final VoidCallback reachedEndOfScroll;
  final Widget Function(int index) itemWidget;
  final Function swipedToRefresh;
  final int listLength;
  final bool showPagingLoader;
  final double? childAspectRatio;
  final bool itemClickable;

  final Function(int index)? listItemClicked;
  final EdgeInsetsGeometry listPadding;
  final bool shrinkWrap;
  final Widget? widgetAboveList;

  const PagingSwipeToRefreshListWidget({
    Key? key,
    required this.reachedEndOfScroll,
    required this.itemWidget,
    required this.swipedToRefresh,
    required this.listLength,
    required this.showPagingLoader,
    required this.itemClickable,
    this.listItemClicked,
    this.widgetAboveList,
    this.listPadding = const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
    this.shrinkWrap = false,
    this.childAspectRatio,
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
        if (showPagingLoader) pagingLoadingWidget(showPagingLoader),
      ],
    );
  }

  bool isReachEndOfScrolling(ScrollNotification scrollInfo) {
    return (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent);
  }

  Widget listWidget() {
    return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            if (widgetAboveList != null) widgetAboveList!,
            ListView.builder(
              padding: listPadding,
              physics:
                  const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true, // You won't see infinite size error
              itemBuilder: (_, index) {
                return itemClickable
                    ? InkWell(
                        onTap: () {
                          listItemClicked!(index);
                        },
                        child: _buildItemWidget(index))
                    : _buildItemWidget(index);
              },
              itemCount: listLength,
            ),
          ],
        ));
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
