import 'package:flutter/material.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/complaint/details/details.api.model.dart';
import 'package:vivas/apis/models/complaint/details/reply.api.model.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/divider/divider_horizontal_widget.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class ComplaintsDetailsWidget extends BaseStatelessWidget {
  final ComplaintDetailsApiModel complaintDetailsApiModel;
  ComplaintsDetailsWidget({super.key, required this.complaintDetailsApiModel});

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleWidget(),
          Container(
            padding: const EdgeInsets.all(16),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              shadows: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _numberTypeWidget(),
                  const SizedBox(height: 15),
                  const DividerHorizontalWidget(),
                  const SizedBox(height: 15),
                  Text(
                    complaintDetailsApiModel.ticketDesc,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Color(0xFF676767),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...complaintDetailsApiModel.reply.map(_replyWidget).toList()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          translate(LocalizationKeys.complaints)!,
          style: const TextStyle(
            color: Color(0xFF505050),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          translate(LocalizationKeys.followUpYourComplaintsFromHere)!,
          style: const TextStyle(
            color: Color(0xFF676767),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _numberTypeWidget() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate(LocalizationKeys.ticketNumber)!,
                style: const TextStyle(
                  color: Color(0xFF6B6B6B),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                complaintDetailsApiModel.ticketCode,
                maxLines: 1,
                style: const TextStyle(
                    color: Color(0xFF313131),
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                translate(LocalizationKeys.typeOfComplaint)!,
                style: const TextStyle(
                  color: Color(0xFF6B6B6B),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                complaintDetailsApiModel.ticketType,
                maxLines: 1,
                style: const TextStyle(
                    color: Color(0xFF313131),
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _replyWidget(ReplyComplaintApiModel replyComplaintApiModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DividerHorizontalWidget(),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              replyComplaintApiModel.replyProvider,
              style: const TextStyle(
                color: Color(0xFF344053),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              replyComplaintApiModel.dateTime,
              style: const TextStyle(
                color: Color(0xFF6B6B6B),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        Text(
          replyComplaintApiModel.replyDesc,
          style: const TextStyle(
            color: Color(0xFF676767),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 15),
        if (!replyComplaintApiModel.replyAttach.isNullOrEmpty) ...[
          Center(
              child: AppCachedNetworkImage(
                  imageUrl: replyComplaintApiModel.replyAttach)),
          const SizedBox(height: 15),
        ],
      ],
    );
  }
}
