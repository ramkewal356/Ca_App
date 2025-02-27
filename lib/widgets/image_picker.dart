import 'dart:io';

import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final String userImg;
  final File? initialImage;
  final ValueChanged<MultipartFile?> onImagePicked;
  final double radius;
  const ImagePickerWidget(
      {super.key,
      required this.userImg,
      this.initialImage,
      this.radius = 60,
      required this.onImagePicked});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    _selectedImage = widget.initialImage;
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Step 1: Pick an image from the selected source
      final pickedFile = await _picker.pickImage(
        source: source,
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
          // Step 3: Compress the image
          var compressedFile = await _compressImage(File(croppedFile.path));

          setState(() {
            _selectedImage = compressedFile;
          });
          var profilePic = await MultipartFile.fromFile(compressedFile.path,
              filename: "profile.jpg");
          widget.onImagePicked(profilePic);
        }
      }
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _selectedImage != null
            ? CircleAvatar(
                radius: widget.radius + 1,
                backgroundColor: ColorConstants.buttonColor,
                child: CircleAvatar(
                  backgroundImage: FileImage(_selectedImage!),
                  radius: widget.radius,
                ),
              )
            : widget.userImg.toString().isNotEmpty
                ? CircleAvatar(
                    radius: widget.radius + 1,
                    backgroundColor: ColorConstants.buttonColor,
                    child: CircleAvatar(
                      backgroundImage:
                          Image.network(widget.userImg.toString()).image,
                      radius: widget.radius,
                    ),
                  )
                : CircleAvatar(
                    radius: widget.radius,
                    child: Icon(Icons.person, size: 60),
                  ),
        Positioned(
          bottom: 5,
          right: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: _showImageSourceSelection,
            child: const Card(
              elevation: 0,
              shape: CircleBorder(),
              color: ColorConstants.buttonColor,
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: ColorConstants.white,
                  )),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _showImageSourceSelection() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
