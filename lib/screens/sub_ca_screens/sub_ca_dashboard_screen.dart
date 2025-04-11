import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/blocs/dashboard/dashboard_bloc.dart';
import 'package:ca_app/blocs/document/document_bloc.dart';
import 'package:ca_app/data/models/subca_dashboard_model.dart';
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

class SubCaDashboardScreen extends StatefulWidget {
  const SubCaDashboardScreen({super.key});

  @override
  State<SubCaDashboardScreen> createState() => _SubCaDashboardScreenState();
}

class _SubCaDashboardScreenState extends State<SubCaDashboardScreen> {
  int selectedValue = 0;
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
    // BlocProvider.of<AuthBloc>(context).add(GetUserByIdEvent());
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() {
    BlocProvider.of<AuthBloc>(context).add(GetUserByIdEvent());
    _fetchCustomersData();
    _getRecentDocument();
    _getDashboardData();
  }

  void _getDashboardData() {
    context.read<DashboardBloc>().add(GetSubCaDashboardEvent());
  }

  Future<void> _getRecentDocument({bool isPagination = false}) async {
    context
        .read<DocumentBloc>()
        .add(GetRecentDocumentEvent(isPagination: isPagination));
  }

  Future<void> _fetchCustomersData() async {
    // ignore: use_build_context_synchronously
    context.read<CustomerBloc>().add(GetCustomerBySubCaEvent(
        searchText: '', isPagination: false, isSearch: true));
  }

  UserModel? user;
  @override
  Widget build(BuildContext context) {
    var recentDocumentState = context.watch<DocumentBloc>().state;
    var dashboardState = context.watch<DashboardBloc>().state;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        user = state is GetUserByIdSuccess
            ? state.getUserByIdData // Cast to GetUserByIdModel?
            : null;
      },
      builder: (context, state) {
        SubCaDashboardModel? getDashboardData =
            dashboardState is GetSubCaDashboardSuccess
                ? dashboardState.getSubCaDashboardData
                : null;
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
            title: 'SUB CA',
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
                '${user?.data?.firstName ?? ''}${user?.data?.lastName ?? ''}',
            emailAddress: user?.data?.email ?? '',
            profileUrl: user?.data?.profileUrl ?? '',
            activeButton: true,
            activeTex: user?.data?.status == true ? 'Active' : "Inactive",
            // selectedIndex: selectedValue,
            // onItemSelected: (index) {
            //   setState(() {
            //     selectedValue = index;
            //   });
            // },
            menuItems: [
              {
                "imgUrl": Icons.home_outlined,
                "label": "Dashboard",
                "onTap": () {
                  _getUserDetails();
                }
              },
              {
                "imgUrl": Icons.add_photo_alternate_outlined,
                "label": "Recent Document",
                "onTap": () {
                  context.push('/recent_document',
                      extra: {'role': 'SUBCA'}).then((onValue) {
                    _getUserDetails();
                  });
                }
              },
              {
                "imgUrl": Icons.miscellaneous_services_outlined,
                "label": "My Services",
                "onTap": () {
                  context.push('/subca_dashboard/my_service',
                      extra: {"caId": user?.data?.caId}).then((onValue) {
                    _getUserDetails();
                  });
                }
              },
              {
                "imgUrl": Icons.info,
                "label": "My CA",
                "onTap": () {
                  // context.push('/myCa', extra: {"caId": user?.data?.caId}).then(
                  //     (onValue) {
                  //   _getUserDetails();
                  // });
                }
              },
              {
                "imgUrl": Icons.person_outlined,
                "label": "My Clients",
                "onTap": () {
                  context.push('/subca_dashboard/my_client').then((onValue) {
                    _getUserDetails();
                  });
                }
              },
              {
                "imgUrl": Icons.task_outlined,
                "label": "My Task",
                "onTap": () {
                  // context.push('/subca_dashboard/my_task').then((onValue) {
                  //   _getUserDetails();
                  // });
                }
              },
              {
                "imgUrl": Icons.star,
                "label": "Raise Request",
                "onTap": () {
                  context.push('/raise_request', extra: {'role': 'SUBCA'}).then(
                      (onValue) {
                    _getUserDetails();
                  });
                }
              },
              {
                "imgUrl": Icons.account_circle_outlined,
                "label": "My Profile",
                "onTap": () {
                  context.push('/myProfile');
                }
              },
              {
                "imgUrl": Icons.help_sharp,
                "label": "Help & Support",
                "onTap": () {
                  context.push('/help&support', extra: true);
                }
              },
            ],
          ),
          body: (dashboardState is! GetSubCaDashboardSuccess ||
                  recentDocumentState is! RecentDocumentSuccess)
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Wrap(
                                  alignment: WrapAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context.push(
                                            '/subca_dashboard/my_service',
                                            extra: {
                                              "caId": user?.data?.caId
                                            }).then((onValue) {
                                          _getUserDetails();
                                        });
                                      },
                                      child: DashboardCard(
                                        icon: Icon(
                                          Icons.miscellaneous_services_outlined,
                                          color: ColorConstants.white,
                                        ),
                                        total:
                                            '${getDashboardData?.data?.totalService}',
                                        lable: 'Services',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .push('/subca_dashboard/my_client')
                                            .then((onValue) {
                                          _getUserDetails();
                                        });
                                      },
                                      child: DashboardCard(
                                        icon: Icon(
                                          Icons.groups,
                                          color: ColorConstants.white,
                                        ),
                                        total:
                                            '${getDashboardData?.data?.totalClient}',
                                        lable: 'Clients',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .push('/subca_dashboard/my_task')
                                            .then((onValue) {
                                          _getUserDetails();
                                        });
                                      },
                                      child: DashboardCard(
                                        icon: Icon(
                                          Icons.task,
                                          color: ColorConstants.white,
                                        ),
                                        total:
                                            '${getDashboardData?.data?.totalTask}',
                                        lable: 'Task',
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
                                    ColorConstants.darkGray.withOpacity(0.6)),
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
                                                  '/subca_dashboard/my_client')
                                              .then((onValue) {
                                            _getUserDetails();
                                          });
                                        })
                                  ],
                                ),
                                BlocBuilder<CustomerBloc, CustomerState>(
                                  builder: (context, state) {
                                    if (state is CustomerError) {
                                      return Text('data');
                                    } else if (state
                                        is GetCustomerBySubCaSuccess) {
                                      return Expanded(
                                        child: (state.getCustomers ?? [])
                                                .isEmpty
                                            ? Center(
                                                child: Text(
                                                  'No Data Found',
                                                  style: AppTextStyle().redText,
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount:
                                                    (state.getCustomers ?? [])
                                                                .length >
                                                            6
                                                        ? 6
                                                        : state.getCustomers
                                                            ?.length,
                                                itemBuilder: (context, index) {
                                                  var data = state
                                                      .getCustomers?[index];
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                        horizontalTitleGap: 10,
                                                        leading: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor:
                                                              ColorConstants
                                                                  .buttonColor,
                                                          child:
                                                              (data?.profileUrl ??
                                                                          '')
                                                                      .isNotEmpty
                                                                  ? ClipOval(
                                                                      child: Image
                                                                          .network(
                                                                        data?.profileUrl ??
                                                                            '',
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      '${data?.firstName?[0] ?? ""}${data?.lastName?[0] ?? ''}',
                                                                      style: AppTextStyle()
                                                                          .buttontext,
                                                                    ),
                                                        ),
                                                        title: Text(
                                                            '${data?.firstName ?? ""} ${data?.lastName ?? ''}',
                                                            style: AppTextStyle()
                                                                .textButtonStyle),
                                                        subtitle: Text(
                                                            data?.email ?? ''),
                                                        trailing: Text(
                                                            dateFormate(data
                                                                ?.createdDate)),
                                                      ),
                                                      Divider()
                                                    ],
                                                  );
                                                },
                                                // separatorBuilder: (context, index) {
                                                //   return Divider();
                                                // },
                                              ),
                                      );
                                    }
                                    return Container();
                                  },
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
                                  context.push('/recent_document',
                                      extra: {'role': 'SUBCA'}).then((onValue) {
                                    _getUserDetails();
                                  });
                                })
                          ],
                        ),
                      ),
                      BlocBuilder<DocumentBloc, DocumentState>(
                        builder: (context, state) {
                          if (state is DocumentError) {
                            return Container(
                              height: 200,
                              margin: EdgeInsets.only(bottom: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorConstants.darkGray),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  'No Data Found',
                                  style: AppTextStyle().redText,
                                ),
                              ),
                            );
                          } else if (state is RecentDocumentSuccess) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: (state.recentDocumnets ?? []).isEmpty
                                  ? Container(
                                      height: 200,
                                      margin: EdgeInsets.only(bottom: 15),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ColorConstants.darkGray),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                        child: Text(
                                          'No Data Found',
                                          style: AppTextStyle().redText,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          (state.recentDocumnets ?? []).length >
                                                  6
                                              ? 6
                                              : state.recentDocumnets?.length,
                                      itemBuilder: (context, index) {
                                        var data =
                                            state.recentDocumnets?[index];
                                        return CustomCard(child: BlocBuilder<
                                            DownloadDocumentBloc,
                                            DocumentState>(
                                          builder: (context, state) {
                                            return CustomRecentDocument(
                                              id: '#${data?.uuid ?? ''}',
                                              clientName:
                                                  '${data?.customerName}',
                                              documentName: '${data?.docName}',
                                              category: data?.serviceName ??
                                                  'General',
                                              subCategory:
                                                  data?.subService ?? 'General',
                                              postedDate: dateFormate(
                                                  data?.createdDate),
                                              downloadLoader: state
                                                      is DocumentDownloading &&
                                                  (state.docName ==
                                                      data?.docName),
                                              onTapDownload: () {
                                                context
                                                    .read<
                                                        DownloadDocumentBloc>()
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
                                                    extra: {
                                                      'role': 'SUBCA',
                                                      "selectedUser":
                                                          data?.customerName,
                                                      "selectedId": data?.userId
                                                    }).then((onValue) {
                                                  _getUserDetails();
                                                });
                                              },
                                            );
                                          },
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
                ),
        );
      },
    );
  }
}
