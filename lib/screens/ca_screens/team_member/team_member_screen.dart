import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/team_member/team_member_bloc.dart';
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
import 'package:ca_app/widgets/custom_phone_field.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TeamMemberScreen extends StatefulWidget {
  const TeamMemberScreen({super.key});

  @override
  State<TeamMemberScreen> createState() => _TeamMemberScreenState();
}

class _TeamMemberScreenState extends State<TeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  String countryCode = '91';
  Map<String, bool> filters = {
    "All": false,
    "Active": false,
    "Inactive": false,
  };
  String selectedFilter = '';
  String searchQuery = '';
  int selectedIndex = -1;
  @override
  void initState() {
    super.initState();
    // 🔹 Initial API call with default empty search and filter
    _fetchTeamMembers(isFilter: true);

    // 🔹 Add pagination logic on scroll
    _scrollController.addListener(_onScroll);
  }

  void _fetchTeamMembers(
      {bool isPagination = false,
      bool isFilter = false,
      bool isSearch = false}) {
    context.read<TeamMemberBloc>().add(
          GetTeamMemberEvent(
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

      _fetchTeamMembers(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    _fetchTeamMembers(isSearch: true);
  }

  void _onFilterChanged(String value) {
    setState(() {
      selectedFilter = value;
    });
    _fetchTeamMembers(isFilter: true);
  }

  void _onTeamMemberAdded() {
    _fetchTeamMembers(isFilter: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Team Member',
          backIconVisible: true,
        ),
        onRefresh: () async {
          _fetchTeamMembers(isFilter: true);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _searchFocusNode.unfocus();
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomSearchField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            serchHintText:
                                'Search..by service name,subservice name,id',
                            onChanged: _onSearchChanged),
                      ),
                      SizedBox(width: 5),
                      CustomFilterPopup(
                          // filterTitle: '',
                          filterIcon: Icon(Icons.filter_list_rounded),
                          filterItems: ['All', 'Active', 'Inactive'],
                          selectedFilters: filters,
                          onFilterChanged: _onFilterChanged),
                      SizedBox(width: 10),
                      CustomBottomsheetModal(
                          buttonHieght: 48,
                          buttonWidth: 100,
                          buttonTitle: 'TEAM',
                          buttonIcon: true,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Add Team Member',
                                        style: AppTextStyle().headingtext,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          icon: Icon(Icons.close)),
                                    ],
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
                                  Text('Email',
                                      style: AppTextStyle().labletext),
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
                                          'complete phone number ${_phoneController.text}');
                                      debugPrint(
                                          'complete phone country code $countryCode');
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
                                      } else if (value.completeNumber.length <
                                              10 ||
                                          value.completeNumber.length > 15) {
                                        return 'Please enter a valid phone number';
                                      } else {
                                        var isValid =
                                            ValidatorClass.isValidMobile(
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
                                        _onTeamMemberAdded();
                                        context.pop();
                                        Utils.toastSuccessMessage(
                                            'Team Member Added SuccessFully');
                                      }
                                    },
                                    builder: (context, state) {
                                      return CommonButtonWidget(
                                        loader: state is AuthLoading,
                                        buttonTitle: 'ADD TEAM',
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            BlocProvider.of<AuthBloc>(context)
                                                .add(AddUserEvent(
                                                    firstName:
                                                        _firstNameController
                                                            .text,
                                                    lastName:
                                                        _lastNameController
                                                            .text,
                                                    email:
                                                        _emailController.text,
                                                    countryCode: countryCode,
                                                    mobile:
                                                        _phoneController.text,
                                                    role: 'SUBCA'));
                                          }
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                BlocConsumer<TeamMemberBloc, TeamMemberState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is TeamMemberLoading &&
                        state is! GetTeamMemberSuccess) {
                      return Expanded(
                          child: Center(
                              child: CircularProgressIndicator(
                        color: ColorConstants.buttonColor,
                      )));
                    } else if (state is TeamMemberError) {
                      return Center(
                        child: Text(
                          'No data found !',
                          style: AppTextStyle().redText,
                        ),
                      );
                    } else if (state is GetTeamMemberSuccess) {
                      return Expanded(
                        child: (state.getTeamMemberModel ?? []).isNotEmpty
                            ? ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    (state.getTeamMemberModel?.length ?? 0) +
                                        (state.isLastPage ? 0 : 1),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      state.getTeamMemberModel?.length) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      color: ColorConstants.buttonColor,
                                    ));
                                  }
                                  var data = state.getTeamMemberModel?[index];
                                  return CustomCard(
                                      child: Column(
                                    children: [
                                      CustomTextInfo(
                                          flex1: 2,
                                          flex2: 4,
                                          lable: 'UserId',
                                          value: '# ${data?.userId}'),
                                      CustomTextInfo(
                                          flex1: 2,
                                          flex2: 4,
                                          lable: 'Full Name',
                                          value:
                                              '${data?.firstName}${data?.lastName}'),
                                      CustomTextInfo(
                                          flex1: 2,
                                          flex2: 4,
                                          lable: 'Email',
                                          value: '${data?.email}'),
                                      CustomTextInfo(
                                          flex1: 2,
                                          flex2: 4,
                                          lable: 'Mobile',
                                          value: '+${data?.mobile}'),
                                      CustomTextInfo(
                                          flex1: 2,
                                          flex2: 4,
                                          lable: 'Acceptance',
                                          value: '${data?.userResponse}'),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: data?.status == true
                                                    ? ColorConstants
                                                        .lightGreenColor
                                                    : ColorConstants
                                                        .lightRedColor),
                                            height: 45,
                                            width: 100,
                                            child: Center(
                                              child: Text(
                                                  data?.status == true
                                                      ? 'Active'
                                                      : "Inactive",
                                                  style: data?.status == true
                                                      ? AppTextStyle()
                                                          .getgreenText
                                                      : AppTextStyle().redText),
                                            ),
                                          ),
                                          BlocConsumer<AuthBloc, AuthState>(
                                            listener: (context, state) {
                                              if (state is GetUserByIdSuccess) {
                                                // Ensures navigation executes after widget build
                                                selectedIndex = -1;
                                              }
                                            },
                                            builder: (context, state) {
                                              return CommonButtonWidget(
                                                loader: selectedIndex == index,
                                                buttonWidth: 100,
                                                buttonheight: 45,
                                                buttonTitle: 'View',
                                                onTap: () {
                                                  setState(() {
                                                    selectedIndex = index;
                                                  });

                                                  context.push(
                                                      '/ca_dashboard/view_team_member',
                                                      extra: {
                                                        "userId": data?.userId
                                                            .toString(),
                                                      }).then((onValue) {
                                                    context
                                                        .read<AuthBloc>()
                                                        .add(
                                                            GetUserByIdEvent());
                                                  });
                                                },
                                              );
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ));
                                },
                              )
                            : Center(
                                child: Text(
                                'No data found !',
                                style: AppTextStyle().redText,
                              )),
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
          ),
        ));
  }
}
