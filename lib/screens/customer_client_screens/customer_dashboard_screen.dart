import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_drawer.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
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
        title: 'Client',
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
        profileUrl: appLogo,
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
            "imgUrl": Icons.dashboard,
            "label": "Dashboard",
            "onTap": () {
              // context.pop();
            }
          },
          {
            "imgUrl": Icons.add_photo_alternate_outlined,
            "label": "Upload Document",
            "onTap": () {
              // context.pop();
              context.push('/customer_dashboard/upload_document');
            }
          },
          {
            "imgUrl": Icons.history,
            "label": "History",
            "onTap": () {
              context.push('/customer_dashboard/history');
            }
          },
          {
            "imgUrl": Icons.star,
            "label": "Request",
            "onTap": () {
              // context.pop();
              context.push('/customer_dashboard/request');
            }
          },
          {
            "imgUrl": Icons.groups,
            "label": "My CA",
            "onTap": () {
              context.push('/myCa');
            }
          },
          {
            "imgUrl": Icons.payment,
            "label": "Payment",
            "onTap": () {
              context.push('/customer_dashboard/payment');
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  context.push('/customer_dashboard/upload_document');
                },
                child: _customcard(
                    lable: 'Upload Documents',
                    icon: Icon(
                      Icons.format_list_numbered_outlined,
                      size: 35,
                    )),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  context.push('/customer_dashboard/history');
                },
                child: _customcard(
                    lable: 'History',
                    icon: Icon(
                      Icons.history,
                      size: 35,
                    )),
              ),
              SizedBox(height: 10),
              Text(
                'Recent Request',
                style: AppTextStyle().headingtext,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CustomCard(
                    // id: '1',
                    // date: '23/01/2025',
                    // senderCa: 'Vishal Singh',
                    // description: 'fsdfsdf fsdfdfdf fdsdsfdff df',
                    // onTap: () {},
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: CustomTextItem(lable: 'ID', value: '1')),
                            Expanded(
                                child: CustomTextItem(
                                    lable: 'DATE', value: '23/01/2023'))
                          ],
                        ),
                        CustomTextItem(
                            lable: 'SENDER(CA)', value: 'Vishal singh'),
                        CustomTextItem(
                            lable: 'DESCRIPTION',
                            value: 'dhjbjhjdhvjdvjkdsvjjh'),
                        SizedBox(height: 5),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CommonButtonWidget(
                              buttonWidth: 100,
                              buttonheight: 50,
                              buttonTitle: 'View',
                              onTap: () {
                                context.push('/request_details');
                              }),
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _customcard({required Widget icon, required String lable}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
            color: ColorConstants.white,
            // ignore: deprecated_member_use
            border: Border.all(color: ColorConstants.darkGray.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomPaint(
                size: Size(double.infinity, double.infinity),
                painter: DiagonalBackgroundPainter(),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(lable, style: AppTextStyle().headingtext),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                    backgroundColor: Colors.white, radius: 35, child: icon),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
