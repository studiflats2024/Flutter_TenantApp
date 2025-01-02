import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivas/_core/widgets/base_stateful_widget.dart';
import 'package:vivas/feature/auth/helper/auth_validate.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/picker_option_widget.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

// ignore: must_be_immutable
class SendChatWidget extends BaseStatefulWidget {
  final void Function(String) addAttachmentMessage;
  final void Function(String) addTextMessage;
  final bool enableSend;
  final TextEditingController textEditingController;

  const SendChatWidget({
    required this.textEditingController,
    required this.addAttachmentMessage,
    required this.addTextMessage,
    required this.enableSend,
    super.key,
  });

  @override
  BaseState<SendChatWidget> baseCreateState() => _SendChatWidgetState();
}

class _SendChatWidgetState extends BaseState<SendChatWidget> with AuthValidate {
  @override
  Widget baseBuild(BuildContext context) {
    return Card(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () => _pickAttachment(context),
                  child: const Icon(Icons.attach_file)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: TextFormField(
                    controller: widget.textEditingController,
                    enabled: true,
                    onChanged: _changeText,
                    decoration: InputDecoration(
                      fillColor: const Color(0xffF3F6F6),
                      filled: true,
                      isDense: true,
                      hintText:
                          translate(LocalizationKeys.pleaseWriteYourMessage),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.enableSend && canSend ? _sendClicked : null,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAttachment(BuildContext context) async {
    AppBottomSheet.openBaseBottomSheet(
        context: context,
        child: PickerOptionWidget(
          cameraClickedCallBack: _pickImageFromCamera,
          documentClickedCallBack: _pickFile,
          galleryClickedCallBack: _pickImageFromGallery,
        ));
  }

  Future<void> _sendClicked() async {
    if (!widget.textEditingController.text.isNullOrEmpty) {
      widget.addTextMessage(widget.textEditingController.text);
    }
  }

  bool canSend = false;

  void _changeText(String value) {
    setState(() {
      canSend = !widget.textEditingController.text.isNullOrEmpty;
    });
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      changeImage(pickedFile.path);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      changeImage(pickedFile.path);
    }
  }

  final ImagePicker _picker = ImagePicker();
  String fileName = "";
  final List<String> allowedExtensions = ["pdf"];
  String? selectedImage;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile platformFile = result.files.single;
      fileName = platformFile.name;
      if (!allowedExtensions.contains(platformFile.extension?.toLowerCase())) {
        showFeedbackMessage(
            translate(LocalizationKeys.attachmentsMustBeFilledPdfFileFormat)!);
      } else if (platformFile.size / 1000 > 10000) {
        showFeedbackMessage(
            translate(LocalizationKeys.theSizeOfTheFileShouldBeLessThan10Mg)!);
      } else {
        changeImage(result.files.single.path);
      }
    }
  }

  void changeImage(String? choose) {
    selectedImage = choose;
    widget.addAttachmentMessage(selectedImage!);
  }
}
