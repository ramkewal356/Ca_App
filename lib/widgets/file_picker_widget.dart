// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:ca_app/blocs/upload_document/upload_document_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({
    super.key,
  });

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  @override
  void initState() {
    super.initState();
    context.read<UploadDocumentBloc>().add(ResetDocumentEvent());
  }

  Future<String> getFileDateAndTime(File file) async {
    final lastModified = await file.lastModified();
    return '${lastModified.day}-${lastModified.month}-${lastModified.year} ${lastModified.hour}:${lastModified.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadDocumentBloc, UploadDocumentState>(
      listener: (context, state) {},
      builder: (context, state) {
        List<PlatformFile> documentList =
            (state is UploadDocumentLoaded) ? state.documents : [];
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: DashedBorder.fromBorderSide(
                      dashLength: 2,
                      side:
                          BorderSide(color: ColorConstants.darkGray, width: 1)),
                  color: ColorConstants.buttonColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () {
                      context
                          .read<UploadDocumentBloc>()
                          .add(PickDocumentEvent());
                    },
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 30,
                      color: ColorConstants.buttonColor,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Drag and Drop or'),
                      TextButton(
                          onPressed: () {
                            // pickDocument();
                            context
                                .read<UploadDocumentBloc>()
                                .add(PickDocumentEvent());
                          },
                          child: Text(
                            'Choose your file',
                            style: TextStyle(
                                color:
                                    ColorConstants.purpleColor.withOpacity(0.7),
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                                decorationColor: ColorConstants.purpleColor
                                    .withOpacity(0.7)),
                          )),
                    ],
                  ),
                 
                ],
              ),
            ),
            Text(
              'Allowed types: JPEG, PNG. Max size: less than 1MB per file.',
              style: TextStyle(color: ColorConstants.greenColor, fontSize: 12),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: documentList.length,
              itemBuilder: (context, index) {
                var file = documentList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            color: ColorConstants.blueColor.withOpacity(0.1),
                            border: Border.all(
                                color:
                                    ColorConstants.darkGray.withOpacity(0.8)),
                            borderRadius: BorderRadius.circular(10)),
                        child: (file.path!.endsWith('.pdf') ||
                                file.path!.endsWith('.doc'))
                            ? Icon(
                                Icons.insert_drive_file,
                                size: 50,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(file.path ?? ''),
                                  fit: BoxFit.fill,
                                )),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(file.name),
                            SizedBox(height: 5),
                            Text(
                                'Size : ${(file.size / 1024).toStringAsFixed(2)} KB'),
                            // SizedBox(height: 5),
                            FutureBuilder<String>(
                                future:
                                    getFileDateAndTime(File(file.path ?? '')),
                                builder: (context, snapshot) {
                                  return Text('Time : ${snapshot.data}');
                                }),
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                // removeDocument(index);
                                context
                                    .read<UploadDocumentBloc>()
                                    .add(RemoveDocumentEvent(
                                      index: index,
                                    ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ColorConstants.redColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: Text(
                                    'Delete',
                                    style: AppTextStyle().smallbuttontext,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
