import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/file_api_mangers.dart';
import 'package:vivas/apis/models/upload_file/send_upload_file_model.dart';
import 'package:vivas/feature/widgets/text_field/image_picker_form_field_widget.dart';
import 'package:vivas/res/app_colors.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class SelectImagesWidget extends BaseStatefulWidget {
  final void Function(List<String>) onChangeCallBack;

  const SelectImagesWidget(this.onChangeCallBack, {super.key});

  @override
  BaseState<SelectImagesWidget> baseCreateState() => _SelectImagesWidgetState();
}

class _SelectImagesWidgetState extends BaseState<SelectImagesWidget> {
  bool uploading = false;
  double uploadProgress = 0;
  List<String> uploadedImagesPath = [];

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LocalizationKeys.uploadImagesOfProblem)!
              .concatenateAsterisk,
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
                onChanged:(val) => _selectImage(val, context),
                validator: textValidator,
              ),
        const SizedBox(height: 10),
        if (uploadedImagesPath.isNotEmpty)
          GridView.builder(
              primary: false,
              itemCount: uploadedImagesPath.length,
              padding: const EdgeInsets.only(),
              semanticChildCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  child: _buildLoadImgItem(index),
                );
              }),

        // SizedBox(
        //   height: 140,
        //   child: GalleryImage(
        //     key: Key(uploadedImagesPath.length.toString()),
        //     imageUrls: uploadedImagesPath,
        //     childAspectRatio: 1,
        //     numOfShowImages:
        //         uploadedImagesPath.length > 3 ? 3 : uploadedImagesPath.length,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildLoadImgItem(int index) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: <Widget>[
        Center(
          child: AppCachedNetworkImage(
            imageUrl: uploadedImagesPath[index],
          ),
        ),
        InkWell(
          onTap: () {
            uploadedImagesPath.removeAt(index);
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.colorPrimary, width: 2),
                borderRadius: BorderRadius.circular(90)),
            child: const Icon(
              Icons.close,
            ),
          ),
        ),
      ],
    );
  }

  String? textValidator(String? value) {
    if (uploadedImagesPath.isEmpty) {
      return translate(LocalizationKeys.required);
    } else {
      return null;
    }
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
          Center(child: CircularProgressIndicator(value: uploadProgress)),
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

  void _selectImage(String? imagePath , BuildContext context) {
    if (imagePath != null) {
      uploadImage(imagePath , context);
    }
  }

  Future<void> uploadImage(String imagePath, BuildContext context) async {
    setState(() {
      uploading = true;
    });
    await UploadFileApiManager(GetIt.I<DioApiManager>(), context).uploadFile(
      SendUploadFileModel(imagePath: imagePath),
      (uploadFileResponse) {
        uploadedImagesPath.add(uploadFileResponse.filePath);
        widget.onChangeCallBack(uploadedImagesPath);
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
