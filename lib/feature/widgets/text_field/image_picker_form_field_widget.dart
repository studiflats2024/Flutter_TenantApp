import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivas/_core/widgets/base_stateless_widget.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/feature/widgets/picker_option_widget.dart';
import 'package:vivas/res/app_asset_paths.dart';
import 'package:vivas/utils/cached_network_image/app_cached_network_image.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';
import 'package:vivas/utils/extensions/extension_string.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';
import 'package:vivas/utils/validations/validator.dart';

class ImagePickerFormFieldWidget extends FormField<String> {
  /// Creates a [Image Picker Widget] widget that is a [FormField], wrapped in an
  /// [InputDecorator].
  ///
  /// For a description of the `onSaved`, `validator`, or `autovalidateMode`
  /// parameters, see [FormField].
  ///
  final ValueChanged<String?>? onChanged;

  ImagePickerFormFieldWidget({
    Key? key,
    String? value,
    AutovalidateMode? autovalidateMode,
    FocusNode? focusNode,
    bool enabled = true,
    bool canEdit = true,
    double radius = 10,
    String? hintText,
    bool? autoFocus = false,
    FormFieldSetter<String>? onSaved,
    this.onChanged,
    FormFieldValidator<String>? validator,
  })  : assert(autoFocus != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: value,
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<String> field) {
            final _SelectableFormFieldState state =
                field as _SelectableFormFieldState;
            const InputDecoration decorationArg = InputDecoration();
            final InputDecoration effectiveDecoration =
                decorationArg.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );

            return Focus(
              child: Builder(builder: (BuildContext context) {
                return InputDecorator(
                  decoration: effectiveDecoration.copyWith(
                    errorText: field.errorText,
                    enabled: enabled,
                    border: InputBorder.none,
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(radius),
                        borderSide: BorderSide(
                          color: Theme.of(field.context).colorScheme.error,
                        )),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  isEmpty: state.value == null,
                  isFocused: Focus.of(context).hasFocus,
                  child: _ImagePickerWidget(
                    radius: radius,
                    canEdit: canEdit,
                    initialValue: state.value,
                    onSaved: onSaved,
                    onChange: state.didChange,
                    hintText: hintText,
                  ),
                );
              }),
            );
          },
        );

  @override
  FormFieldState<String> createState() => _SelectableFormFieldState();
}

class _SelectableFormFieldState extends FormFieldState<String> {
  @override
  void didChange(String? value) {
    super.didChange(value);
    final ImagePickerFormFieldWidget imagePickerFormFieldWidget = widget;
    if (imagePickerFormFieldWidget.onChanged != null) {
      imagePickerFormFieldWidget.onChanged!(value);
    }
  }

  @override
  void didUpdateWidget(ImagePickerFormFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }

  @override
  ImagePickerFormFieldWidget get widget =>
      super.widget as ImagePickerFormFieldWidget;
}

// ignore: must_be_immutable
class _ImagePickerWidget extends BaseStatelessWidget {
  final void Function(String?)? onChange;
  final void Function(String?)? onSaved;
  final String? initialValue;
  final double radius;
  final bool canEdit;
  String? selectedImage;
  String? hintText;

  _ImagePickerWidget({
    Key? key,
    this.onChange,
    this.onSaved,
    this.initialValue,
    this.hintText,
    required this.radius,
    required this.canEdit,
  })  : selectedImage = initialValue,
        super(key: key);
  final ImagePicker _picker = ImagePicker();
  String fileName = "";
  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: ShapeDecoration(
        color: const Color(0x0F1151B4),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      child: selectedImage != null
          ? _showImageWidget(context)
          : _pickImageWidget(context),
    );
  }

  Widget _pickImageWidget(BuildContext context) {
    return InkWell(
      onTap: () => _pickAttachment(context),
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssetPaths.addImage),
            const SizedBox(height: 16),
            Text(
              hintText ?? translate(LocalizationKeys.clickToUploadImage)!,
              style: const TextStyle(
                color: Color(0xFF1D2838),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showImageWidget(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        InkWell(
            onTap: () => _pickAttachment(context),
            borderRadius: BorderRadius.circular(radius),
            child: _imagePickedWidget()),
        if (canEdit)
          PositionedDirectional(
            end: 5.w,
            top: 5.h,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _changeImage(null);
              },
            ),
          )
      ],
    );
  }

  Widget _imagePickedWidget() {
    if (selectedImage.isNullOrEmpty) {
      return const EmptyWidget();
    } else if (selectedImage!.split(".").last.toLowerCase() == "pdf") {
      return Text(
        selectedImage!.split("/").last,
        style: TextStyle(
            fontSize: 18.sp,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold),
      );
    } else if (Validator.isUrl(selectedImage!)) {
      return AppCachedNetworkImage(imageUrl: selectedImage!);
    } else {
      return Image.file(File(selectedImage ?? ""));
    }
  }

  void _changeImage(String? choose) {
    selectedImage = choose;
    if (onChange != null) {
      onChange!(selectedImage);
    }
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

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _changeImage(pickedFile.path);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      _changeImage(pickedFile.path);
    }
  }

  final List<String> allowedExtensions = ["pdf"];

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
        _changeImage(result.files.single.path);
      }
    }
  }
}
