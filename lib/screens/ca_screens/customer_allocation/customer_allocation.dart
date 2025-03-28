import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/blocs/team_member/team_member_bloc.dart';
import 'package:ca_app/data/models/get_customer_by_subca_id_model.dart';
import 'package:ca_app/data/models/get_team_member_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_multi_select_dropdown.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerAllocation extends StatefulWidget {
  const CustomerAllocation({super.key});

  @override
  State<CustomerAllocation> createState() => _CustomerAllocationState();
}

class _CustomerAllocationState extends State<CustomerAllocation> {
  final TextEditingController _searchController = TextEditingController();
  ScrollController controller = ScrollController();

  // List<String> selectedItems = [];

  String? selectedCa;
  // final List<String> items = [
  //   "Sarthak",
  //   "Binni",
  //   "John",
  //   "Alex",
  //   "Emma",
  //   'fdgfg',
  //   'hgfhjhgjhg',
  //   'hghjgvvbv'
  // ];

  int? selectedRowIndex; // Store the selected row index
  int? selectedSubCAId;

  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
    _fetchCustomer();
  }

  void _onSelectRow(int index) {
    setState(() {
      if (selectedRowIndex == index) {
        selectedRowIndex = null; // Deselect if clicking again
      } else {
        selectedRowIndex = index; // Select new row
      }
      debugPrint('selected id $selectedRowIndex');
    });
  }

  void _fetchTeamMembers() {
    context
        .read<TeamMemberBloc>()
        .add(GetSubCaByCaIdEvent(searhText: searchQuery));
  }

  void _fetchCustomer({bool isPagination = false, bool isSearch = false}) {
    context.read<CustomerBloc>().add(
          GetCustomerByCaIdForTableEvent(
              searchText: searchQuery,
              isPagination: isPagination,
              isSearch: isSearch,
              pageNumber: 0,
              pageSize: 10),
        );
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    _fetchCustomer(isSearch: true);
  }

  @override
  Widget build(BuildContext context) {
    var currentSatate = context.watch<CustomerBloc>().state;
    List<CustomerData> customers =
        currentSatate is GetCustomerByCaIdForTableSuccess
            ? currentSatate.customers
            : [];
    int currentPage = currentSatate is GetCustomerByCaIdForTableSuccess
        ? currentSatate.currentPage
        : 0;
    int rowPerPage = currentSatate is GetCustomerByCaIdForTableSuccess
        ? currentSatate.rowsPerPage
        : 0;
    int totalCustomers = currentSatate is GetCustomerByCaIdForTableSuccess
        ? currentSatate.totalCustomer
        : 0;
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Customer Allocation',
          backIconVisible: true,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Team Member', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                BlocBuilder<TeamMemberBloc, TeamMemberState>(
                  builder: (context, state) {
                    List<Datum> data = state is GetSubCaListSuccess
                        ? state.getTeamMembers
                        : [];
                    return CustomDropdownButton(
                      dropdownItems: data
                          .map((toElement) =>
                              '${toElement.firstName} ${toElement.lastName}')
                          .toList(),
                      initialValue: selectedCa,
                      hintText: 'Select your ca',
                      onChanged: (p0) {
                        selectedSubCAId = data
                            .firstWhere((test) =>
                                '${test.firstName} ${test.lastName}' == p0)
                            .userId;
                        debugPrint('Selected sub ca id $selectedSubCAId');
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your ca';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 10),
                Text('Select Client', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                // MultiSelectSearchableDropdown(
                //   hintText: 'Select client',
                //   items: items,
                //   selectedItems: selectedItems,
                //   onChanged: (newSelection) {
                //     setState(() {
                //       selectedItems = newSelection;
                //     });
                //   },
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please select at least one item';
                //     }
                //     return null;
                //   },
                // ),
                // SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomSearchField(
                        controller: _searchController,
                        serchHintText: 'search  id',
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    SizedBox(width: 10),
                    BlocConsumer<AssigneCustomerBloc, CustomerState>(
                      listener: (context, state) {
                        if (state is AssignCustomerSuccess) {
                          _fetchCustomer();
                          _fetchTeamMembers();
                        }
                      },
                      builder: (context, state) {
                        return CommonButtonWidget(
                          buttonWidth: 120,
                          loader: state is AssignCustomerLoading,
                     
                          buttonTitle: 'Assign',
                          onTap: () {
                            context.read<AssigneCustomerBloc>().add(
                                AssignCustomerEvent(
                                    customerId: selectedRowIndex ?? 0,
                                    subCaId: selectedSubCAId ?? 0));
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowColor:
                        WidgetStatePropertyAll(ColorConstants.buttonColor),
                    headingTextStyle: AppTextStyle().buttontext,
                    columnSpacing: 20,
                    columns: [
                      DataColumn(
                          label: SizedBox(width: 70, child: Text('USER ID'))),
                      DataColumn(
                          label: SizedBox(width: 130, child: Text('NAME'))),
                      DataColumn(
                          label: SizedBox(width: 100, child: Text('MOBILE'))),
                    ],
                    rows: currentSatate is CustomerLoading
                        ? [
                            DataRow(cells: [
                              DataCell.empty,
                              DataCell(
                                Center(
                                    child: CircularProgressIndicator(
                                  color: ColorConstants.buttonColor,
                                )), // Loader in table row
                              ),
                              DataCell.empty,
                            ])
                          ]
                        : (customers.isNotEmpty)
                            ? customers.map((toElement) {
                                return DataRow(
                                  cells: [
                                    DataCell(Row(
                                      children: [
                                        Checkbox(
                                          activeColor:
                                              ColorConstants.buttonColor,
                                          visualDensity:
                                              VisualDensity(
                                              horizontal: -4, vertical: -4),
                                          value: selectedRowIndex ==
                                              toElement.userId,
                                          onChanged: (bool? value) {
                                            _onSelectRow(toElement.userId ?? 0);
                                          },
                                        ),
                                        Expanded(
                                            child:
                                                Text('#${toElement.userId}')),
                                      ],
                                    )),
                                    DataCell(SizedBox(
                                      width: 130,
                                      child: Text(
                                          '${toElement.firstName} ${toElement.lastName}' ??
                                              'N/A'),
                                    )),
                                    DataCell(SizedBox(
                                        width: 100,
                                        child:
                                            Text(toElement.mobile ?? 'N/A'))),
                                  ],
                                );
                              }).toList()
                            : [
                                DataRow(cells: [
                                  // DataCell.empty,
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
                              ],
                  ),
                ),
                // SizedBox(height: 5),
                Divider(),
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
                                context.read<CustomerBloc>().add(NextPage());
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
                // SizedBox(
                //   width: double.infinity,
                //   child: DataTable(
                //     columnSpacing: 0,
                //     headingRowHeight: 50,
                //     headingRowColor:
                //         WidgetStatePropertyAll(ColorConstants.buttonColor),
                //     headingTextStyle: AppTextStyle().buttontext,
                //     columns: [
                //       DataColumn(label: SizedBox.shrink()),
                //       DataColumn(
                //           label: SizedBox(width: 60, child: Text("USERID"))),
                //       DataColumn(label: Text("NAME")),
                //       DataColumn(
                //           label: SizedBox(width: 120, child: Text("MOBILE"))),
                //     ],
                //     rows: List<DataRow>.generate(tableData.length, (index) {
                //       var data = tableData[index];
                //       bool isSelected =
                //           selectedRowIndex == index; // Check if selected

                //       return DataRow(
                //         // selected: isSelected,
                //         // onSelectChanged: (selected) => _onSelectRow(index),
                //         cells: [
                //           DataCell(SizedBox(
                //             width: 0,
                //             child: Checkbox(
                //               value: isSelected,
                //               onChanged: (bool? value) {
                //                 _onSelectRow(index);
                //               },
                //             ),
                //           )),
                //           DataCell(SizedBox(
                //               width: 60, child: Text(data["USERID"] ?? ''))),
                //           DataCell(Text(data["NAME"] ?? '')),
                //           DataCell(SizedBox(
                //               width: 120, child: Text(data["MOBILE"] ?? ''))),
                //         ],
                //       );
                //     }),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}
