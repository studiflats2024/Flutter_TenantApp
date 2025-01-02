import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableWidget extends StatelessWidget {
  final Widget collapsedWidget;
  final Widget expandedWidget;
  const ExpandableWidget(
      {super.key, required this.collapsedWidget, required this.expandedWidget});

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Expandable(
        collapsed: _buildCollapsed(),
        expanded: _buildExpanded(),
      ),
    ));
  }

  Widget _buildCollapsed() {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => _toggleExpanded(context),
        child: collapsedWidget,
      );
    });
  }

  Widget _buildExpanded() {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => _toggleExpanded(context),
        child: expandedWidget,
      );
    });
  }

  void _toggleExpanded(BuildContext context) {
    var controller = ExpandableController.of(context, required: true)!;
    controller.toggle();
  }
}
