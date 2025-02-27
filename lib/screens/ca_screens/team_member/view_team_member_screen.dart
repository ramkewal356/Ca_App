import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/data/models/get_customer_by_subca_id_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ViewTeamMemberScreen extends StatefulWidget {
  final String userId;
  const ViewTeamMemberScreen({super.key, required this.userId});

  @override
  State<ViewTeamMemberScreen> createState() => _ViewTeamMemberScreenState();
}

class _ViewTeamMemberScreenState extends State<ViewTeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  ScrollController controller = ScrollController();

  String searchQuery = '';
  @override
  void initState() {
    context.read<AuthBloc>().add(GetUserByIdEvent(userId: widget.userId));
    super.initState();

    _fetchTeamMembers();
  }

  void _fetchTeamMembers({bool isPagination = false, bool isSearch = false}) {
    context.read<CustomerBloc>().add(GetCustomerBySubCaIdEvent(
        subCaId: widget.userId,
        searchText: searchQuery,
        isSearch: isSearch,
        isPagination: isPagination));
  }

  void _onScroll() {
    _fetchTeamMembers(isPagination: true);
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    _fetchTeamMembers(isSearch: true);
  }

  // int _currentPage = 0;
  // final int _rowsPerPage = 1;
  @override
  Widget build(BuildContext context) {
    var currentSatate = context.watch<CustomerBloc>().state;
    List<Datum>? customers = currentSatate is GetCustomerBySubCaIdSuccess
        ? currentSatate.customers
        : [];
    int currentPage = currentSatate is GetCustomerBySubCaIdSuccess
        ? currentSatate.currentPage
        : 0;
    int rowPerPage = currentSatate is GetCustomerBySubCaIdSuccess
        ? currentSatate.rowsPerPage
        : 0;
    int totalCustomers = currentSatate is GetCustomerBySubCaIdSuccess
        ? currentSatate.totalCustomer
        : 0;
    debugPrint('ccbbnvbvc $customers');
    // int start = _currentPage * _rowsPerPage;
    // int end = start + _rowsPerPage;
    // List<Datum>? customer = customer1!
    //     .sublist(start, end > customer1.length ? customer1.length : end);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _searchFocusNode.unfocus();
      },
      child: CustomLayoutPage(
          appBar: CustomAppbar(
            title: 'View Team Member',
            backIconVisible: true,
            // onTapBack: () {
            //   context.go('/ca_dashboard/team_member');
            // },
          ),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is AuthLoading && state is! GetUserByIdSuccess) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.buttonColor,
                  ),
                );
              } else if (state is GetUserByIdSuccess) {
                var data = state.getUserByIdData?.data;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${data?.firstName ?? ''} ${data?.lastName ?? ''}',
                              style: AppTextStyle().headingtext,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: ColorConstants.buttonColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: PopupMenuButton<String>(
                                position: PopupMenuPosition.under,
                                color: ColorConstants.white,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                constraints:
                                    BoxConstraints(minWidth: 90, maxWidth: 140),
                                offset: Offset(0, 0),
                                icon: Row(
                                  children: [
                                    Text(
                                      'More options',
                                      style: AppTextStyle().buttontext,
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: ColorConstants.white,
                                    )
                                  ],
                                ), // Custom icon
                                onSelected: (value) {
                                  debugPrint("Selected: $value");
                                  if (value == 'Deactive') {
                                    _showModalBottomSheet();
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                      height: 45,
                                      value: 'Deactive',
                                      child: SizedBox(
                                          width: 120, child: Text('Deactive'))),
                                  PopupMenuItem<String>(
                                      height: 45,
                                      value: 'Logs',
                                      child: SizedBox(
                                          width: 120, child: Text('Logs'))),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: ColorConstants.buttonColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    data?.firstName?[0].toUpperCase() ?? '',
                                    style: AppTextStyle().largWhitetext,
                                  ),
                                  Text(
                                    data?.lastName?[0].toUpperCase() ?? '',
                                    style: AppTextStyle().mediumWhitetext,
                                  ),
                                ],
                              )),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data?.firstName ?? ''} ${data?.lastName ?? ''}',
                                  style: AppTextStyle().textButtonStyle,
                                ),
                                subTitle(Icons.email, data?.email ?? ''),
                                subTitle(Icons.call,
                                    '+${data?.countryCode ?? ''} ${data?.mobile ?? ''}'),
                                (data?.address ?? '').isNotEmpty
                                    ? subTitle(
                                        Icons.location_on, data?.address ?? '')
                                    : SizedBox.shrink(),
                              ],
                            ))
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: ColorConstants.darkGray.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              children: [
                                textItem(
                                    lable: 'Pan Card',
                                    value: '${data?.panCardNumber ?? '_'}'),
                                textItem(
                                    lable: 'Aadhaar Card',
                                    value: '${data?.aadhaarCardNumber ?? '_'}'),
                                textItem(
                                    lable: 'Created Date',
                                    value: DateFormat('dd/MM/yyyy').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            data?.createdDate ?? 0))),
                                textItem(
                                    lable: 'Gender',
                                    value: data?.gender ?? '_'),
                                textItem(
                                    lable: 'Status',
                                    value: data?.status == true
                                        ? 'Active'
                                        : "In-Active"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Total Assigned Clients',
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
                                  totalCustomers.toString(),
                                  style: AppTextStyle().smallbuttontext,
                                ),
                              ),
                            )
                          ],
                        ),
                        CustomSearchField(
                          controller: _searchController,
                          serchHintText: 'search',
                          onChanged: _onSearchChanged,
                        ),
                        SizedBox(height: 10),
                        Scrollbar(
                          controller: controller,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(bottom: 5),
                            controller: controller,
                            child: DataTable(
                              headingRowColor: WidgetStatePropertyAll(
                                  ColorConstants.buttonColor),
                              headingTextStyle: AppTextStyle().buttontext,
                              columns: [
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('NAME')),
                                DataColumn(label: Text('EMAIL')),
                                DataColumn(label: Text('MOBILE'))
                              ],
                              rows: (customers == null || customers.isEmpty)
                                  ? [
                                      DataRow(cells: [
                                        DataCell.empty,
                                        DataCell(
                                          Center(
                                            child: Text(
                                              'No data',
                                              style: AppTextStyle().redText,
                                            ),
                                          ),
                                        ),
                                        DataCell.empty,
                                        DataCell.empty,
                                      ])
                                    ]
                                  : customers.map((toElement) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(
                                              toElement.userId?.toString() ??
                                                  'N/A')),
                                          DataCell(Text(
                                              toElement.firstName ?? 'N/A')),
                                          DataCell(
                                              Text(toElement.email ?? 'N/A')),
                                          DataCell(
                                              Text(toElement.mobile ?? 'N/A')),
                                        ],
                                      );
                                    }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                                " ${currentPage + 1} - ${customers.length} of $totalCustomers"),
                            Spacer(),
                            IconButton(
                                onPressed: currentPage > 0
                                    ? () {
                                        context
                                            .read<CustomerBloc>()
                                            .add(PreviousPage());
                                      }
                                    : null,
                                // onPressed: _currentPage > 0
                                //     ? () {
                                //         setState(() {
                                //           _currentPage--;
                                //         });
                                //       }
                                //     : null,
                                icon: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentPage > 0
                                            ? ColorConstants.buttonColor
                                            : ColorConstants.buttonColor
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
                                // onPressed: (_currentPage + 1) * _rowsPerPage <
                                //         customer1.length
                                //     ? () {
                                //         setState(() {
                                //           _currentPage++;
                                //         });
                                //       }
                                //     : null,
                                icon: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (currentPage + 1) * rowPerPage <
                                                totalCustomers
                                            ? ColorConstants.buttonColor
                                            : ColorConstants.buttonColor
                                                .withOpacity(0.5)),
                                    child: Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      color: ColorConstants.white,
                                    ))),
                          ],
                        ),
                        // SizedBox(height: 20),
                        // PaginatedDataTable(
                        //   showEmptyRows: false,
                        //   arrowHeadColor: ColorConstants.buttonColor,
                        //   headingRowColor: WidgetStatePropertyAll(
                        //       ColorConstants.buttonColor),
                        //   columns: [
                        //     DataColumn(
                        //         label: Text(
                        //       'ID',
                        //       style: AppTextStyle().smallbuttontext,
                        //     )),
                        //     DataColumn(
                        //         label: Text(
                        //       'NAME',
                        //       style: AppTextStyle().smallbuttontext,
                        //     )),
                        //     DataColumn(
                        //         label: Text(
                        //       'EMAIL',
                        //       style: AppTextStyle().smallbuttontext,
                        //     )),
                        //     DataColumn(
                        //         label: Text(
                        //       'MOBILE',
                        //       style: AppTextStyle().smallbuttontext,
                        //     )),
                        //   ],
                        //   source: CustomerDataSource(customer1),

                        //   rowsPerPage: customer.isEmpty
                        //       ? 1
                        //       : (customer.length < 10
                        //           ? customer.length
                        //           : 10), // Number of rows per page
                        //   showCheckboxColumn: false, // Hide checkboxes
                        // )
                      ],
                    ),
                  ),
                );
              }
              return SizedBox();
            },
          )),
    );
  }

  subTitle(IconData icon, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: ColorConstants.buttonColor,
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            title,
            style: AppTextStyle().subTitleText,
          ),
        )
      ],
    );
  }

  textItem({required String lable, required String value}) {
    return Row(
      children: [
        Expanded(
            child: Text(
          lable,
          style: AppTextStyle().cardLableText,
        )),
        Expanded(
            child: Text(
          value,
          style: value == 'Active'
              ? AppTextStyle().getgreenText
              : value == 'In-Active'
                  ? AppTextStyle().getredText
                  : AppTextStyle().cardValueText,
        ))
      ],
    );
  }

  Future<void> _showModalBottomSheet() {
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
                physics: const NeverScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(
                              Icons.close,
                              color: ColorConstants.darkRedColor,
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'Note : ',
                                style: AppTextStyle().cardLableText),
                            TextSpan(
                                text: 'Are you sure you want to ',
                                style: AppTextStyle().cardValueText),
                            TextSpan(
                                text: 'Deactive ?',
                                style: AppTextStyle().getredText)
                          ]))),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: TextformfieldWidget(
                          maxLines: 3,
                          minLines: 3,
                          controller: _descriptionController,
                          hintText: 'Reason...',
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'Please enter reason';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CommonButtonWidget(
                          buttonTitle: 'De-Active',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}

class CustomerDataSource extends DataTableSource {
  final List<Datum> customerList;

  CustomerDataSource(this.customerList);
  @override
  DataRow? getRow(int index) {
    if (customerList.isEmpty) {
      // Show a placeholder row when there's no data
      return DataRow(
          color: WidgetStatePropertyAll(ColorConstants.white),
          cells: [
            DataCell(Text("")),
            DataCell(Center(
                child: Text("No data", style: TextStyle(color: Colors.red)))),
            DataCell(Text("")),
            DataCell(Text("")),
          ]);
    }

    if (index >= customerList.length) return null;
    final customer = customerList[index];

    return DataRow(color: WidgetStatePropertyAll(ColorConstants.white), cells: [
      DataCell(Text(customer.userId.toString())),
      DataCell(Text(customer.firstName ?? '')),
      DataCell(Text(customer.email ?? '')),
      DataCell(Text(customer.mobile ?? '')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => customerList.isEmpty
      ? 1
      : customerList.length; // Ensure at least one row for "No data found"

  @override
  int get selectedRowCount => 0;
}
