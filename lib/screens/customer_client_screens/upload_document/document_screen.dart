import 'dart:io';

import 'package:ca_app/blocs/custom_dropdown/custom_dropdown_bloc.dart';
import 'package:ca_app/blocs/document/document_bloc.dart';
import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/blocs/upload_document/upload_document_bloc.dart';
import 'package:ca_app/data/models/get_service_and_subservice_list_model.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/file_picker_widget.dart';
import 'package:dio/dio.dart';
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
  String? subServiceValue;
  final _formKey = GlobalKey<FormState>();
  List<PlatformFile> documentList = [];
  String? selectedService;
  String? selectedSubService;
  @override
  void initState() {
    super.initState();
    _getServiceListForDropdown();
  }

  Future<String> getFileDateAndTime(File file) async {
    final lastModified = await file.lastModified();
    return '${lastModified.day}-${lastModified.month}-${lastModified.year} ${lastModified.hour}:${lastModified.minute.toString().padLeft(2, '0')}';
  }

  void _getServiceListForDropdown() {
    context.read<ServiceBloc>().add(GetServiceListEvent());
  }

  int serviceId = 0;

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select Service',
                                  style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              BlocBuilder<ServiceBloc, ServiceState>(
                                builder: (context, state) {
                                  List<ServiceAndSubServiceListData> listData =
                                      [];
                                  if (state is GetCaServiceListSuccess) {
                                    listData = state.getServicesList;
                                  }
                                  return CustomDropdownButton(
                                    initialStateSelected: true,
                                    dropdownItems: listData
                                        .map((toElement) =>
                                            toElement.serviceName.toString())
                                        .toList(),
                                    initialValue: selectedService,
                                    hintText: 'Select service',
                                    onChanged: (p0) {
                                      setState(() {
                                        selectedService = p0;
                                        selectedSubService = null;
                                      });

                                      context.read<ServiceBloc>().add(
                                          GetSubServiceListEvent(
                                              serviceName:
                                                  selectedService ?? ''));
                                    },
                                    validator: (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'Please select service';
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select Sub Service',
                                  style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              BlocBuilder<ServiceBloc, ServiceState>(
                                builder: (context, state) {
                                  List<ServiceAndSubServiceListData> listData =
                                      [];
                                  if (state is GetCaServiceListSuccess) {
                                    listData = state.getSubServiceList;
                                  }
                                  return CustomDropdownButton(
                                    initialStateSelected: true,
                                    dropdownItems: listData
                                        .map((toElement) =>
                                            toElement.subService.toString())
                                        .toList(),
                                    initialValue: selectedSubService,
                                    hintText: 'Select sub service',
                                    onChanged: (p0) {
                                      setState(() {
                                        selectedSubService = p0;
                                        serviceId = listData
                                                .firstWhere((test) =>
                                                    test.subService ==
                                                    selectedSubService)
                                                .id ??
                                            0;
                                        debugPrint('service id   $serviceId');
                                      });
                                    },
                                    validator: (p0) {
                                      if (p0 == null || p0.isEmpty) {
                                        return 'Please select sub service';
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
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
              BlocConsumer<DocumentBloc, DocumentState>(
                listener: (context, state) {
                  if (state is DocumentUploadedSuccess) {
                    context
                        .read<UploadDocumentBloc>()
                        .add(ResetDocumentEvent());
                    context
                        .read<CustomDropdownBloc>()
                        .add(DropdownResetEvent());
                    serviceId = 0;
                  }
                },
                builder: (context, state) {
                  return CommonButtonWidget(
                      buttonTitle: 'Upload',
                      loader: state is DocumentLoading,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (documentList.isEmpty) {
                            Utils.toastErrorMessage('File is required');
                            return;
                          }

                          try {
                            // List<MultipartFile> multipartFiles = [];
                            // for (var file in documentList) {
                            //   multipartFiles.add(
                            //     await MultipartFile.fromFile(file.path!,
                            //         filename: file.name),
                            //   );
                            // }
                            List<MultipartFile> multipartFiles =
                                await Future.wait(
                              documentList.map(
                                (file) => MultipartFile.fromFile(file.path!,
                                    filename: file.name),
                              ),
                            );

                            if (widget.serviceVisible) {
                              // ignore: use_build_context_synchronously
                              context.read<DocumentBloc>().add(
                                    DocumentUploadEvent(
                                        file: multipartFiles,
                                        serviceId: serviceId.toString()),
                                  );
                            } else {
                              // ignore: use_build_context_synchronously
                              context.read<DocumentBloc>().add(
                                    DocumentUploadEvent(file: multipartFiles),
                                  );
                            }

                            debugPrint('Uploading files: $documentList');
                          } catch (e) {
                            Utils.toastErrorMessage('Failed to process files');
                          }
                        }
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
