import 'package:ca_app/screens/ca_screens/all_raise_history/raise_client_screen.dart';
import 'package:ca_app/screens/ca_screens/all_raise_history/raise_team_screen.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';

class AllRaiseHistoryScreen extends StatefulWidget {
  final int id;
  const AllRaiseHistoryScreen({super.key, required this.id});

  @override
  State<AllRaiseHistoryScreen> createState() => _AllRaiseHistoryScreenState();
}

class _AllRaiseHistoryScreenState extends State<AllRaiseHistoryScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'All Raise History',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CommonButtonWidget(
                      buttonTitle: 'Client',
                      buttonColor: selectedIndex == 0
                          ? ColorConstants.buttonColor
                          : ColorConstants.white,
                      tileStyle: selectedIndex == 0
                          ? AppTextStyle().buttontext
                          : AppTextStyle().cardLableText,
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CommonButtonWidget(
                      buttonColor: selectedIndex == 1
                          ? ColorConstants.buttonColor
                          : ColorConstants.white,
                      tileStyle: selectedIndex == 1
                          ? AppTextStyle().buttontext
                          : AppTextStyle().cardLableText,
                      buttonTitle: 'Team',
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              if (selectedIndex == 0)
                Expanded(
                    child: RaiseClientScreen(
                  id: widget.id,
                )),
              if (selectedIndex == 1) Expanded(child: RaiseTeamScreen())
            ],
          ),
        ));
  }
}
