import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/ca_custom_card.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_drawer.dart';
import 'package:ca_app/widgets/custom_text_button.dart';
import 'package:ca_app/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CaDashboardScreen extends StatefulWidget {
  const CaDashboardScreen({super.key});

  @override
  State<CaDashboardScreen> createState() => _CaDashboardScreenState();
}

class _CaDashboardScreenState extends State<CaDashboardScreen> {
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
  Widget build(BuildContext context) {
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
        userName: 'Vishal Yadav',
        emailAddress: 'xyz@gmail.com',
        profileUrl: appLogo,
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
              // context.pop();
            }
          },
          {
            "imgUrl": Icons.miscellaneous_services_outlined,
            "label": "Services",
            "onTap": () {
              context.push('/ca_dashboard/services');
            }
          },
          {
            "imgUrl": Icons.add_photo_alternate_outlined,
            "label": "Recent Document",
            "onTap": () {
              context.push('/recent_document');
            }
          },
          {
            "imgUrl": Icons.group,
            "label": "My Clients",
            "onTap": () {
              // context.pop();
            }
          },
          {
            "imgUrl": Icons.groups_3,
            "label": "Team Members",
            "onTap": () {
              // context.pop();
            }
          },
          {
            "imgUrl": Icons.help,
            "label": "Customer Allocation",
            "onTap": () {
              // context.pop();
            }
          },
          {
            "imgUrl": Icons.task,
            "label": "Task Allocation",
            "onTap": () {
              // context.pop();
            }
          },
          {
            "imgUrl": Icons.star,
            "label": "Raise Request",
            "onTap": () {
              context.push('/raise_request', extra: {'role': 'CA'});
            }
          },
          {
            "imgUrl": Icons.history_edu,
            "label": "All Raise History",
            "onTap": () {
              // context.pop();
            }
          },
          {
            "imgUrl": Icons.account_circle_outlined,
            "label": "My Profile",
            "onTap": () {
              // context.pop();
            }
          },
          {
            "imgUrl": Icons.help_sharp,
            "label": "Help & Support",
            "onTap": () {
              // context.pop();
              context.push('/help&support', extra: true);
            }
          },
          {
            "imgUrl": Icons.history_sharp,
            "label": "Logs History",
            "onTap": () {
              // context.pop();
            }
          },
        ],
      ),
      body: SingleChildScrollView(
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
                          DashboardCard(
                            icon: Icon(
                              Icons.groups_3,
                              color: ColorConstants.white,
                            ),
                            total: '0',
                            lable: 'Total Client',
                          ),
                          DashboardCard(
                            icon: Icon(
                              Icons.groups,
                              color: ColorConstants.white,
                            ),
                            total: '0',
                            lable: 'Team Member',
                          ),
                          DashboardCard(
                            icon: Icon(
                              Icons.format_list_numbered_outlined,
                              color: ColorConstants.white,
                            ),
                            total: '0',
                            lable: 'Services Opted',
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
                      color: ColorConstants.darkGray.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 300,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Client',
                            style: AppTextStyle().subheadingtext,
                          ),
                          CustomTextButton(
                              buttonTitle: 'View All', onTap: () {})
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: ColorConstants.buttonColor,
                                    child: Text(
                                      'AP',
                                      style: AppTextStyle().buttontext,
                                    ),
                                  ),
                                  title: Text('Abhay Pratap',
                                      style: AppTextStyle().textButtonStyle),
                                  subtitle: Text('ramkewal1234@gmail.com'),
                                  trailing: Text('23/01/2025'),
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
                  CustomTextButton(buttonTitle: 'View All', onTap: () {})
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CaCustomCard(
                      id: '1',
                      clintName: 'vishal',
                      date: '23/01/2025',
                      catogory: 'mnkn',
                      document: 'mfmd,m',
                      download: 'm,mm,m',
                      onReRequestTap: () {},
                      onTap: () {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
