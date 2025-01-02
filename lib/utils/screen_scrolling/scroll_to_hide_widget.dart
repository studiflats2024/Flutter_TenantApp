import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final Duration duration;
  final double height;

  const ScrollToHideWidget(
      {required this.child,
      required this.scrollController,
      this.duration = const Duration(milliseconds: 200),
      this.height = kBottomNavigationBarHeight,
      Key? key})
      : super(key: key);

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
  void initState() {
    widget.scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    final scrollDirection =
        widget.scrollController.position.userScrollDirection;
    if (scrollDirection == ScrollDirection.forward) {
      show();
    } else if (scrollDirection == ScrollDirection.reverse) {
      hide();
    }

    // we can depend on pixels
    /*if (widget.scrollController.position.pixels >= 200) {
      hide();
    } else {
      show();
    }*/
  }

  void show() {
    if (!isVisible) setState(() => isVisible = true);
  }

  void hide() {
    if (isVisible) setState(() => isVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: isVisible ? widget.height : 0,
        duration: widget.duration,
        child: Wrap(
          children: [widget.child],
        ));
  }
}

/// when makes the height of the widget is zero that will leads to error
/// so we need to wrap the child widget in a Wrap widget :)
///
/// we need to add the listener of the scroll controller to start the logic
/// of hide and show the widget ...

/// reference ...
/// https://www.youtube.com/watch?v=pr_Go9I19SA
