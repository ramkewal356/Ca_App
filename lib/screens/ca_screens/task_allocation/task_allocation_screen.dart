import 'package:ca_app/screens/ca_screens/task_allocation/assign_task_list_screen.dart';
import 'package:ca_app/screens/ca_screens/task_allocation/my_task_list_screen.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';

class TaskAllocationScreen extends StatefulWidget {
  const TaskAllocationScreen({super.key});

  @override
  State<TaskAllocationScreen> createState() => _TaskAllocationScreenState();
}

class _TaskAllocationScreenState extends State<TaskAllocationScreen> {
  int selectedIndex = 0;

  void switchToAssignTaskScreen() {
    setState(() {
      selectedIndex = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Task Allocation',
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
                      buttonTitle: 'Assign Task List',
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
                      buttonTitle: 'My Task List',
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
              if (selectedIndex == 0) Expanded(child: AssignTaskListScreen()),
              if (selectedIndex == 1) Expanded(child: MyTaskListScreen())
            ],
          ),
        ));
  }
}
