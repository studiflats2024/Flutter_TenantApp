import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/file_api_mangers.dart';
import 'package:vivas/apis/models/UploadPassportRequestModel/passport_request_model.dart';
import 'package:vivas/apis/models/apartment_requests/apartment_requests/guests_request_model.dart';
import 'package:vivas/apis/models/upload_file/send_upload_file_model.dart';
import 'package:vivas/feature/widgets/app_buttons/app_buttons.dart';
import 'package:vivas/feature/widgets/text_field/app_text_form_filed_widget.dart';
import 'package:vivas/feature/widgets/text_field/image_picker_form_field_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/validations/validator.dart';

// ignore: must_be_immutable
class EditTenantWidgetV2 extends BaseStatefulWidget {
  final PassportRequestModel guestsRequestModel;
  void Function(PassportRequestModel guestsRequestModel) saveCallBack;

  EditTenantWidgetV2({
    required this.saveCallBack,
    required this.guestsRequestModel,
    super.key,
  });

  @override
  BaseState<EditTenantWidgetV2> baseCreateState() => _EditTenantWidgetState();
}

class _EditTenantWidgetState extends BaseState<EditTenantWidgetV2> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool uploading = false;
  double uploadProgress = 0;
  String? uploadedImagePath;

  @override
  void initState() {
    uploadedImagePath = widget.guestsRequestModel.passportImg;
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          AppTextFormField(
              initialValue: widget.guestsRequestModel.guestName,
              title: translate(LocalizationKeys.tenantName)!,
              hintText: translate(LocalizationKeys.enterTenant)!,
              validator: textValidator,
              onSaved: (value) {
                widget.guestsRequestModel.guestName = value!;
              }),
          SizedBox(height: 24.h),
          Text(
            translate(LocalizationKeys.tenantPassport)!.concatenateAsterisk,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.appFormFieldTitle,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          uploading
              ? uploadingWidget()
              : ImagePickerFormFieldWidget(
                  hintText: translate(LocalizationKeys.clickToUploadPassport),
                  value: uploadedImagePath ??
                      widget.guestsRequestModel.passportImg,
                  onChanged: (val) => _selectImage(val, context),
                  onSaved: (path) {
                    widget.guestsRequestModel.passportImg = uploadedImagePath;
                  },
                  validator: textValidator,
                ),
          const SizedBox(height: 24),
          Row(
            children: [
              AppElevatedButton.withTitle(
                color: const Color(0xFFEFEFEF),
                textColor: const Color(0xFF0F0F0F),
                title: translate(LocalizationKeys.cancel)!,
                onPressed: () => _cancelClicked(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              const Spacer(),
              AppElevatedButton.withTitle(
                  onPressed: uploading ? null : _savedClicked,
                  color: uploading ? const Color(0xFFEFEFEF) : AppColors.appMainButton,
                  title: translate(LocalizationKeys.save)!),
            ],
          ),
        ],
      ),
    );
  }

  Widget uploadingWidget() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: ShapeDecoration(
        color: const Color(0x0F1151B4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator(value: uploadProgress, )),
          const SizedBox(height: 16),
          Center(child:  Text(
            "${(uploadProgress * 100).toStringAsFixed(2)} %",
            style: const TextStyle(
              color: Color(0xFF1D2838),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),),
          const SizedBox(height: 16),
          Text(
            translate(LocalizationKeys.uploading)!,
            style: const TextStyle(
              color: Color(0xFF1D2838),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _selectImage(String? imagePath, BuildContext context) {
    if (imagePath != null) {
      uploadImage(imagePath, context);
    }
  }

  String? textValidator(String? value) {
    ValidationState validationState = Validator.validateText(value);
    switch (validationState) {
      case ValidationState.empty:
      case ValidationState.formatting:
        return translate(LocalizationKeys.required);
      case ValidationState.valid:
        return null;
    }
  }

  void _cancelClicked(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _savedClicked() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      widget.saveCallBack(widget.guestsRequestModel);
      Navigator.of(context).pop();
    } else {
      autovalidateMode = AutovalidateMode.always;
    }
  }

  Future<void> uploadImage(String imagePath, BuildContext context) async {
    setState(() {
      uploading = true;
    });
    await UploadFileApiManager(GetIt.I<DioApiManager>(), context).uploadFile(
      SendUploadFileModel(imagePath: imagePath),
      (uploadFileResponse) {
        uploadedImagePath = uploadFileResponse.filePath;
        setState(() {
          uploading = false;
        });
      },
      (errorApiModel) {
        showFeedbackMessage(errorApiModel.isMessageLocalizationKey
            ? translate(errorApiModel.message)!
            : errorApiModel.message);
        setState(() {
          uploading = false;
        });
      },
      onSendProgress: (count, total) {
        setState(() {
          uploadProgress = count / total;
        });
      },
    );
  }
}
