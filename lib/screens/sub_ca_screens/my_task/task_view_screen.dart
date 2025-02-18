import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';

class TaskViewScreen extends StatefulWidget {
  const TaskViewScreen({super.key});

  @override
  State<TaskViewScreen> createState() => _TaskViewScreenState();
}

class _TaskViewScreenState extends State<TaskViewScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Task Details',
          backIconVisible: true,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Documents',
                    style: AppTextStyle().labletext,
                  ),
                  SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: ColorConstants.buttonColor,
                        shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        '0',
                        style: AppTextStyle().smallbuttontext,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: _textItem(lable: 'Id', value: '#243'),
                  ),
                  Expanded(
                    child:
                        _textItem(lable: 'Created Date', value: '28/01/2025'),
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _textItem(lable: 'CA Name', value: 'Vishal Kumar'),
                  ),
                  Expanded(
                    child: _textItem(lable: 'Priority', value: 'GST return'),
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child:
                        _textItem(lable: 'Client Email', value: 'Vishal Kumar'),
                  ),
                  Expanded(
                    child: _textItem(lable: 'Client No', value: 'GST return'),
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: _textItem(
                        lable: 'Assigned Clients', value: 'Vishal Kumar'),
                  ),
                  Expanded(
                    child: _textItem(lable: 'Name', value: 'GST return'),
                  )
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Desciption : ',
                style: AppTextStyle().cardValueText,
              ),
              SizedBox(height: 5),
              TextformfieldWidget(
                  readOnly: true,
                  maxLines: 3,
                  minLines: 3,
                  controller:
                      TextEditingController(text: 'fvfdvfdvfv ffsdfffsdfsdff'),
                  hintText: 'Description'),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  _textItem({required String lable, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: AppTextStyle().cardValueText,
        ),
        Text(
          value,
          style: AppTextStyle().cardLableText,
        )
      ],
    );
  }
}
