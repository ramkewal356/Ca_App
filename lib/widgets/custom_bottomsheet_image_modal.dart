import 'package:ca_app/blocs/image_picker/image_picker_bloc.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CustomBottomsheetImageModal extends StatefulWidget {
  final Widget icon;
  final bool isProfileChange;
  final bool isEditable;
  const CustomBottomsheetImageModal(
      {super.key,
      required this.icon,
      this.isProfileChange = false,
      this.isEditable = false});

  @override
  State<CustomBottomsheetImageModal> createState() =>
      _CustomBottomsheetImageModalState();
}

class _CustomBottomsheetImageModalState
    extends State<CustomBottomsheetImageModal> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEditable ? _showImageSourceSelection : () {},
      child: widget.icon,
    );
  }

  Future<void> _showImageSourceSelection() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Select Image',
                    style: AppTextStyle().cardLableText,
                  ),
                  Divider(),
                  Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text("Camera"),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<ImagePickerBloc>().add(PickImageEvent(
                              source: ImageSource.camera,
                              isProfileImgChange: widget.isProfileChange));
                          // _pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text("Gallery"),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<ImagePickerBloc>().add(PickImageEvent(
                              source: ImageSource.gallery,
                              isProfileImgChange: widget.isProfileChange));
                          // _pickImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
