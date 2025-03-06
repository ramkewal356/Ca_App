import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/data/models/get_service_and_subservice_list_model.dart';
import 'package:ca_app/data/models/get_services_list_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_bottomsheet_modal.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ServiceScreen1 extends StatefulWidget {
  const ServiceScreen1({super.key});

  @override
  State<ServiceScreen1> createState() => _ServiceScreen1State();
}

class _ServiceScreen1State extends State<ServiceScreen1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchNode = FocusNode();
  String? selectedService;
  String? selectedSubService;
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    _fetchService(isSearch: true);
    // _getServiceListForDropdown();
    _scrollController.addListener(_onScroll);
  }

  void _getServiceListForDropdown() {
    context.read<ServiceBloc>().add(GetServiceListEvent());
  }

  void _fetchService({bool isSearch = false, bool isPagination = false}) {
    context.read<ServiceBloc>().add(GetCaServiceListEvent(
        isSearch: isSearch,
        searchText: searchQuery,
        isPagination: isPagination));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 🔹 Trigger pagination event

      _fetchService(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    _fetchService(isSearch: true);
  }

  int serviceId = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('cnxcjhcnbcmncmnmcn');
        FocusScope.of(context).unfocus();
        _searchNode.unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: CustomSearchField(
                    focusNode: _searchNode,
                    controller: _searchController,
                    serchHintText: 'Search..by service name,subservice name,id',
                    onChanged: _onSearchChanged,
                  ),
                ),
                SizedBox(width: 10),
                CustomBottomsheetModal(
                    buttonHieght: 48,
                    buttonWidth: 130,
                    buttonTitle: 'Add Service',
                    onTap: () {
                      _getServiceListForDropdown();
                      setState(() {
                        selectedService = null;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
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
                                  icon: Icon(Icons.close)),
                            ),
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
                            SizedBox(height: 10),
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
                            SizedBox(height: 15),
                            BlocConsumer<ServiceBloc, ServiceState>(
                              listener: (context, state) {
                                if (state is AddServiceSuccess) {
                                  context.pop();
                                  _fetchService(isSearch: true);
                                } else if (state is ServiceError) {
                                  context.pop();
                                  _fetchService(isSearch: true);
                                }
                              },
                              builder: (context, state) {
                                return CommonButtonWidget(
                                  loader: state is AddServiceLoading,
                                  buttonTitle: 'ADD SERVICE',
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<ServiceBloc>().add(
                                          AddServiceEvent(
                                              serviceId: serviceId));
                                    }
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              if (state is ServiceLoading) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.buttonColor,
                    ),
                  ),
                );
              } else if (state is ServiceError) {
                return Center(
                  child: Text(
                    'No Data',
                    style: AppTextStyle().getredText,
                  ),
                );
              } else if (state is GetCaServiceListSuccess) {
                return Expanded(
                  child: state.getCaServicesList.isEmpty
                      ? Center(
                          child: Text('No Data'),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: state.getCaServicesList.length +
                              (state.isLastPage ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index == state.getCaServicesList.length) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.buttonColor,
                                ),
                              );
                            }
                            var data = state.getCaServicesList[index];
                            return CustomCard(
                                child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: CustomTextItem(
                                            lable: 'Id',
                                            value: '#${data.serviceId}')),
                                    Expanded(
                                        flex: 3,
                                        child: CustomTextItem(
                                            lable: 'Created date',
                                            value: DateFormat('dd/MM/yyyy')
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        data.createdDate ??
                                                            0))))
                                  ],
                                ),
                                CustomTextInfo(
                                    flex1: 2,
                                    flex2: 3,
                                    lable: 'Service Name',
                                    value: '${data.serviceName}'),
                                CustomTextInfo(
                                    flex1: 2,
                                    flex2: 3,
                                    lable: 'SubService Name',
                                    value: '${data.subService}'),
                                CustomTextInfo(
                                    flex1: 2,
                                    flex2: 3,
                                    lable: 'Services Description',
                                    value: '${data.serviceDesc}'),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: CommonButtonWidget(
                                    buttonWidth: 100,
                                    buttonheight: 45,
                                    buttonBorderColor:
                                        ColorConstants.darkRedColor,
                                    tileStyle: AppTextStyle().getredText,
                                    buttonColor: ColorConstants.white,
                                    buttonTitle: 'Delete',
                                    onTap: () {},
                                  ),
                                )
                              ],
                            ));
                          },
                        ),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
