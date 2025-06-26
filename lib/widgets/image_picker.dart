import 'dart:io';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/widgets/custom_bottomsheet_image_modal.dart';
import 'package:flutter/material.dart';

class ImagePickerWidget extends StatefulWidget {
  final String userImg;
  final File? initialImage;
  final bool isEditable;
  final double radius;
  const ImagePickerWidget({
    super.key,
    required this.userImg,
    this.initialImage,
    this.radius = 60,
      this.isEditable = false
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;

  @override
  void initState() {
    _selectedImage = widget.initialImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
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
        widget.isEditable
            ? Positioned(
          bottom: 0,
          right: -5,
          child: CustomBottomsheetImageModal(
            isProfileChange: true,
                  isEditable: widget.isEditable,
            icon: Card(
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
            : SizedBox.shrink()
      ],
    );
  }
}
