import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/blocs/document/document_bloc.dart';
import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/blocs/team_member/team_member_bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/get_customer_by_subca_id_model.dart';
import 'package:ca_app/data/models/get_services_list_model.dart';
import 'package:ca_app/data/models/recent_document_model.dart';
import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/ca_subca_custom_widget/custom_recent_document.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_drawer.dart';
import 'package:ca_app/widgets/custom_text_button.dart';
import 'package:ca_app/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CaDashboardScreen extends StatefulWidget {
  const CaDashboardScreen({super.key});

  @override
  State<CaDashboardScreen> createState() => _CaDashboardScreenState();
}

class _CaDashboardScreenState extends State<CaDashboardScreen> {
  int selectedValue = 0;
  // final ScrollController _scrollController = ScrollController();
  String getLocalizedGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return Intl.message('Good Morning');
    } else if (hour < 17) {
      return Intl.message('Good Afternoon');
    } else {
      return Intl.message('Good Evening');
    }
  }

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  Future<void> _getUserDetails() async {
    BlocProvider.of<AuthBloc>(context).add(GetUserByIdEvent());
    await _fetchCustomersData();
    await _getRecentDocument();
    _fetchTeamMembers(isFilter: true);
    _fetchService();
  }

  Future<void> _getRecentDocument({bool isPagination = false}) async {
    context
        .read<DocumentBloc>()
        .add(GetRecentDocumentEvent(isPagination: isPagination));
  }

  void _fetchService() {
    context.read<ServiceBloc>().add(GetCaServiceListEvent(
        isSearch: true,
        searchText: '',
        isPagination: false,
        pageNumber: -1,
        pageSize: -1));
  }

  Future<void> _fetchCustomersData({bool isFilter = false}) async {
    int? useId = await SharedPrefsClass().getUserId();
    // ignore: use_build_context_synchronously
    BlocProvider.of<CustomerBloc>(context).add(GetCustomerByCaIdEvent(
        caId: useId.toString(),
        searchText: '',
        pageNumber: -1,
        pageSize: -1,
        filterText: '',
        isPagination: false,
        isFilter: isFilter,
        isSearch: false));
  }

  void _fetchTeamMembers(
      {bool isPagination = false,
      bool isFilter = false,
      bool isSearch = false}) {
    context.read<TeamMemberBloc>().add(
          GetTeamMemberEvent(
              searchText: '',
              filterText: '',
              isPagination: isPagination,
              isFilter: isFilter,
              isSearch: isSearch,
              pageNumber: -1,
              pagesize: -1),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel? user = state is GetUserByIdSuccess
            ? state.getUserByIdData // Cast to GetUserByIdModel?
            : null;
        var customerSate = context.watch<CustomerBloc>().state;
        List<CustomerData>? getCustomers =
            customerSate is GetCustomerByCaIdSuccess
                ? customerSate.getCustomers
                : null;
        int totalCustomers = customerSate is GetCustomerByCaIdSuccess
            ? customerSate.totalCustomer
            : 0;
        var documentState = context.watch<DocumentBloc>().state;
        List<Content>? getRecentDocument =
            documentState is RecentDocumentSuccess
                ? documentState.recentDocumnets
                : [];
        var serviceState = context.watch<ServiceBloc>().state;
        List<ServicesListData> getServiceData =
            (serviceState is GetCaServiceListSuccess
                ? (serviceState).getCaServicesList
                : []);
        return Scaffold(
          backgroundColor: ColorConstants.white,
          appBar: CustomAppbar(
            backIconVisible: true,
            backIcon: Builder(builder: (BuildContext context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: ColorConstants.white,
                  ));
            }),
            time: '${getLocalizedGreeting()}, ',
            title: 'CA',
            actionIcons: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications,
                    color: ColorConstants.white,
                  ))
            ],
          ),
          drawer: CustomDrawer(
            userName:
                '${user?.data?.firstName ?? ''} ${user?.data?.lastName ?? ''}',
            emailAddress: user?.data?.email ?? '',
            profileUrl: user?.data?.profileUrl ?? '',
            // selectedIndex: selectedValue,
            // onItemSelected: (index) {
            //   setState(() {
            //     selectedValue = index;
            //   });
            // },
            menuItems: [
              {
                "imgUrl": Icons.dashboard,
                "label": "Dashboard",
                "onTap": () {
                  _getUserDetails();
                }
              },
              {
                "imgUrl": Icons.miscellaneous_services_outlined,
                "label": "Services",
                "onTap": () {
                  context.push('/ca_dashboard/services').then((onValue) {
                    _getUserDetails();
                  });
                }
              },
              {
                "imgUrl": Icons.add_photo_alternate_outlined,
                "label": "Recent Document",
                "onTap": () {
                  context.push('/recent_document', extra: {'role': 'CA'}).then(
                      (onValue) async {
                    await _fetchCustomersData(isFilter: true);
                  });
                  ;
                }
              },
              {
                "imgUrl": Icons.group,
                "label": "My Clients",
                "onTap": () {
                  context.push('/ca_dashboard/my_client').then((onValue) async {
                    debugPrint('bnbmnbm??????????????????????');
                    await _fetchCustomersData(isFilter: true);
                    await _getRecentDocument();
                  });
                }
              },
              {
                "imgUrl": Icons.groups_3,
                "label": "Team Members",
                "onTap": () {
                  context
                      .push('/ca_dashboard/team_member')
                      .then((onValue) async {
                    debugPrint('bnbmnbm??????????????????????');
                    await _fetchCustomersData(isFilter: true);
                    _fetchTeamMembers(isFilter: true);
                  });
                }
              },
              {
                "imgUrl": Icons.help,
                "label": "Customer Allocation",
                "onTap": () {
                  context
                      .push('/ca_dashboard/customer_allocation')
                      .then((onValue) async {
                    await _fetchCustomersData(isFilter: true);
                  });
                }
              },
              {
                "imgUrl": Icons.task,
                "label": "Task Allocation",
                "onTap": () {
                  context
                      .push('/ca_dashboard/task_allocation')
                      .then((onValue) async {
                    await _fetchCustomersData(isFilter: true);
                  });
                }
              },
              {
                "imgUrl": Icons.star,
                "label": "Raise Request",
                "onTap": () {
                  context.push('/raise_request', extra: {'role': 'CA'}).then(
                      (onValue) async {
                    await _fetchCustomersData(isFilter: true);
                  });
                }
              },
              {
                "imgUrl": Icons.history_edu,
                "label": "All Raise History",
                "onTap": () {
                  context.push('/ca_dashboard/all_raise_history');
                }
              },
              {
                "imgUrl": Icons.account_circle_outlined,
                "label": "My Profile",
                "onTap": () {
                  context.push(
                    '/myProfile',
                  );
                }
              },
              {
                "imgUrl": Icons.help_sharp,
                "label": "Help & Support",
                "onTap": () {
                  context.push('/help&support', extra: true);
                }
              },
              {
                "imgUrl": Icons.history_sharp,
                "label": "Logs History",
                "onTap": () {
                  context.push('/ca_dashboard/logs_history');
                }
              },
            ],
          ),
          body: state is AuthErrorState
              ? Center(
                  child: Text(
                    'No Data Found',
                    style: AppTextStyle().redText,
                  ),
                )
              : ((customerSate is CustomerLoading &&
                          customerSate is! GetCustomerByCaIdSuccess) ||
                      documentState is! RecentDocumentSuccess)
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.buttonColor,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: ColorConstants.buttonColor,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(40))),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Wrap(
                                      alignment: WrapAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .push('/ca_dashboard/my_client')
                                                .then((onValue) async {
                                              await _fetchCustomersData(
                                                  isFilter: true);
                                            });
                                          },
                                          child: DashboardCard(
                                            icon: Icon(
                                              Icons.groups_3,
                                              color: ColorConstants.white,
                                            ),
                                            total: '$totalCustomers',
                                            lable: 'Total Client',
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .push(
                                                    '/ca_dashboard/team_member')
                                                .then((onValue) async {
                                              debugPrint(
                                                  'bnbmnbm??????????????????????');
                                              await _fetchCustomersData(
                                                  isFilter: true);
                                              _fetchTeamMembers(isFilter: true);
                                            });
                                          },
                                          child: BlocConsumer<TeamMemberBloc,
                                              TeamMemberState>(
                                            listener: (context, state) {},
                                            builder: (context, state) {
                                              int totalTeam = 0;
                                              if (state
                                                  is GetTeamMemberSuccess) {
                                                totalTeam = state
                                                        .getTeamMemberModel
                                                        ?.length ??
                                                    0;
                                              }
                                              return DashboardCard(
                                                icon: Icon(
                                                  Icons.groups,
                                                  color: ColorConstants.white,
                                                ),
                                                total: '$totalTeam',
                                                lable: 'Team Member',
                                              );
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context
                                                .push('/ca_dashboard/services')
                                                .then((onValue) {
                                              _getUserDetails();
                                            });
                                          },
                                          child: DashboardCard(
                                            icon: Icon(
                                              Icons
                                                  .format_list_numbered_outlined,
                                              color: ColorConstants.white,
                                            ),
                                            total: '${getServiceData.length}',
                                            lable: 'Services Opted',
                                          ),
                                        ),
                                      ]),
                                ),
                              )
                            ],
                          ),
                          Card(
                            margin: EdgeInsets.all(10),
                            color: ColorConstants.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    // ignore: deprecated_member_use
                                    color:
                                        // ignore: deprecated_member_use
                                        ColorConstants.darkGray
                                            .withOpacity(0.6)),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                height: 250.h,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Client',
                                          style: AppTextStyle().subheadingtext,
                                        ),
                                        CustomTextButton(
                                            buttonTitle: 'View All',
                                            onTap: () {
                                              context
                                                  .push(
                                                      '/ca_dashboard/my_client')
                                                  .then((onValue) async {
                                                await _fetchCustomersData(
                                                    isFilter: true);
                                              });
                                            })
                                      ],
                                    ),
                                    Expanded(
                                      child: (getCustomers == null ||
                                              getCustomers.isEmpty)
                                          ? Center(
                                              child: Text(
                                                'No Client Available',
                                                style: AppTextStyle().redText,
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount:
                                                  (getCustomers.length) > 6
                                                      ? 6
                                                      : getCustomers.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      dense: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      horizontalTitleGap: 10,
                                                      leading: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor:
                                                            ColorConstants
                                                                .buttonColor,
                                                        child: (getCustomers[
                                                                            index]
                                                                        .profileUrl ??
                                                                    '')
                                                                .isEmpty
                                                            ? Text(
                                                          '${getCustomers[index].firstName?[0]}${getCustomers[index].lastName?[0]}',
                                                          style: AppTextStyle()
                                                              .buttontext,
                                                              )
                                                            : ClipOval(
                                                                child: Image.network(
                                                                    getCustomers[
                                                                            index]
                                                                        .profileUrl
                                                                        .toString()),
                                                              ),
                                                      ),
                                                      title: Text(
                                                          '${getCustomers[index].firstName} ${getCustomers[index].lastName}',
                                                          style: AppTextStyle()
                                                              .textButtonStyle),
                                                      subtitle: Text(
                                                          '${getCustomers[index].email}'),
                                                      trailing: Text(dateFormate(
                                                          getCustomers[
                                                                              index]
                                                              .createdDate)),
                                                    ),
                                                    Divider()
                                                  ],
                                                );
                                              },
                                              // separatorBuilder: (context, index) {
                                              //   return Divider();
                                              // },
                                            ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent document',
                                  style: AppTextStyle().headingtext,
                                ),
                                CustomTextButton(
                                    buttonTitle: 'View All',
                                    onTap: () {
                                      context
                                          .push('/recent_document', extra: {
                                        "role": "CA"
                                      })
                                          .then((onValue) async {
                                        await _getRecentDocument();
                                      });
                                    })
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: (getRecentDocument ?? []).isEmpty
                                ? Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    height: 100.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorConstants.darkGray),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                        child: Text(
                                      'No Document Available',
                                      style: AppTextStyle().redText,
                                    )),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        (getRecentDocument?.length ?? 0) > 6
                                            ? 6
                                            : getRecentDocument?.length,
                                    itemBuilder: (context, index) {
                                      var data = getRecentDocument?[index];
                                      return CustomCard(child: BlocBuilder<
                                          DownloadDocumentBloc, DocumentState>(
                                        builder: (context, state) {
                                          return CustomRecentDocument(
                                            id: '#${data?.uuid ?? ''}',
                                            clientName: '${data?.customerName}',
                                            documentName: '${data?.docName}',
                                            category:
                                                data?.serviceName ?? 'General',
                                            subCategory:
                                                data?.subService ?? 'General',
                                            postedDate:
                                                dateFormate(data?.createdDate),
                                            downloadLoader:
                                                state is DocumentDownloading &&
                                                    (state.docName ==
                                                        data?.docName),
                                            onTapDownload: () {
                                              context
                                                  .read<DownloadDocumentBloc>()
                                                  .add(
                                                      DownloadDocumentFileEvent(
                                                          docUrl:
                                                              data?.docUrl ??
                                                                  '',
                                                          docName:
                                                              data?.docName ??
                                                                  ''));
                                            },
                                            onTapReRequest: () {
                                              context.push('/raise_request',
                                                  extra: {'role': 'CA'});
                                            },
                                          );
                                        },
                                      ));
                                    },
                                  ),
                          )
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
