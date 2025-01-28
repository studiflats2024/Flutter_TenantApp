import 'package:flutter/material.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class ReadMoreText extends BaseStatefulWidget {
  final String text;
  final int maxLength;
  final int maxLines;
  final bool useSeeMore;
  final TextStyle? style;

  const ReadMoreText({
    super.key,
    required this.text,
    this.style,
    this.maxLength = 150,
    this.maxLines = 3,
    this.useSeeMore = false,
  });

  @override
  BaseState<ReadMoreText> baseCreateState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends BaseState<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: Text(
            widget.text.substring(
                0,
                widget.maxLength < widget.text.length
                    ? widget.maxLength
                    : widget.text.length),
            style: widget.style,
            textAlign: TextAlign.start,
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            widget.text,
            style: widget.style,
            textAlign: TextAlign.start,
          ),
        ),
        if (widget.text.length > widget.maxLength)
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                isExpanded
                    ? translate(widget.useSeeMore
                        ? LocalizationKeys.seeLess
                        : LocalizationKeys.readLess)!
                    : "...${translate(
                        widget.useSeeMore
                            ? LocalizationKeys.seeMore
                            : LocalizationKeys.readMore,
                      )!}",
                style: const TextStyle(
                  color: Color(0xFF4C4DDC),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
