import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/raise_request/raise_request_bloc.dart';
import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_drawer.dart';
import 'package:ca_app/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class IndivisualCustomerDashboard extends StatefulWidget {
  const IndivisualCustomerDashboard({super.key});

  @override
  State<IndivisualCustomerDashboard> createState() =>
      _IndivisualCustomerDashboardState();
}

class _IndivisualCustomerDashboardState
    extends State<IndivisualCustomerDashboard> {
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
    super.initState();
    _getUser();
  }

  void _getUser() {
    BlocProvider.of<AuthBloc>(context).add(GetUserByIdEvent());
    // _getRequest();
  }

  // void _getRequest() {
  //   context.read<RaiseRequestBloc>().add(GetRequestByReceiverIdEvent(
  //       isPagination: false, isSearch: true, searchText: ''));
  // }

  @override
  Widget build(BuildContext context) {
    var requestState = context.watch<RaiseRequestBloc>().state;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel? userdata =
            state is GetUserByIdSuccess ? state.getUserByIdData : null;

        return Scaffold(
          backgroundColor: ColorConstants.white,
          appBar: CustomAppbar(
            // backIconVisible: true,
            bgColor: ColorConstants.white,
            centerIcon: Image.asset(
              splashLogo,
              height: 40,
            ),
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
            title: 'Client',
            actionIcons: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Image.asset(
              //     appLogo,
              //     width: 80,
              //     color: ColorConstants.white,
              //   ),
              // ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_outlined,
                    // color: ColorConstants.white,
                  ))
            ],
          ),
          drawer: CustomDrawer(
            userName:
                '${userdata?.data?.firstName ?? 'x'} ${userdata?.data?.lastName ?? 'y'}',
            emailAddress: userdata?.data?.email ?? 'xyz@gmail.com',
            profileUrl: userdata?.data?.profileUrl ?? '',
            activeButton: true,
            activeTex: userdata?.data?.status == true ? 'Active' : 'Inactive',
            lastLogin: userdata?.data?.lastLogin ?? '00:00',
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
                  _getUser();
                }
              },
              // {
              //   "imgUrl": Icons.add_photo_alternate_outlined,
              //   "label": "Upload Document",
              //   "onTap": () {
              //     context.push('/indivisual_customer/audio_player');
              //   }
              // },
              // {
              //   "imgUrl": Icons.history,
              //   "label": "History",
              //   "onTap": () {
              //     context.push('/customer_dashboard/history',
              //         extra: {"userId": userdata?.data?.id.toString()});
              //   }
              // },
              // {
              //   "imgUrl": Icons.star,
              //   "label": "Request",
              //   "onTap": () {
              //     context.push('/customer_dashboard/request', extra: {
              //       'caName': userdata?.data?.caName,
              //       "caId": userdata?.data?.caId
              //     });
              //   }
              // },
              // {
              //   "imgUrl": Icons.groups,
              //   "label": "My CA",
              //   "onTap": () {
              //     context.push('/myCa', extra: {
              //       "caId": userdata?.data?.caId,
              //       "role": 'CUSTOMER'
              //     }).then((onValue) {
              //       _getUser();
              //     });
              //   }
              // },
              // {
              //   "imgUrl": Icons.payment,
              //   "label": "Payment",
              //   "onTap": () {
              //     context.push('/customer_dashboard/payment',
              //         extra: {"caId": userdata?.data?.caId}).then((onValue) {
              //       _getUser();
              //     });
              //   }
              // },
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
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: (requestState is RaiseRequestLoading)
                ? Center(
                    child: CircularProgressIndicator(
                    color: ColorConstants.buttonColor,
                  ))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, John',
                          style: AppTextStyle().textButtonStyle,
                        ),
                        Text(
                          'Welcome to your event management dashboard.',
                          style: AppTextStyle().smallSubTitleText,
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                          height: 160,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              // itemCount: 3,
                              // itemBuilder: (context, index) {
                              children: [
                                CustomCard(
                                    child: SizedBox(
                                  width: 210,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total Savings',
                                            style: AppTextStyle().cardLableText,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    ColorConstants.buttonColor),
                                            child: Icon(
                                              Icons.card_membership,
                                              color: ColorConstants.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '₹ 5000',
                                        style: AppTextStyle().headingtext,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '+12%from last month',
                                        style: AppTextStyle().smallSubTitleText,
                                      ),
                                    ],
                                  ),
                                )),
                                SizedBox(width: 15),
                                CustomCard(
                                    child: SizedBox(
                                  width: 210,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pending Documents',
                                            style: AppTextStyle().cardLableText,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    ColorConstants.buttonColor),
                                            child: Icon(
                                              Icons.card_membership,
                                              color: ColorConstants.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '7',
                                        style: AppTextStyle().headingtext,
                                      ),
                                    ],
                                  ),
                                )),
                                SizedBox(width: 15),
                                CustomCard(
                                    child: SizedBox(
                                  width: 210,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Upcoming Meetings',
                                            style: AppTextStyle().cardLableText,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    ColorConstants.buttonColor),
                                            child: Icon(
                                              Icons.card_membership,
                                              color: ColorConstants.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '3',
                                        style: AppTextStyle().headingtext,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Next: May 10,10:00 AM',
                                        style: AppTextStyle().smallSubTitleText,
                                      ),
                                    ],
                                  ),
                                )),
                                SizedBox(width: 15),
                                CustomCard(
                                    child: SizedBox(
                                  width: 210,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total Savings',
                                            style: AppTextStyle().cardLableText,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    ColorConstants.buttonColor),
                                            child: Icon(
                                              Icons.card_membership,
                                              color: ColorConstants.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '₹ 5000',
                                        style: AppTextStyle().headingtext,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '+12%from last month',
                                        style: AppTextStyle().smallSubTitleText,
                                      ),
                                    ],
                                  ),
                                )),
                              ]
                              // },
                              ),
                        ),
                        Text(
                          'Our Service',
                          style: AppTextStyle().textButtonStyle,
                        ),
                        SizedBox(
                          height: 350,
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(left: index == 0 ? 0 : 15),
                                child: SizedBox(
                                  width: 230,
                                  child: CustomCard(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorConstants.buttonColor),
                                        child: Icon(
                                          Icons.note,
                                          color: ColorConstants.white,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Auditing & Services',
                                        style: AppTextStyle().headingtext,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                          'Comprehensive auditing services and security assessments for your business'),
                                      SizedBox(height: 10),
                                      Divider(),
                                      SizedBox(height: 10),
                                      Center(
                                        child: CustomTextButton(
                                          buttonTitle: 'Learn more...',
                                          onTap: () {},
                                        ),
                                      )
                                    ],
                                  )),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Card(
                          color: ColorConstants.buttonColor,
                          child: Container(
                            height: 400,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upcoming Appoinments',
                                  style: AppTextStyle().appbartext,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            horizontalTitleGap: 40,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                            title: Text(
                                              'Tax Planning Session',
                                              style: AppTextStyle().buttontext,
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SizedBox(height: 5),
                                                Text(
                                                  'with sarah johsan',
                                                  style: AppTextStyle()
                                                      .checkboxTitle,
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_month,
                                                      color:
                                                          ColorConstants.white,
                                                    ),
                                                    Text(
                                                      'May 10,2025',
                                                      style: AppTextStyle()
                                                          .checkboxTitle,
                                                    ),
                                                    Spacer(),
                                                    Icon(
                                                      Icons.timer,
                                                      color:
                                                          ColorConstants.white,
                                                    ),
                                                    Text(
                                                      '2:00 PM',
                                                      style: AppTextStyle()
                                                          .checkboxTitle,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            trailing: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: ColorConstants.black
                                                      // ignore: deprecated_member_use
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                'Upcoming',
                                                style: AppTextStyle()
                                                    .checkboxTitle,
                                              ),
                                            ),
                                          ),
                                          Divider()
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomCard(
                            child: SizedBox(
                          height: 400,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recent Documents',
                                style: AppTextStyle().cardLableText,
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          horizontalTitleGap: 10,
                                          minLeadingWidth: 40,
                                          contentPadding: EdgeInsets.zero,
                                          leading: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ColorConstants
                                                    .buttonColor
                                                    // ignore: deprecated_member_use
                                                    .withOpacity(0.5)),
                                            child: Icon(
                                              Icons.note,
                                              color: ColorConstants.black,
                                            ),
                                          ),
                                          title: Text(
                                            'Annual Tax Report',
                                            style: AppTextStyle().cardLableText,
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: ColorConstants
                                                          .buttonColor),
                                                  child: Text(
                                                    'PDF',
                                                    style: AppTextStyle()
                                                        .checkboxTitle,
                                                  )),
                                              Text(
                                                ' May 10,2025',
                                                style: AppTextStyle()
                                                    .cardValueText,
                                              ),
                                              Spacer(),
                                              Text(
                                                '2.4 MB',
                                                style: AppTextStyle()
                                                    .cardValueText,
                                              ),
                                            ],
                                          ),
                                          trailing: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: ColorConstants.black
                                                    // ignore: deprecated_member_use
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                              'Upcoming',
                                              style: AppTextStyle().lableText,
                                            ),
                                          ),
                                        ),
                                        Divider()
                                      ],
                                    );
                                  },
                                   
                                ),
                              ),
                            ],
                          ),
                        ))
                        // GestureDetector(
                        //   onTap: () {
                        //     context.push('/customer_dashboard/upload_document');
                        //   },
                        //   child: _customcard(
                        //       lable: 'Upload Documents',
                        //       icon: Icon(
                        //         Icons.format_list_numbered_outlined,
                        //         size: 35,
                        //       )),
                        // ),
                        // SizedBox(height: 10),
                        // GestureDetector(
                        //   onTap: () {
                        //     context.push('/customer_dashboard/history', extra: {
                        //       "userId": userdata?.data?.id.toString()
                        //     });
                        //   },
                        //   child: _customcard(
                        //       lable: 'History',
                        //       icon: Icon(
                        //         Icons.history,
                        //         size: 35,
                        //       )),
                        // ),
                        // SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 5),
                        //       child: Text(
                        //         'Recent Request',
                        //         style: AppTextStyle().textheadingStyle,
                        //       ),
                        //     ),
                        //     CustomTextButton(
                        //         buttonTitle: 'View All',
                        //         onTap: () {
                        //           context.push('/customer_dashboard/request',
                        //               extra: {
                        //                 'caName': userdata?.data?.caName,
                        //                 "caId": userdata?.data?.caId
                        //               });
                        //         })
                        //   ],
                        // ),
                        // // Padding(
                        // //   padding: const EdgeInsets.symmetric(horizontal: 5),
                        // //   child: Text(
                        // //     'Recent Request',
                        // //     style: AppTextStyle().subheadingtext,
                        // //   ),
                        // // ),
                        // // SizedBox(height: 5),
                        // BlocBuilder<RaiseRequestBloc, RaiseRequestState>(
                        //   builder: (context, state) {
                        //     if (state is RaiseRequestError) {
                        //       return Container(
                        //         height: 200,
                        //         decoration: BoxDecoration(
                        //             border: Border.all(
                        //                 color: ColorConstants.darkGray),
                        //             borderRadius: BorderRadius.circular(8)),
                        //         child: Center(
                        //           child: Text(
                        //             'No Data Found!',
                        //             style: AppTextStyle().redText,
                        //           ),
                        //         ),
                        //       );
                        //     } else if (state is GetRequestByRecieverIdSuccess) {
                        //       return state.requestData.isEmpty
                        //           ? Container(
                        //               height: 200,
                        //               decoration: BoxDecoration(
                        //                   border: Border.all(
                        //                       color: ColorConstants.darkGray),
                        //                   borderRadius:
                        //                       BorderRadius.circular(8)),
                        //               child: Center(
                        //                 child: Text(
                        //                   'No Data Found!',
                        //                   style: AppTextStyle().redText,
                        //                 ),
                        //               ),
                        //             )
                        //           : ListView.builder(
                        //               shrinkWrap: true,
                        //               physics: NeverScrollableScrollPhysics(),
                        //               itemCount: state.requestData.length >= 6
                        //                   ? 6
                        //                   : state.requestData.length,
                        //               itemBuilder: (context, index) {
                        //                 var data = state.requestData[index];
                        //                 return GestureDetector(
                        //                   onTap: () {
                        //                     context
                        //                         .read<ChangeStatusBloc>()
                        //                         .add(UnreadToReadStatusEvent(
                        //                             requestId:
                        //                                 data.requestId ?? 0));
                        //                     context.push('/request_details',
                        //                         extra: {
                        //                           "requestId": data.requestId
                        //                         }).then((onValue) {
                        //                       // _getRequest();
                        //                     });
                        //                   },
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.symmetric(
                        //                         horizontal: 5),
                        //                     child: CustomCard(
                        //                       child: Column(
                        //                         children: [
                        //                           Row(
                        //                             children: [
                        //                               Expanded(
                        //                                   child: CustomTextItem(
                        //                                       lable: 'ID',
                        //                                       value:
                        //                                           '#${data.requestId}')),
                        //                               Text(dateFormate(
                        //                                   data.createdDate)),
                        //                             ],
                        //                           ),
                        //                           CustomTextInfo(
                        //                               lable: 'SENDER (CA) ',
                        //                               value:
                        //                                   '${data.senderName}(#${data.senderId})'),
                        //                           CustomTextInfo(
                        //                             lable: 'READ STATUS',
                        //                             value: data.readStatus ==
                        //                                     null
                        //                                 ? 'N/A'
                        //                                 : '${data.readStatus}',
                        //                             textStyle:
                        //                                 data.readStatus ==
                        //                                         'READ'
                        //                                     ? AppTextStyle()
                        //                                         .getgreenText
                        //                                     : data.readStatus ==
                        //                                             'UNREAD'
                        //                                         ? AppTextStyle()
                        //                                             .getredText
                        //                                         : AppTextStyle()
                        //                                             .getredText,
                        //                           ),
                        //                           CustomTextInfo(
                        //                             lable: 'DOCUMENT REQUEST',
                        //                             value: '${data.text}',
                        //                             maxLine: 1,
                        //                             inOneLinetext: true,
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 );
                        //               },
                        //             );
                        //     }

                        //     return Container();
                        //   },
                        // ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  // Widget _customcard({required Widget icon, required String lable}) {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Container(
  //       width: double.infinity,
  //       height: 200,
  //       decoration: BoxDecoration(
  //           color: ColorConstants.white,
  //           // ignore: deprecated_member_use
  //           border: Border.all(color: ColorConstants.darkGray.withOpacity(0.5)),
  //           borderRadius: BorderRadius.circular(10)),
  //       child: Stack(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(10),
  //             child: CustomPaint(
  //               size: Size(double.infinity, double.infinity),
  //               painter: DiagonalBackgroundPainter(),
  //             ),
  //           ),
  //           // Content
  //           Padding(
  //             padding: const EdgeInsets.all(50.0),
  //             child: Align(
  //               alignment: Alignment.topLeft,
  //               child: Text(lable, style: AppTextStyle().headingtext),
  //             ),
  //           ),
  //           Align(
  //             alignment: Alignment.bottomRight,
  //             child: Padding(
  //               padding: const EdgeInsets.all(20.0),
  //               child: CircleAvatar(
  //                   backgroundColor: Colors.white, radius: 35, child: icon),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

// Custom Painter for the Diagonal Background
class DiagonalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorConstants.buttonColor
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width, size.height) // Bottom-right corner
      ..lineTo(100, size.height) // Bottom-left corner
      ..lineTo(size.width, 50) // Top-right corner
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
