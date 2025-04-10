import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/blocs/raise_request/raise_request_bloc.dart';
import 'package:ca_app/blocs/upload_document/upload_document_bloc.dart';
import 'package:ca_app/data/models/get_customer_by_subca_id_model.dart';
import 'package:ca_app/data/models/get_login_customer_model.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_multi_select_dropdown.dart';
import 'package:ca_app/widgets/file_picker_widget.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RaiseRequestScreen extends StatefulWidget {
  final String userRole;
  final String? selectedUser;
  final int? selectedId;
  const RaiseRequestScreen(
      {super.key, required this.userRole, this.selectedUser, this.selectedId});

  @override
  State<RaiseRequestScreen> createState() => _RaiseRequestScreenState();
}

class _RaiseRequestScreenState extends State<RaiseRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> selectedItems = [];
  String selectedUserIds = '';
  String caId = '';
  List<PlatformFile> documentList = [];
  String? selectedCa;

  @override
  void initState() {
    super.initState();
    _initializeRequested();
    _getUser();
  }

  void _initializeRequested() {
    if (widget.selectedUser != null) {
      selectedItems = [widget.selectedUser!]; // Convert String? to List<String>
    }

    if (widget.selectedId != null) {
      selectedUserIds = '[${widget.selectedId}]';
    }
  }

  void _getUser() {
    context.read<AuthBloc>().add(GetUserByIdEvent());
    if (widget.userRole == 'CA') {
      _getLoginCustomer();
    } else if (widget.userRole == 'SUBCA') {
      _getCustomerBySubCaId();
    }
  }

  _getCustomerBySubCaId() {
    context.read<CustomerBloc>().add(GetCustomerBySubCaEvent(
        searchText: '',
        isSearch: true,
        isPagination: false,
        pageNumber: -1,
        pageSize: -1));
  }

  _getLoginCustomer() {
    context
        .read<CustomerBloc>()
        .add(GetLogincutomerEvent(selectedClientName: ''));
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Raise Request',
          backIconVisible: true,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _button(
                        icon: scheduleSendimg,
                        title: 'Your request',
                        onTap: () {
                          context.push('/raise_request/your_request');
                        },
                      ),
                      SizedBox(width: 10),
                      widget.userRole == 'CA'
                          ? SizedBox.shrink()
                          : widget.userRole == 'CUSTOMER'
                              ? _button(
                                  icon: recieptrefundimg,
                                  title: 'CA Request',
                                  onTap: () {
                                    context.push('/raise_request/ca_request');
                                  },
                                )
                              : _button(
                                  icon: recieptrefundimg,
                                  title: 'Client Request',
                                  onTap: () {
                                    context
                                        .push('/raise_request/client_request');
                                  },
                                )
                    ],
                  ),
                  SizedBox(height: 10),
                  widget.userRole == 'CUSTOMER'
                      ? BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is GetUserByIdSuccess) {
                              selectedCa = state.getUserByIdData?.data?.caName;
                              caId = state.getUserByIdData?.data?.caId
                                      .toString() ??
                                  '';
                            }
                            return CustomDropdownButton(
                              dropdownItems: ['$selectedCa'],
                              initialValue: selectedCa,
                              hintText: 'Select your ca',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your ca';
                                }
                                return null;
                              },
                            );
                          },
                        )
                      : BlocBuilder<CustomerBloc, CustomerState>(
                          builder: (context, state) {
                            List<LoginCustomerData> customers = [];
                            List<Content> customers1 = [];
                            if (state is GetLoginCustomerSuccess) {
                              customers = state.getLoginCustomers;
                              debugPrint(
                                  'object ${customers.map((toElement) => '${toElement.firstName} ${toElement.lastName}${toElement.userId}').toList()}');
                            } else if (state is GetCustomerBySubCaSuccess) {
                              customers1 = state.getCustomers ?? [];
                              debugPrint(
                                  'object???>>>>>>>????>>>> ${customers1.map((toElement) => '${toElement.firstName} ${toElement.lastName}${toElement.userId}').toList()}');
                            }
                            return MultiSelectSearchableDropdown(
                              hintText: 'Select client',
                              items: customers.isEmpty
                                  ? customers1
                                      .where((test) =>
                                          test.userResponse == 'ACCEPTED')
                                      .map((toElement) =>
                                          '${toElement.firstName} ${toElement.lastName}')
                                      .toList()
                                  : customers
                                      .map((toElement) =>
                                          '${toElement.firstName} ${toElement.lastName}')
                                      .toList(),
                              selectedItems: selectedItems,
                              onChanged: (newSelection) {
                                setState(() {
                                  List<int> selectedUsers = customers.isEmpty
                                      ? customers1
                                          .where((customer) =>
                                              newSelection.contains(
                                                  '${customer.firstName} ${customer.lastName}'))
                                          .map((customer) => int.parse(customer
                                              .userId
                                              .toString()
                                              .trim()))
                                          .toList()
                                      : customers
                                          .where((customer) =>
                                              newSelection.contains(
                                                  '${customer.firstName} ${customer.lastName}'))
                                          .map((customer) => int.parse(customer
                                              .userId
                                              .toString()
                                              .trim()))
                                          .toList();

                                  debugPrint('selectedItems $selectedUsers');
                                  selectedUserIds =
                                      '[${selectedUsers.join(',')}]';
                                  debugPrint(
                                      'selectedUserIds: $selectedUserIds');
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select client';
                                }
                                return null;
                              },
                            );
                          },
                        ),

                  SizedBox(height: 10),

                  Text(
                    'Upload Documents (Optional)',
                    style: AppTextStyle().menuUnselectedText,
                  ),
                  SizedBox(height: 5),
                  BlocBuilder<UploadDocumentBloc, UploadDocumentState>(
                    builder: (context, state) {
                      documentList = (state is UploadDocumentLoaded)
                          ? state.documents
                          : [];
                      return FilePickerWidget();
                    },
                  ),
                  // SizedBox(height: 10),
                  Text(
                    'Description : ',
                    style: AppTextStyle().menuUnselectedText,
                  ),
                  SizedBox(height: 5),
                  TextformfieldWidget(
                    minLines: 4,
                    maxLines: 4,
                    focusNode: _focusNode,
                    controller: _descriptionController,
                    hintText: 'Description',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  BlocConsumer<RaiseRequestBloc, RaiseRequestState>(
                    listener: (context, state) {
                      if (state is SendRaiseRequestSuccess) {
                        _formKey.currentState!.reset();
                        selectedItems.clear();
                        _descriptionController.clear();
                        _focusNode.unfocus();
                        context
                            .read<UploadDocumentBloc>()
                            .add(ResetDocumentEvent());
                      }
                    },
                    builder: (context, state) {
                      return CommonButtonWidget(
                          buttonTitle:
                              widget.userRole == 'CA' ? 'Send' : 'Raise',
                          loader: state is RaiseRequestLoading,
                          onTap: () async {
                            debugPrint('vcnvbbnmxbdxnm$selectedItems');
                            if (_formKey.currentState!.validate()) {
                              List<MultipartFile> multipartFiles = [];
                              for (var file in documentList) {
                                multipartFiles.add(
                                  await MultipartFile.fromFile(file.path!,
                                      filename: file.name),
                                );
                              }
                              context.read<RaiseRequestBloc>().add(
                                  SendRaiseRequestEvent(
                                      description: _descriptionController.text,
                                      receiverId: widget.userRole == 'CUSTOMER'
                                          ? '[$caId]'
                                          : selectedUserIds,
                                      files: multipartFiles));
                            }
                          });
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _button(
      {required String icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            // ignore: deprecated_member_use
            border: Border.all(color: ColorConstants.darkGray.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: 20,
                width: 20,
                color: ColorConstants.buttonColor,
              ),
              SizedBox(width: 5),
              Text(
                title,
                style: AppTextStyle().listTileText,
              )
            ],
          ),
        ),
      ),
    );
  }
}
