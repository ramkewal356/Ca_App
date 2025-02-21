
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
        userName: 'xyz',
        emailAddress: 'xyz@gmail.com',
        profileUrl: '',
        activeButton: true,
        activeTex: 'Active',
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
              // context.pop();
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
            "imgUrl": Icons.miscellaneous_services_outlined,
            "label": "My Services",
            "onTap": () {
              context.push('/subca_dashboard/my_service');
            }
          },
          {
            "imgUrl": Icons.info,
            "label": "My CA",
            "onTap": () {
              context.push('/myCa');
            }
          },
          {
            "imgUrl": Icons.person_outlined,
            "label": "My Clients",
            "onTap": () {
              context.push('/subca_dashboard/my_client');
            }
          },
          {
            "imgUrl": Icons.task_outlined,
            "label": "My Task",
            "onTap": () {
              context.push('/subca_dashboard/my_task');
            }
          },
          {
            "imgUrl": Icons.star,
            "label": "Raise Request",
            "onTap": () {
              context.push('/raise_request', extra: {'role': 'SUBCA'});
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
                              Icons.miscellaneous_services_outlined,
                              color: ColorConstants.white,
                            ),
                            total: '0',
                            lable: 'Services',
                          ),
                          DashboardCard(
                            icon: Icon(
                              Icons.groups,
                              color: ColorConstants.white,
                            ),
                            total: '0',
                            lable: 'Clients',
                          ),
                          DashboardCard(
                            icon: Icon(
                              Icons.task,
                              color: ColorConstants.white,
                            ),
                            total: '0',
                            lable: 'Task',
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
                              buttonTitle: 'View All',
                              onTap: () {
                                context.push('/subca_dashboard/my_client');
                              })
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  horizontalTitleGap: 10,
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
                  CustomTextButton(
                      buttonTitle: 'View All',
                      onTap: () {
                        context.push('/recent_document');
                      })
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
