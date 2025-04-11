import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/data/models/get_customer_by_subca_id_model.dart';
import 'package:ca_app/data/models/get_services_list_model.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_multi_select_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AssignServiceToClient extends StatefulWidget {
  final String? clientId;
  final List<String>? selectedServicesList;
  final List<int>? selectedServicesIdList;

  const AssignServiceToClient(
      {super.key,
      this.clientId,
      this.selectedServicesList,
      this.selectedServicesIdList});

  @override
  State<AssignServiceToClient> createState() => _AssignServiceToClientState();
}

class _AssignServiceToClientState extends State<AssignServiceToClient> {
  final _formKey = GlobalKey<FormState>();

  List<String> selectedItems = [];
  List<int> selectedUserIds = [];
  List<String> selectedServices = [];
  List<int> selectedServiceIds = [];
  @override
  void initState() {
    super.initState();
    if ((widget.clientId ?? '').isEmpty) _fetchCustomer();
    _fetchService();
  }

  void _fetchCustomer({bool isPagination = false, bool isSearch = true}) {
    context.read<CustomerBloc>().add(
          GetCustomerByCaIdForTableEvent(
              searchText: '',
              isPagination: isPagination,
              isSearch: isSearch,
              pageNumber: -1,
              pageSize: -1),
        );
  }

  void _fetchService() {
    setState(() {
      selectedServices = widget.selectedServicesList ?? [];
      selectedServiceIds = widget.selectedServicesIdList ?? [];
    });
    context.read<ServiceBloc>().add(GetCaServiceListEvent(
        isSearch: true,
        searchText: '',
        isPagination: false,
        pageNumber: -1,
        pageSize: -1));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('selected Service>>>>> $selectedServiceIds');
    debugPrint('selected Service??>>>>> $selectedServices');

    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: (widget.clientId ?? '').isEmpty
            ? 'Assign Service'
            : 'Update Service',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (widget.clientId ?? '').isNotEmpty
                    ? SizedBox.shrink()
                    : Text('Select Client', style: AppTextStyle().labletext),
                (widget.clientId ?? '').isNotEmpty
                    ? SizedBox.shrink()
                    : SizedBox(height: 5),
                (widget.clientId ?? '').isNotEmpty
                    ? SizedBox.shrink()
                    : BlocBuilder<CustomerBloc, CustomerState>(
                        builder: (context, state) {
                          List<Content> customers = [];
                          if (state is GetCustomerByCaIdForTableSuccess) {
                            customers = state.customers;
                            debugPrint(
                                'object ${customers.map((toElement) => '${toElement.firstName} ${toElement.lastName}').toList()}');
                          }
                          return MultiSelectSearchableDropdown(
                            hintText: 'Select client',
                            openInModal: false,
                            items: customers
                                .map((toElement) =>
                                    '${toElement.firstName} ${toElement.lastName}')
                                .toList(),
                            selectedItems: selectedItems,
                            onChanged: (newSelection) {
                              selectedUserIds = customers
                                  .where((customer) => newSelection.contains(
                                      '${customer.firstName} ${customer.lastName}'))
                                  .map((customer) => customer.userId ?? 0)
                                  .toList();
                              setState(() {
                                selectedItems = newSelection;
                                debugPrint('selectedItems $selectedUserIds');
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
                Text('Select Service', style: AppTextStyle().labletext),
                SizedBox(height: 5),
                BlocBuilder<ServiceBloc, ServiceState>(
                  builder: (context, state) {
                    List<ServicesListData> listData = [];
                    if (state is GetCaServiceListSuccess) {
                      listData = state.getCaServicesList;
                      debugPrint(
                          'cvsdfdsd ${listData.map((toElement) => '${toElement.subService} (${toElement.serviceName})').toList()}');
                    }
                    return MultiSelectSearchableDropdown(
                      hintText: 'Select Service',
                      items: listData
                          .map((toElement) =>
                              '${toElement.subService} (${toElement.serviceName})')
                          .toList(),
                      selectedItems: selectedServices,
                      onChanged: (p0) {
                        selectedServiceIds = listData
                            .where((services) => p0.contains(
                                '${services.subService} (${services.serviceName})'))
                            .map((s) => s.serviceId ?? 0)
                            .toList();
                        setState(() {
                          selectedServices = p0;
                          debugPrint('selectedService $selectedServiceIds');
                        });
                      },
                    );
                  },
                ),
                SizedBox(height: 15),
                BlocConsumer<AssignServiceBloc, ServiceState>(
                  listener: (context, state) {
                    if (state is AssignServiceToUserSuccess ||
                        state is UpdateAssigneService) {
                      context.pop();
                    }
                  },
                  builder: (context, state) {
                    return CommonButtonWidget(
                      buttonTitle: (widget.clientId ?? '').isEmpty
                          ? 'Assign Service'
                          : 'Update Service',
                      loader: state is AddServiceLoading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if ((widget.clientId ?? '').isEmpty) {
                            context.read<AssignServiceBloc>().add(
                                AssignServiceEvent(
                                    selectedClients: selectedUserIds,
                                    selectedServices: selectedServiceIds));
                          } else {
                            debugPrint('fsdbnmdnmds');
                            context.read<AssignServiceBloc>().add(
                                UpdateAssignServiceEvent(
                                    clientId: widget.clientId ?? '',
                                    serviceIds: selectedServiceIds.join(',')));
                          }
                        }
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
