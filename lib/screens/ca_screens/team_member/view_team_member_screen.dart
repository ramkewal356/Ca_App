import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/data/models/get_customer_by_subca_id_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/active_deactive_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ViewTeamMemberScreen extends StatefulWidget {
  final String userId;
  const ViewTeamMemberScreen({super.key, required this.userId});

  @override
  State<ViewTeamMemberScreen> createState() => _ViewTeamMemberScreenState();
}

class _ViewTeamMemberScreenState extends State<ViewTeamMemberScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  ScrollController controller = ScrollController();

  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _fetchTeamMembers();
  }

  void _fetchTeamMembers({bool isPagination = false, bool isSearch = false}) {
    context.read<CustomerBloc>().add(GetCustomerBySubCaIdEvent(
        subCaId: widget.userId,
        searchText: searchQuery,
        isSearch: isSearch,
        isPagination: isPagination));
  }

  void _getUserDetails() {
    context.read<AuthBloc>().add(GetUserByIdEvent(userId: widget.userId));
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
    List<Content>? customers = currentSatate is GetCustomerBySubCaIdSuccess
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
            listener: (context, state) {},
            builder: (context, state) {
              if (state is GetUserLoading && state is! GetUserByIdSuccess) {
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
                        SizedBox(height: 10),
                        Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: ColorConstants.buttonColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: (data?.profileUrl ?? '').isNotEmpty
                                      ? Image.network(
                                          data?.profileUrl ?? '',
                                          fit: BoxFit.fill,
                                        )
                                      : Center(
                                          child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              data?.firstName?[0]
                                                      .toUpperCase() ??
                                                  '',
                                              style:
                                                  AppTextStyle().largWhitetext,
                                            ),
                                            Text(
                                              data?.lastName?[0]
                                                      .toUpperCase() ??
                                                  '',
                                              style: AppTextStyle()
                                                  .mediumWhitetext,
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
                                        ? subTitle(Icons.location_on,
                                            data?.address ?? '')
                                        : SizedBox.shrink(),
                                  ],
                                )),
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
                                icon: Row(
                                  children: [
                                    Icon(
                                      Icons.more_vert_rounded,
                                      color: ColorConstants.buttonColor,
                                    )
                                  ],
                                ), // Custom icon
                                onSelected: (value) {
                                  debugPrint("Selected: $value");
                                  if (value == 'Deactive' ||
                                      value == 'Active') {
                                    _showModalBottomSheet(
                                        context: context,
                                        actionUponId: data?.id.toString() ?? '',
                                        action: value);
                                  } else if (value == 'Logs') {
                                    context.push('/ca_dashboard/logs_history',
                                        extra: {"uponId": data?.id.toString()});
                                  } else if (value == 'Permission') {
                                    final allPermissions = [
                                      ...?data?.permissions?.clientActivities,
                                      ...?data?.permissions?.documentActivities,
                                      ...?data?.permissions?.general,
                                      ...?data?.permissions?.taskActivities,
                                    ];

                                    final selectedPermissionNamesList =
                                        allPermissions
                                            .map((p) => p.permissionName ?? '')
                                            .toList();

                                    final selectedPermissionIdsList =
                                        allPermissions
                                            .map((p) => p.id ?? 0)
                                            .toList();
                                    context.push('/ca_dashboard/permission',
                                        extra: {
                                          "subCaId": data?.id,
                                          "selectedPermissionNamesList":
                                              selectedPermissionNamesList,
                                          "selectedPermissionIdsList":
                                              selectedPermissionIdsList,
                                        }).then((onValue) {
                                      _getUserDetails();
                                      _fetchTeamMembers();
                                    });
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  if (data?.userResponse == 'ACCEPTED')
                                  PopupMenuItem<String>(
                                      height: 45,
                                      value: data?.status == true
                                          ? 'Deactive'
                                            : 'Active',
                                      child: SizedBox(
                                          width: 120,
                                          child: Text(data?.status == true
                                              ? 'Deactive'
                                                : 'Active'))),
                                  PopupMenuItem<String>(
                                      height: 45,
                                      value: 'Logs',
                                      child: SizedBox(
                                          width: 120, child: Text('Logs'))),
                                  PopupMenuItem<String>(
                                      height: 45,
                                      value: 'Permission',
                                      child: SizedBox(
                                          width: 120,
                                          child: Text('Permission'))),
                                ],
                              ),
                            ),
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
                                    value: data?.panCardNumber ?? '__'),
                                textItem(
                                    lable: 'Aadhaar Card',
                                    value:
                                        '${data?.aadhaarCardNumber ?? '__'}'),
                                textItem(
                                    lable: 'Created Date',
                                    value: dateFormate(data?.createdDate)),
                                textItem(
                                    lable: 'Gender',
                                    value: data?.gender ?? '__'),
                                textItem(
                                    lable: 'Acceptance Status',
                                    value: data?.userResponse ?? '__'),
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
                              rows: (customers.isEmpty)
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
                                                // ignore: deprecated_member_use
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

  Future<void> _showModalBottomSheet(
      {required BuildContext context,
      required String actionUponId,
      required String action}) {
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
                child: ActiveDeactiveWidget(
                  actionUponId: actionUponId,
                  action: action,
                ),
              ),
            );
          });
        });
  }
}

class CustomerDataSource extends DataTableSource {
  final List<Content> customerList;

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
