import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/apis/models/my_problems/problem_details_api_model.dart';
import 'package:vivas/feature/problem/widgets/problem_status_widget.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class ProblemDetailsWidget extends BaseStatelessWidget {
  final ProblemDetailsApiModel problemDetailsApiModel;
  final void Function() editClickedCallBack;

  ProblemDetailsWidget(
      {super.key,
      required this.problemDetailsApiModel,
      required this.editClickedCallBack});

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleStatus(),
            const SizedBox(height: 20),
            _itemWidget(translate(LocalizationKeys.nameOnTheRingBell)!,
                problemDetailsApiModel.nameRigel),
            const SizedBox(height: 20),
            _itemWidget(translate(LocalizationKeys.phoneNumber)!,
                problemDetailsApiModel.phoneNo1),
            const SizedBox(height: 20),
            _itemWidget(translate(LocalizationKeys.alternativePhoneNumber)!,
                problemDetailsApiModel.phoneNo2),
            const SizedBox(height: 20),
            _imagesWidget(),
            const SizedBox(height: 20),
            _descriptionWidget(),
            const SizedBox(height: 20),
            _dateListWidget(),
            const SizedBox(height: 20),
            if (!problemDetailsApiModel.newDate!.contains("0001-01-01")) ...[
              Container(
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFCFD4DC),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _dateSolveListWidget(),
            ],
            const SizedBox(height: 20),
            if (!problemDetailsApiModel.issueSolve.isNullOrEmpty) ...[
              Container(
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFFCFD4DC),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _resultWidget(),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _imagesWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.imagesOfProblem)!,
          style: const TextStyle(
            color: Color(0xFF667084),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: GalleryImage(
            key: UniqueKey(),
            imageUrls: problemDetailsApiModel.issueImages,
            childAspectRatio: 1,
            numOfShowImages: problemDetailsApiModel.issueImages.length > 3
                ? 3
                : problemDetailsApiModel.issueImages.length,
          ),
        ),
      ],
    );
  }

  Widget _titleStatus() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 15,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                problemDetailsApiModel.aptName,
                style: const TextStyle(
                  color: Color(0xFF1B1B2F),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ProblemStatusWidget(
              statusString: problemDetailsApiModel.statusString,
              statusKey: problemDetailsApiModel.statusKey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemWidget(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF667084),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _descriptionWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              translate(LocalizationKeys.problemDescription)!,
              style: const TextStyle(
                color: Color(0xFF667084),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (problemDetailsApiModel.statusString == "Pending")
              GestureDetector(
                onTap: editClickedCallBack,
                child: Text(
                  translate(LocalizationKeys.edit)!,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.transparent,
                      shadows: [
                        Shadow(offset: Offset(0, -2), color: Colors.black)
                      ],
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black,
                      decorationThickness: 2),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          problemDetailsApiModel.issueDesc,
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _dateListWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.listOfAvailableAppointments)!,
          style: const TextStyle(
            color: Color(0xFF667084),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        ...problemDetailsApiModel.issueDates
            .map((e) => _dateNumberWidget(e.date, e.time))
            .toList()
      ],
    );
  }

  Widget _dateSolveListWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.solveAppointment)!,
          style: const TextStyle(
            color: Color(0xFF667084),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        _dateNumberSolveWidget(
            problemDetailsApiModel.newDate!, problemDetailsApiModel.newTime!),
      ],
    );
  }

  Widget _dateNumberWidget(String date, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(LocalizationKeys.date)!,
                  style: const TextStyle(
                    color: Color(0xFF667084),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF344053),
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 1,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 40,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(LocalizationKeys.time)!,
                  style: const TextStyle(
                    color: Color(0xFF667084),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF344053),
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateNumberSolveWidget(String date, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(LocalizationKeys.date)!,
                  style: const TextStyle(
                    color: Color(0xFF667084),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF344053),
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 1,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 40,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate(LocalizationKeys.time)!,
                  style: const TextStyle(
                    color: Color(0xFF667084),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Color(0xFF344053),
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.theCompanySReportOnTheProblem)!,
          style: const TextStyle(
            color: Color(0xFF344053),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          problemDetailsApiModel.issueSolve!,
          style: const TextStyle(
            color: Color(0xFF667084),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
