import 'dart:io';

import 'package:ca_app/blocs/upload_document/upload_document_bloc.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/file_picker_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentScreen extends StatefulWidget {
  final bool serviceVisible;
  const DocumentScreen({super.key, required this.serviceVisible});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  String? serviceValue;
  String? subServiceValue = 'ramesh';
  final _formKey = GlobalKey<FormState>();
  List<PlatformFile> documentList = [];

  // Future<void> pickDocument() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: true,
  //     type: FileType.custom,
  //     allowedExtensions: [
  //       'pdf',
  //       'doc',
  //       'docx',
  //       'txt'
  //     ], // Add desired file types
  //   );
  //   // FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //     print('File Name: ${file.name}');
  //     print('File Path: ${file.path}');
  //     setState(() {
  //       documentList.addAll(result.files);
  //     });
  //     // Proceed to upload the file
  //     // uploadDocument(file);
  //   } else {
  //     // User canceled the picker
  //     print('No file selected');
  //   }
  // }

  Future<String> getFileDateAndTime(File file) async {
    final lastModified = await file.lastModified();
    return '${lastModified.day}-${lastModified.month}-${lastModified.year} ${lastModified.hour}:${lastModified.minute.toString().padLeft(2, '0')}';
  }

  // void removeDocument(int index) {
  //   setState(() {
  //     documentList.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              widget.serviceVisible
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Services',
                                style: AppTextStyle().cardLableText,
                              ),
                              SizedBox(height: 5),
                              CustomDropdownButton(
                                dropdownItems: ['sdsd', 'ddsbf'],
                                initialValue: serviceValue,
                                hintText: 'select service',
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Please select service';
                                  }
                                  return null;
                                },
                                onChanged: (p0) {
                                  setState(() {
                                    serviceValue = p0;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Sub-services',
                                style: AppTextStyle().cardLableText,
                              ),
                              SizedBox(height: 5),
                              CustomDropdownButton(
                                dropdownItems: ['ramesh', 'fdsf'],
                                initialValue: subServiceValue,
                                hintText: 'select sub service',
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Please select service';
                                  }
                                  return null;
                                },
                                onChanged: (p0) {
                                  setState(() {
                                    subServiceValue = p0;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              widget.serviceVisible ? SizedBox(height: 10) : SizedBox.shrink(),
              BlocBuilder<UploadDocumentBloc, UploadDocumentState>(
                builder: (context, state) {
                  documentList =
                      (state is UploadDocumentLoaded) ? state.documents : [];
                  return FilePickerWidget();
                },
              ),
              CommonButtonWidget(
                  buttonTitle: 'Upload',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      debugPrint('cbxncvbdbvnxbvxdnm $documentList');
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
