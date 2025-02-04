import 'package:ca_app/screens/ca_screens/services_screens/create_service_screen.dart';
import 'package:ca_app/screens/ca_screens/services_screens/service_screen1.dart';
import 'package:ca_app/screens/ca_screens/services_screens/view_previous_screen.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<String> tabList = ['Services', 'Create New Services', 'View Services'];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Services',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 55,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListView.builder(
                    itemCount: tabList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: ColorConstants.buttonColor),
                              color: selectedIndex == index
                                  ? ColorConstants.buttonColor
                                  : ColorConstants.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            tabList[index],
                            style: selectedIndex == index
                                ? AppTextStyle().smallbuttontext
                                : AppTextStyle().menuUnselectedText,
                          )),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Divider(),
              if (selectedIndex == 0) Expanded(child: ServiceScreen1()),
              if (selectedIndex == 1) Expanded(child: CreateServiceScreen()),
              if (selectedIndex == 2) Expanded(child: ViewPreviousScreen()),
            ],
          ),
        ));
  }
}
