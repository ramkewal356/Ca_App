import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  // File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<PickImageEvent>(_onPickImage);
    // on<UpdateProfileImageEvent>(_onUpdateProfileImage);
  }
  Future<void> _onPickImage(
      PickImageEvent event, Emitter<ImagePickerState> emit) async {
    try {
      // Step 1: Pick an image from the selected source
      final pickedFile = await _picker.pickImage(
        source: event.source,
        imageQuality: 100, // Max quality
      );

      if (pickedFile != null) {
        // Step 2: Crop the image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          // cropStyle: CropStyle.rectangle,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop
          compressQuality: 100, // Max quality during cropping
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: ColorConstants.buttonColor,
              toolbarWidgetColor: Colors.white,
              hideBottomControls: true,
              lockAspectRatio: true,
            ),
            IOSUiSettings(title: 'Crop Image'),
          ],
        );

        if (croppedFile != null) {
          // Step 3: Compress the Image
          var compressedFile = await _compressImage(File(croppedFile.path));
          if (event.isProfileImgChange) {
            emit(ImagePickedSuccess(imageFile: compressedFile));
          } else {
            emit(ImagePickedSuccess(companyImage: compressedFile));
          }
          // Emit success state with the picked image
        } else {
          emit(ProfileImageError(message: "Image cropping canceled"));
        }
      } else {
        emit(ProfileImageError(message: "Image picking canceled"));
      }
    } catch (e) {
      emit(ProfileImageError(message: e.toString()));
      Utils.toastErrorMessage(e.toString());
    }
  }

  Future<File> _compressImage(File file) async {
    final dir = await Directory.systemTemp.createTemp();
    final targetPath = '${dir.path}/temp.jpg';
    final result1 = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 85, // Adjust quality as needed
      format: CompressFormat.jpeg,
    );
    final File result = File(result1?.path ?? '');

    return result; // Return the File
  }
}
