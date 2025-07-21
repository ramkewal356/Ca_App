
import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/blocs/raise_request/raise_request_bloc.dart';
import 'package:ca_app/blocs/upload_document/upload_document_bloc.dart';
import 'package:ca_app/data/models/get_customer_by_subca_id_model.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
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
  final TextEditingController _searchController = TextEditingController();
  ScrollController controller = ScrollController();

  List<int> selectedRowIds = [];
  String selectedItems1 = '';
  final FocusNode _focusNode = FocusNode();
  List<String> selectedItems = [];
  String selectedUserIds = '';
  // String caId = '';
  List<PlatformFile> documentList = [];
  String? selectedCa;
  String searchQuery = '';
  final _searchFocus = FocusNode();


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
      debugPrint('selectedId...${widget.selectedId}');
    }
  }

  void _getUser() {
    // context.read<AuthBloc>().add(GetUserByIdEvent());
    if (widget.userRole == 'CA') {
      // _getLoginCustomer();
      _fetchCustomer(role: 'CA');
    } else if (widget.userRole == 'SUBCA') {
      // _getCustomerBySubCaId();
      _fetchCustomer(role: 'SUBCA');
    }
  }

  void _onSelectRow(int rowId) {
    setState(() {
      if (selectedRowIds.contains(rowId)) {
        selectedRowIds.remove(rowId);
      } else {
        selectedRowIds.add(rowId);
      }
      selectedUserIds = '[${selectedRowIds.join(',')}]';
      debugPrint('selected id $selectedRowIds');
      debugPrint('selected item $selectedItems');
    });
  }

  // _getCustomerBySubCaId() {
  //   context.read<CustomerBloc>().add(GetCustomerBySubCaEvent(
  //       searchText: '',
  //       isSearch: true,
  //       isPagination: false,
  //       pageNumber: -1,
  //       pageSize: -1));
  // }

  // _getLoginCustomer() {
  //   context
  //       .read<CustomerBloc>()
  //       .add(GetLogincutomerEvent(selectedClientName: ''));
  // }

  Future<void> _fetchCustomer(
      {bool isPagination = false,
      bool isSearch = false,
      required String role}) async {
    context.read<CustomerBloc>().add(
          GetCustomerByCaIdForNewEvent(
              searchText: searchQuery,
              isPagination: isPagination,
              isSearch: isSearch,
              pageNumber: 0,
              pageSize: 10,
              role: role),
        );
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    _fetchCustomer(isSearch: true, role: widget.userRole);
  }

  @override
  Widget build(BuildContext context) {
    var currentSatate = context.watch<CustomerBloc>().state;
    List<Content> customerList = currentSatate is GetCustomerForRaiseSuccess
        ? currentSatate.customers
        : [];
    int currentPage = currentSatate is GetCustomerForRaiseSuccess
        ? currentSatate.currentPage
        : 0;
    int rowPerPage = currentSatate is GetCustomerForRaiseSuccess
        ? currentSatate.rowsPerPage
        : 0;
    int totalCustomers = currentSatate is GetCustomerForRaiseSuccess
        ? currentSatate.totalCustomer
        : 0;
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
                          context.push('/raise_request/your_request',
                              extra: {"role": widget.userRole});
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
                                    context.push(
                                        '/raise_request/client_request',
                                        extra: {"role": widget.userRole});
                                  },
                                )
                    ],
                  ),
                  SizedBox(height: 10),
                  if (widget.userRole == 'CUSTOMER' ||
                      (widget.selectedUser ?? '').isNotEmpty)
                    TextformfieldWidget(
                        readOnly: true,
                        controller:
                            TextEditingController(text: widget.selectedUser),
                        hintText: 'select user'),
               

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
                    textLength: 250,
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
                  (widget.selectedUser ?? '').isEmpty
                      ? SizedBox.shrink()
                      : BlocConsumer<RaiseRequestBloc, RaiseRequestState>(
                          listener: (context, state) {
                            if (state is SendRaiseRequestSuccess) {
                              _formKey.currentState!.reset();
                              selectedItems.clear();
                              selectedRowIds.clear();
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
                                            description:
                                                _descriptionController.text,
                                            receiverId:
                                                widget.userRole.isNotEmpty
                                                    ? '[${widget.selectedId}]'
                                                    : selectedUserIds,
                                            files: multipartFiles));
                                  }
                                });
                          },
                        ),
                  (widget.selectedUser ?? '').isNotEmpty
                      ? SizedBox.shrink()
                      : Row(
                          children: [
                            (widget.selectedUser ?? '').isNotEmpty
                                ? SizedBox.shrink()
                                : Expanded(
                                    child: CustomSearchField(
                                      focusNode: _searchFocus,
                                      controller: _searchController,
                                      serchHintText:
                                          'search by userid, user name, email',
                                      onChanged: _onSearchChanged,
                                    ),
                                  ),
                            if ((widget.selectedUser ?? '').isEmpty)
                              SizedBox(width: 10),
                            BlocConsumer<RaiseRequestBloc, RaiseRequestState>(
                              listener: (context, state) {
                                if (state is SendRaiseRequestSuccess) {
                                  _formKey.currentState!.reset();
                                  selectedItems.clear();
                                  selectedRowIds.clear();
                                  _fetchCustomer(role: widget.userRole);
                                  _descriptionController.clear();
                                  _focusNode.unfocus();
                                  context
                                      .read<UploadDocumentBloc>()
                                      .add(ResetDocumentEvent());
                                }
                              },
                              builder: (context, state) {
                                return CommonButtonWidget(
                                    buttonWidth: 120,
                                    buttonTitle: widget.userRole == 'CA'
                                        ? 'Send'
                                        : 'Raise',
                                    disable: selectedRowIds.isEmpty,
                                    loader: state is RaiseRequestLoading,
                                    onTap: () async {
                                      debugPrint(
                                          'vcnvbbnmxbdxnm$selectedItems');
                                      if (_formKey.currentState!.validate()) {
                                        List<MultipartFile> multipartFiles = [];
                                        for (var file in documentList) {
                                          multipartFiles.add(
                                            await MultipartFile.fromFile(
                                                file.path!,
                                                filename: file.name),
                                          );
                                        }
                                        context.read<RaiseRequestBloc>().add(
                                            SendRaiseRequestEvent(
                                                description:
                                                    _descriptionController.text,
                                                receiverId: selectedUserIds,
                                                files: multipartFiles));
                                      }
                                    });
                              },
                            ),
                          ],
                        ),

                  SizedBox(height: 15),
                  (widget.selectedUser ?? '').isNotEmpty
                      ? SizedBox.shrink()
                      : Scrollbar(
                          child: SizedBox(
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingRowColor: WidgetStatePropertyAll(
                                    ColorConstants.buttonColor),
                                headingTextStyle: AppTextStyle().buttontext,
                                columnSpacing: 20,
                                columns: [
                                  DataColumn(
                                      label: SizedBox(
                                          width: 70, child: Text('USER ID'))),
                                  DataColumn(
                                      label: SizedBox(
                                          width: 130, child: Text('NAME'))),
                                  DataColumn(
                                      label: SizedBox(
                                          width: 80, child: Text('GENDER'))),
                                  DataColumn(
                                      label: SizedBox(
                                          width: 100,
                                          child: Text('PANCARD NO'))),
                                  DataColumn(
                                      label: SizedBox(
                                          width: 120, child: Text('MOBILE'))),
                                ],
                                rows: currentSatate is CustomerLoading
                                    ? [
                                        DataRow(cells: [
                                          DataCell.empty,
                                          DataCell.empty,
                                          DataCell(
                                            Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: ColorConstants.buttonColor,
                                            )), // Loader in table row
                                          ),
                                          DataCell.empty,
                                          DataCell.empty,
                                        ])
                                      ]
                                    : (customerList.isNotEmpty)
                                        ? customerList.map((toElement) {
                                            return DataRow(
                                              cells: [
                                                DataCell(Row(
                                                  children: [
                                                    Checkbox(
                                                      activeColor:
                                                          ColorConstants
                                                              .buttonColor,
                                                      visualDensity:
                                                          VisualDensity(
                                                              horizontal: -4,
                                                              vertical: -4),
                                                      // value: selectedRowIndex ==
                                                      //     toElement.userId,
                                                      value: selectedRowIds
                                                          .contains(
                                                              toElement.userId),
                                                      onChanged: (bool? value) {
                                                        _onSelectRow(
                                                            toElement.userId ??
                                                                0);
                                                      },
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                            '#${toElement.userId}')),
                                                  ],
                                                )),
                                                DataCell(SizedBox(
                                                  width: 130,
                                                  child: Text(
                                                      '${toElement.firstName ?? ''} ${toElement.lastName ?? ''}'),
                                                )),
                                                DataCell(SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                        toElement.gender ??
                                                            'N/A'))),
                                                DataCell(SizedBox(
                                                    width: 100,
                                                    child: Text(toElement
                                                            .panCardNumber ??
                                                        'N/A'))),
                                                DataCell(SizedBox(
                                                    width: 120,
                                                    child: Text(
                                                        '+91 ${toElement.mobile ?? 'N/A'}'))),
                                              ],
                                            );
                                          }).toList()
                                        : [
                                            DataRow(cells: [
                                              DataCell.empty,
                                              DataCell.empty,
                                              DataCell(
                                                Center(
                                                  child: Text(
                                                    'No data',
                                                    style:
                                                        AppTextStyle().redText,
                                                  ),
                                                ),
                                              ),
                                              DataCell.empty,
                                              DataCell.empty,
                                            ])
                                          ],
                              ),
                            ),
                          ),
                        ),
                  // SizedBox(height: 5),
                  (widget.selectedUser ?? '').isNotEmpty
                      ? SizedBox.shrink()
                      : Divider(),
                  (widget.selectedUser ?? '').isNotEmpty
                      ? SizedBox.shrink()
                      : Row(
                          children: [
                            Text(
                                " ${currentPage + 1} - ${customerList.length} of $totalCustomers"),
                            Spacer(),
                            IconButton(
                                onPressed: currentPage > 0
                                    ? () {
                                        context
                                            .read<CustomerBloc>()
                                            .add(PreviousPage());
                                      }
                                    : null,
                                icon: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentPage > 0
                                            ? ColorConstants.buttonColor
                                            : ColorConstants.buttonColor
                                                // ignore: deprecated_member_use
                                                .withOpacity(0.5)),
                                    child: Icon(
                                      Icons.keyboard_arrow_left_rounded,
                                      color: ColorConstants.white,
                                    ))),
                            SizedBox(width: 20),
                            IconButton(
                                onPressed: (currentPage + 1) * rowPerPage <
                                        totalCustomers
                                    ? () {
                                        context
                                            .read<CustomerBloc>()
                                            .add(NextPage());
                                      }
                                    : null,
                                icon: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (currentPage + 1) * rowPerPage <
                                                totalCustomers
                                            ? ColorConstants.buttonColor
                                            : ColorConstants.buttonColor
                                                // ignore: deprecated_member_use
                                                .withOpacity(0.5)),
                                    child: Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      color: ColorConstants.white,
                                    ))),
                          ],
                        ),
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
