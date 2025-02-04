import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vivas/apis/models/booking/selfie_request_model.dart';
import 'package:vivas/feature/profile/edit_personal_information/bloc/edit_profile_bloc.dart';
import 'package:vivas/feature/profile/profile_screen/bloc/profile_repository.dart';
import 'package:vivas/utils/feedback/feedback_message.dart';
import 'package:image/image.dart' as img;

import 'bookings_repository.dart';

part 'selfie_event.dart';

part 'selfie_state.dart';

class SelfieBloc extends Bloc<SelfieEvent, SelfieState> {
  final BaseBookingsRepository baseBookingsRepository;
  final ProfileRepository? profileRepository;

  SelfieBloc(this.baseBookingsRepository, {this.profileRepository})
      : super(SelfieInitial()) {
    on<SelfieAddImageEvent>(addImage);
    on<SelfieAddVerifyImageEvent>(addImageVerified);
    on<SelfieSendingImageEvent>(selfieSendImage);
  }

  addImage(SelfieAddImageEvent selfieAddImageEvent, Emitter<SelfieState> emit) {
    emit(SelfieAddImage(selfieAddImageEvent.imageP));
  }

  addImageVerified(SelfieAddVerifyImageEvent selfieAddImageEvent,
      Emitter<SelfieState> emit) async {
    if (await checkOnImageHavePerson(selfieAddImageEvent.imageP!)) {
      emit(SelfieAddVerifiedImage(selfieAddImageEvent.imageP));
    } else {
      showFeedbackMessage("Your Image Not Accepted, Take Other Image");
      emit(SelfieAddVerifiedImage(null));
    }
  }

  Future<bool> checkOnImageHavePerson(XFile image) async {
    try {
      List<Face> faces = [];
      FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(
        FaceDetectorOptions(
          enableContours: false,
          enableClassification: false,
        ),
      );
      if(Platform.isIOS ){

        await processSelfieImage(File(image.path), true);

        final inputImage =  InputImage.fromFile(File(image.path));

        faces = await faceDetector.processImage(inputImage);

      }else{

        final inputImage =  InputImage.fromFile(File(image.path));

        faces = await faceDetector.processImage(inputImage);
      }

      if (faces.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("crached On faceDetector $e");
      return false;
    }
  }

  Future<bool> isFrontCameraImage(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);

    if (decodedImage == null) return false; // Cannot determine

    // Check EXIF orientation (Front camera images are usually mirrored)
    final exif = decodedImage.exif;

    // EXIF Orientation: 1 = Normal (Back Camera), 2 = Mirrored (Front Camera)
    return exif?['Orientation'] == 2;
  }

  Future<File> processSelfieImage(File imageFile, bool isFrontCamera) async {
    if (!isFrontCamera) return imageFile; // No need to flip back camera images

    final image = img.decodeImage(await imageFile.readAsBytes())!;
    final flippedImage = img.flipHorizontal(image); // Flip horizontally

    final correctedFile = File(imageFile.path)
      ..writeAsBytesSync(img.encodeJpg(flippedImage));

    return correctedFile;
  }

  selfieSendImage(SelfieSendingImageEvent selfieSendingImageEvent,
      Emitter<SelfieState> emit) async {
    emit(SelfieSendingLoading());
    emit(await baseBookingsRepository
        .selfieSendImage(selfieSendingImageEvent.selfieRequestModel));
  }

  selfieVerifiedSendImage(SelfieSendingImageEvent selfieSendingImageEvent,
      Emitter<SelfieState> emit) async {
    emit(SelfieSendingLoading());
    var state = await profileRepository?.updateProfileImage(
        selfieSendingImageEvent.selfieRequestModel.imagePath);
    if (state is ProfileImageSuccessfullyUpdatedState) {
      emit(SelfieSendingSuccess());
    } else if (state is EditProfileErrorState) {
      emit(SelfieSendingException(state.errorMassage, state.isLocalizationKey));
    }
  }
}
