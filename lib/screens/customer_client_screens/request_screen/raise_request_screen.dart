import 'package:ca_app/blocs/multi_select_dropdown/multi_select_dropdown_bloc.dart';
import 'package:ca_app/blocs/multi_select_dropdown/multi_select_dropdown_state.dart';
import 'package:ca_app/blocs/upload_document/upload_document_bloc.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_multi_select_dropdown.dart';
import 'package:ca_app/widgets/file_picker_widget.dart';
import 'package:ca_app/widgets/multi_dropdown_widget.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RaiseRequestScreen extends StatefulWidget {
  final String userRole;
  const RaiseRequestScreen({super.key, required this.userRole});

  @override
  State<RaiseRequestScreen> createState() => _RaiseRequestScreenState();
}

class _RaiseRequestScreenState extends State<RaiseRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _listController = TextEditingController();
  List<String> selectedItem = [];
  List<PlatformFile> documentList = [];
  String? selectedCa;
  final List<String> items = [
    "Sarthak",
    "Binni",
    "John",
    "Alex",
    "Emma",
    'fdgfg',
    'hgfhjhgjhg',
    'hghjgvvbv'
  ];
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
                                  onTap: () {},
                                )
                    ],
                  ),
                  SizedBox(height: 10),
                  widget.userRole == 'CUSTOMER'
                      ? CustomDropdownButton(
                          dropdownItems: ['vishal'],
                          initialValue: selectedCa,
                          hintText: 'Select your ca',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your ca';
                            }
                            return null;
                          },
                        )
                      : MultiSelectDropdownWidget(
                          items: items,
                          hintText: 'Select items',
                          onSelectionChange: (value) {
                            setState(() {
                              selectedItem = value;
                            });
                            debugPrint('slectedItem,,,,,$selectedItem');
                          },
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please select item';
                            }
                            return null;
                          },
                        ),
                  SizedBox(height: 10),
                  // BlocBuilder<MultiSelectDropdownBloc,
                  //     MultiSelectDropdownState>(
                  //   builder: (context, state) {
                  //     selectedItem = state is MultiSelectDropdownLoaded
                  //         ? state.selectedItems
                  //         : [];
                  //     return CustomMultiSelectDropdown(
                  //       items: items,
                  //       hintText: 'Select client',
                  //       validator: (p0) {
                  //         if (selectedItem.isEmpty) {
                  //           return 'Please select items';
                  //         }
                  //         return null;
                  //       },
                  //     );
                  //   },
                  // ),
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
                  CommonButtonWidget(
                      buttonTitle: 'Raise',
                      onTap: () {
                        debugPrint('vcnvbbnmxbdxnm$selectedItem');
                        if (_formKey.currentState!.validate()) {}
                      })
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
