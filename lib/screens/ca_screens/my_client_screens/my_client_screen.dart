import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_bottomsheet_modal.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_filter_popup.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_list_tile_card.dart';
import 'package:ca_app/widgets/custom_phone_field.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyCAClientScreen extends StatefulWidget {
  const MyCAClientScreen({super.key});

  @override
  State<MyCAClientScreen> createState() => _MyCAClientScreenState();
}

class _MyCAClientScreenState extends State<MyCAClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  String countryCode = '91';
  String selectedFilter = '';
  String searchQuery = '';
  Map<String, bool> selectedFilters = {
    "All": false,
    "Active": false,
    "Inactive": false
  };
  @override
  void initState() {
    _fetchCustomer(isFilter: true);
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _fetchCustomer(
      {bool isPagination = false,
      bool isFilter = false,
      bool isSearch = false}) {
    context.read<CustomerBloc>().add(
          GetCustomerByCaIdEvent(
              searchText: searchQuery,
              filterText: selectedFilter,
              isPagination: isPagination,
              isFilter: isFilter,
              isSearch: isSearch),
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 🔹 Trigger pagination event

      _fetchCustomer(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    _fetchCustomer(isSearch: true);
  }

  void _onFilterChanged(String value) {
    setState(() {
      selectedFilter = value;
    });
    _fetchCustomer(isFilter: true);
  }

  void _onTeamMemberAdded() {
    context.read<AuthBloc>().add(GetUserByIdEvent());
    _fetchCustomer(isFilter: true);
  }

  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'My Clients',
        backIconVisible: true,
      ),
      onRefresh: () async {
        _fetchCustomer(isFilter: true);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _searchFocusNode.unfocus();
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomSearchField(
                            focusNode: _searchFocusNode,
                            controller: _searchController,
                            serchHintText:
                                'Search..by service name,subservice name,id',
                            onChanged: _onSearchChanged,
                          ),
                        ),
                        SizedBox(width: 10),
                        CustomFilterPopup(
                          // filterTitle: 'All',
                          filterIcon: Icon(Icons.filter_list_rounded),
                          filterItems: ["All", "Active", "Inactive"],
                          selectedFilters: selectedFilters,
                          onFilterChanged: _onFilterChanged,
                        ),
                       
                        
                      ],
                    ),
                  ),
                  BlocConsumer<CustomerBloc, CustomerState>(
                    builder: (context, state) {
                      if (state is CustomerLoading &&
                          state is! GetCustomerByCaIdSuccess) {
                        return Expanded(
                            child: Center(
                                child: CircularProgressIndicator(
                          color: ColorConstants.buttonColor,
                        )));
                      } else if (state is CustomerError) {
                        return Center(
                          child: Text(
                            'No data found !',
                            style: AppTextStyle().redText,
                          ),
                        );
                      } else if (state is GetCustomerByCaIdSuccess) {
                        return Expanded(
                          child: (state.getCustomers ?? []).isEmpty
                              ? Center(
                                  child: Text(
                                    'No Data Found!',
                                    style: AppTextStyle().redText,
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  itemCount: (state.getCustomers?.length ?? 0) +
                                      (state.isLastPage ? 0 : 1),
                                  itemBuilder: (context, index) {
                                    if (index == state.getCustomers?.length) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: ColorConstants.buttonColor,
                                      ));
                                    }
                                    var data = state.getCustomers?[index];
                                    return GestureDetector(
                                      onTap: () {
                                        context.push(
                                            '/ca_dashboard/view_client',
                                            extra: {
                                              "userId": data?.userId.toString()
                                            }).then((onValue) {
                                          debugPrint(
                                              ',,,,cvnmvnc,v,,,,nv,mnv,mnv,nn,nn,v,,,');
                                          context
                                              .read<AuthBloc>()
                                              .add(GetUserByIdEvent());
                                          _fetchCustomer(isFilter: true);
                                        });
                                      },
                                      child: CustomCard(
                                          child: CustomListTileCard(
                                        id: '${data?.userId}',
                                        title:
                                            '${data?.firstName} ${data?.lastName}',
                                        subtitle1: '${data?.email}',
                                        subtitle2:
                                            '+${data?.countryCode} ${data?.mobile}',
                                        status: data?.status ?? false,
                                        imgUrl: data?.profileUrl ?? '',
                                        letter:
                                            '${data?.firstName?[0]}${data?.lastName?[0]}',
                                        isSecondary: CustomTextItem(
                                            lable: 'Assignee to',
                                            value: '${data?.caName}'),
                                      )),
                                    );
                                    // return CustomCard(
                                    //     child: Column(
                                    //   children: [
                                    //     Row(
                                    //       children: [
                                    //         Expanded(
                                    //           child: CustomTextItem(
                                    //               lable: 'Id',
                                    //               value: '#${data?.userId}'),
                                    //         ),
                                    //         Expanded(
                                    //           child: CustomTextItem(
                                    //               lable: 'Status',
                                    //               value: data?.status == true
                                    //                   ? 'Active'
                                    //                   : "Inactive"),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     CustomTextInfo(
                                    //         flex1: 2,
                                    //         flex2: 3,
                                    //         lable: 'Full Name',
                                    //         value:
                                    //             '${data?.firstName ?? ''} ${data?.lastName ?? ''}'),
                                    //     CustomTextInfo(
                                    //         flex1: 2,
                                    //         flex2: 3,
                                    //         lable: 'Mobile',
                                    //         value:
                                    //             '+${data?.countryCode} ${data?.mobile}'),
                                    //     CustomTextInfo(
                                    //         flex1: 2,
                                    //         flex2: 3,
                                    //         lable: 'Assignee to',
                                    //         value: '${data?.caName}'),
                                    //     CustomTextInfo(
                                    //         flex1: 2,
                                    //         flex2: 3,
                                    //         lable: 'Acceptance',
                                    //         value: '${data?.userResponse}'),
                                    //     SizedBox(height: 5),
                                    //     Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.spaceBetween,
                                    //       children: [
                                    //         CommonButtonWidget(
                                    //           buttonBorderColor:
                                    //               ColorConstants.buttonColor,
                                    //           buttonColor: ColorConstants.white,
                                    //           tileStyle: AppTextStyle()
                                    //               .textMediumButtonStyle,
                                    //           buttonWidth: 120,
                                    //           buttonTitle: 'Request',
                                    //           onTap: () {
                                    //             context.push('/raise_request',
                                    //                 extra: {'role': 'CA'});
                                    //           },
                                    //         ),
                                    //         BlocListener<AuthBloc, AuthState>(
                                    //           listener: (context, state) {
                                    //             if (state is GetUserByIdSuccess) {
                                    //               selectedIndex = -1;
                                    //             }
                                    //           },
                                    //           child: CommonButtonWidget(
                                    //             loader: state is AuthLoading &&
                                    //                 selectedIndex == index,
                                    //             buttonWidth: 100,
                                    //             buttonTitle: 'View',
                                    //             onTap: () {
                                    //               setState(() {
                                    //                 selectedIndex = index;
                                    //               });
                                    //               context.push(
                                    //                   '/ca_dashboard/view_client',
                                    //                   extra: {
                                    //                     "userId":
                                    //                         data?.userId.toString()
                                    //                   }).then((onValue) {
                                    //                 debugPrint(
                                    //                     ',,,,cvnmvnc,v,,,,nv,mnv,mnv,nn,nn,v,,,');
                                    //                 context
                                    //                     .read<AuthBloc>()
                                    //                     .add(GetUserByIdEvent());
                                    //                 _fetchCustomer(isFilter: true);
                                    //               });
                                    //             },
                                    //           ),
                                    //         )
                                    //       ],
                                    //     )
                                    //   ],
                                    // ));
                                  },
                                ),
                        );
                      }
                      return Container();
                    },
                    listener: (context, state) {},
                  )
                ],
              ),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: CustomBottomsheetModal(
                      buttonHieght: 48,
                      buttonWidth: 110,
                      buttonTitle: 'CLIENT',
                      isFlotingButton: true,
                      buttonIcon: true,
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
                              Text('First Name',
                                  style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              TextformfieldWidget(
                                controller: _firstNameController,
                                hintText: 'Enter first name',
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Please enter first name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              Text('Last Name',
                                  style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              TextformfieldWidget(
                                controller: _lastNameController,
                                hintText: 'Enter last Name',
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Please enter last name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              Text('Email', style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              TextformfieldWidget(
                                controller: _emailController,
                                hintText: 'Enter email',
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              Text('Mobile No',
                                  style: AppTextStyle().labletext),
                              SizedBox(height: 5),
                              CustomPhoneField(
                                intialCountryCode: countryCode,
                                controller: _phoneController,
                                onChanged: (phone) {
                                  debugPrint(
                                      'complete phone number ${phone.completeNumber}');
                                },
                                onCountryChanged: (country) {
                                  setState(() {
                                    countryCode = country.dialCode;
                                  });
                                  debugPrint(
                                      'complete phone number ${country.name}');
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.completeNumber.isEmpty) {
                                    return 'Please enter phone number';
                                  } else if (value.completeNumber.length < 10 ||
                                      value.completeNumber.length > 15) {
                                    return 'Please enter a valid phone number';
                                  } else {
                                    var isValid = ValidatorClass.isValidMobile(
                                        value.completeNumber);
                                    if (!isValid) {
                                      return 'Please enter a valid phone number';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15),
                              BlocConsumer<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state is AddUserSuccess) {
                                    _firstNameController.clear();
                                    _lastNameController.clear();
                                    _emailController.clear();
                                    _phoneController.clear();

                                    Future.microtask(() {
                                      if (context.mounted) {
                                        context
                                            .pop(); // Ensure context is still valid
                                      }
                                    });
                                    _onTeamMemberAdded();
                                    Utils.toastSuccessMessage(
                                        'Client Added SuccessFully');
                                  }
                                },
                                builder: (context, state) {
                                  return CommonButtonWidget(
                                    buttonTitle: 'ADD CLIENT',
                                    loader: state is AuthLoading,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        BlocProvider.of<AuthBloc>(context).add(
                                            AddUserEvent(
                                                firstName:
                                                    _firstNameController.text,
                                                lastName:
                                                    _lastNameController.text,
                                                email: _emailController.text,
                                                countryCode: countryCode,
                                                mobile: _phoneController.text,
                                                role: 'CUSTOMER'));
                                      }
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ))
              )
            ],
          ),
        ),
      ),
    );
  }
}
