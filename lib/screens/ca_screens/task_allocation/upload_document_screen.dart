import 'package:ca_app/blocs/task/task_bloc.dart';
import 'package:ca_app/blocs/upload_document/upload_document_bloc.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/file_picker_widget.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UploadTaskDocumentScreen extends StatefulWidget {
  final int taskId;
  const UploadTaskDocumentScreen({super.key, required this.taskId});

  @override
  State<UploadTaskDocumentScreen> createState() =>
      _UploadTaskDocumentScreenState();
}

class _UploadTaskDocumentScreenState extends State<UploadTaskDocumentScreen> {
  List<PlatformFile> documentList = [];
  bool selectedValue = false;
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Upload Document',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Documents (Optional)',
                style: AppTextStyle().menuUnselectedText,
              ),
              SizedBox(height: 5),
              BlocBuilder<UploadDocumentBloc, UploadDocumentState>(
                builder: (context, state) {
                  documentList =
                      (state is UploadDocumentLoaded) ? state.documents : [];
                  return FilePickerWidget();
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                controlAffinity: ListTileControlAffinity.leading,
                value: selectedValue,
                title: Text('Send Notification'),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                    debugPrint('selected value $selectedValue');
                  });
                },
              ),
              BlocConsumer<TaskBloc, TaskState>(
                listener: (context, state) {
                  if (state is TaskUploadDocumentSuccess) {
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return CommonButtonWidget(
                    buttonTitle: 'Upload',
                    loader: state is TaskLoading,
                    onTap: () async {
                      if (documentList.isEmpty) {
                        Utils.toastErrorMessage('File is required');
                      } else {
                        List<MultipartFile> multipartFiles = [];
                        for (var file in documentList) {
                          multipartFiles.add(
                            await MultipartFile.fromFile(file.path!,
                                filename: file.name),
                          );
                        }
                        context.read<TaskBloc>().add(TaskUploadDocumentEvent(
                            taskId: widget.taskId,
                            documentList: multipartFiles,
                            emailStatus: selectedValue));
                      }
                    },
                  );
                },
              )
            ],
          ),
        ));
  }
}
