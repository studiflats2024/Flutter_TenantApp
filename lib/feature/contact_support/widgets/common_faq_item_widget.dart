import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/general/faq_list_wrapper.dart';
import 'package:vivas/utils/expandable_widget/expandable_widget.dart';

// ignore: must_be_immutable
class CommonFaqItemWidget extends BaseStatelessWidget {
  final FAQModel faqModel;

  CommonFaqItemWidget({super.key, required this.faqModel});

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 18.h),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 15,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ExpandableWidget(
          expandedWidget: _faqWidget(showExpanded: true),
          collapsedWidget: _faqWidget(showExpanded: false),
        ),
      ),
    );
  }

  Widget _faqWidget({required bool showExpanded}) {
    return showExpanded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        faqModel.faqQuest,
                        style: const TextStyle(
                          color: Color(0xFF1D2838),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(
                      child: Icon(
                        Icons.keyboard_arrow_up,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                // height: 100,
                decoration: ShapeDecoration(
                  // color: AppColors.faqAnswerBoxBG.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    faqModel.faqAns,
                    style: const TextStyle(
                      color: Color(0xFF344053),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    softWrap: true,
                  ),
                ),
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        faqModel.faqQuest,
                        style: const TextStyle(
                          color: Color(0xFF1D2838),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
