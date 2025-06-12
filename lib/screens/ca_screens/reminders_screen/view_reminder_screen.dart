import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/blocs/reminder/reminder_bloc.dart';
import 'package:ca_app/data/models/get_login_customer_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_multi_select_dropdown.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ViewReminderScreen extends StatefulWidget {
  final int reminderId;
  const ViewReminderScreen({super.key, required this.reminderId});

  @override
  State<ViewReminderScreen> createState() => _ViewReminderScreenState();
}

class _ViewReminderScreenState extends State<ViewReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedOccurence;
  List<int> selectedUserIds = [];
  List<String> selectedItems = [];
  @override
  void initState() {
    _getViewreminder();
    super.initState();
  }

  void _getViewreminder() {
    context
        .read<ReminderBloc>()
        .add(GetViewReminderEvent(reminderId: widget.reminderId));
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'View Reminder',
          backIconVisible: true,
        ),
        child: BlocConsumer<ReminderBloc, ReminderState>(
          listener: (context, state) {
            if (state is ActiveDeactiveReminderSucess ||
                state is ActiveDeactiveReminderError) {
              _getViewreminder();
            }
          },
          builder: (context, state) {
            if (state is ReminderLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.buttonColor,
                ),
              );
            } else if (state is ReminderError) {
              return Center(
                child: Text('No Data Found'),
              );
            } else if (state is GetViewReminderSuccess) {
              var data = state.getViewReminderByIdData.data;

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child:
                                  _textItem(lable: 'Id', value: '${data?.id}'),
                            ),
                            Expanded(
                              child: _textItem(
                                  lable: 'Title', value: '${data?.title}'),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: _textItem(
                                  lable: 'Occurence',
                                  value: '${data?.occurrence}'),
                            ),
                            Expanded(
                              child: _textItem(
                                  lable: 'Status',
                                  value: data?.status == true
                                      ? 'Active'
                                      : 'Inactive'),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Desciption : ',
                          style: AppTextStyle().hintText,
                        ),
                        SizedBox(height: 5),
                        TextformfieldWidget(
                            readOnly: true,
                            maxLines: 3,
                            minLines: 3,
                            controller: TextEditingController(
                                text: '${data?.description}'),
                            hintText: 'Description'),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Users',
                              style: AppTextStyle().labletext,
                            ),
                            SizedBox(width: 5),
                            Container(
                              decoration: BoxDecoration(
                                  color: ColorConstants.buttonColor,
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${data?.users?.length}',
                                  style: AppTextStyle().smallbuttontext,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          child: ListView.builder(
                            itemCount: data?.users?.length ?? 0,
                            itemBuilder: (context, index) {
                              return CustomCard(
                                  child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                minVerticalPadding: 0,
                                horizontalTitleGap: 10,
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: ColorConstants.buttonColor,
                                  child: Text(
                                    '${data?.users?[index].firstName?[0] ?? ''}${data?.users?[index].lastName?[0] ?? ''}',
                                    style: AppTextStyle().buttontext,
                                  ),
                                ),
                                title: Text(
                                    '${data?.users?[index].firstName} ${data?.users?[index].lastName}'),
                                subtitle: Text(data?.users?[index].email ?? ''),
                              ));
                            },
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: -10,
                      child: PopupMenuButton<String>(
                        position: PopupMenuPosition.under,
                        color: ColorConstants.white,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        constraints:
                            BoxConstraints(minWidth: 90, maxWidth: 140),
                        offset: Offset(0, 0),
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: ColorConstants.buttonColor,
                        ),
                        onSelected: (value) {
                          debugPrint("Selected: $value");
                          if (value == 'Active') {
                            context.read<ReminderBloc>().add(
                                ActiveDeactiveReminderEvent(
                                    reminderId: data?.id ?? 0,
                                    isActivate: true));
                          } else if (value == 'Deactive') {
                            context.read<ReminderBloc>().add(
                                ActiveDeactiveReminderEvent(
                                    reminderId: data?.id ?? 0,
                                    isActivate: false));
                          } else if (value == 'Edit') {
                            context.read<CustomerBloc>().add(
                                GetLogincutomerEvent(selectedClientName: ''));

                            setState(() {
                              selectedItems = data?.users
                                      ?.map((toElement) =>
                                          '${toElement.firstName} ${toElement.lastName}')
                                      .toList() ??
                                  [];
                              selectedUserIds = data?.users == null
                                  ? []
                                  : data!.users!
                                      .where((customer) => selectedItems.contains(
                                          '${customer.firstName} ${customer.lastName}'))
                                      .map((customer) => customer.id ?? 0)
                                      .toList();
                              selectedOccurence = data?.occurrence;
                              _titleController.text = data?.title ?? '';
                              _descriptionController.text =
                                  data?.description ?? '';
                              debugPrint('selected occurence $selectedUserIds');
                            });
                            _showModalBottomSheet(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Update Reminder',
                                            style: AppTextStyle().cardLableText,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                context.pop();
                                              },
                                              icon: Icon(Icons.close)),
                                        ],
                                      ),
                                      Text('Select Client',
                                          style: AppTextStyle().labletext),
                                      SizedBox(height: 5),
                                      BlocBuilder<CustomerBloc, CustomerState>(
                                        builder: (context, state) {
                                          List<LoginCustomerData> customers =
                                              [];
                                          if (state
                                              is GetLoginCustomerSuccess) {
                                            customers = state.getLoginCustomers;
                                            debugPrint(
                                                'object ${customers.map((toElement) => '${toElement.firstName} ${toElement.lastName}').toList()}');
                                          }
                                          return MultiSelectSearchableDropdown(
                                            hintText: 'Select client',
                                            openInModal: true,
                                            items: customers
                                                .map((toElement) =>
                                                    '${toElement.firstName} ${toElement.lastName}')
                                                .toList(),
                                            selectedItems: selectedItems,
                                            onChanged: (newSelection) {
                                              selectedUserIds = customers
                                                  .where((customer) =>
                                                      newSelection.contains(
                                                          '${customer.firstName} ${customer.lastName}'))
                                                  .map((customer) =>
                                                      customer.userId ?? 0)
                                                  .toList();
                                              setState(() {
                                                selectedItems = newSelection;
                                                debugPrint(
                                                    'selectedItems $selectedUserIds');
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please select client';
                                              }
                                              return null;
                                            },
                                          );
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Text('Occurence',
                                          style: AppTextStyle().labletext),
                                      SizedBox(height: 5),
                                      CustomDropdownButton(
                                        dropdownItems: [
                                          'WEEKLY',
                                          'MONTHLY',
                                          'YEARLY'
                                        ],
                                        initialValue: selectedOccurence,
                                        hintText: 'Select occurence',
                                        onChanged: (p0) {
                                          setState(() {
                                            selectedOccurence = p0;
                                            debugPrint(
                                                'selected occurence $selectedOccurence');
                                          });
                                        },
                                        validator: (p0) {
                                          if (p0 == null || p0.isEmpty) {
                                            return 'Please select occurence';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Text('Title',
                                          style: AppTextStyle().labletext),
                                      SizedBox(height: 5),
                                      TextformfieldWidget(
                                        controller: _titleController,
                                        hintText: 'Enter title',
                                        validator: (p0) {
                                          if (p0 == null || p0.isEmpty) {
                                            return 'Please enter title';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Text('Description',
                                          style: AppTextStyle().labletext),
                                      SizedBox(height: 5),
                                      TextformfieldWidget(
                                        controller: _descriptionController,
                                        hintText: 'Enter description',
                                        validator: (p0) {
                                          if (p0 == null || p0.isEmpty) {
                                            return 'Please enter description';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 15),
                                      BlocConsumer<CreateReminderBloc,
                                          ReminderState>(
                                        listener: (context, state) {
                                          if (state is UpdateReminderSuccess) {
                                            context.pop();
                                            _getViewreminder();
                                          }
                                        },
                                        builder: (context, state) {
                                          return CommonButtonWidget(
                                            buttonTitle: 'UPDATE',
                                            loader: state is ReminderLoading,
                                            onTap: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<CreateReminderBloc>()
                                                    .add(UpdateReminderEvent(
                                                        reminderId: data?.id
                                                                .toString() ??
                                                            '',
                                                        title: _titleController
                                                            .text,
                                                        description:
                                                            _descriptionController
                                                                .text,
                                                        occurence:
                                                            selectedOccurence ??
                                                                '',
                                                        userIds:
                                                            selectedUserIds));
                                              }
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                              height: 45,
                              value:
                                  data?.status == true ? 'Deactive' : 'Active',
                              child: SizedBox(
                                  width: 120,
                                  child: Text(data?.status == true
                                      ? 'Deactive'
                                      : 'Active'))),
                          PopupMenuItem<String>(
                              height: 45,
                              value: 'Edit',
                              child: SizedBox(width: 120, child: Text('Edit'))),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ));
  }

  _textItem({required String lable, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: AppTextStyle().hintText,
        ),
        Text(
          value,
          style: AppTextStyle().cardValueText,
        )
      ],
    );
  }

  Future<void> _showModalBottomSheet({required Widget child}) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: ColorConstants.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setstate) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(), child: child),
            );
          });
        });
  }
}
