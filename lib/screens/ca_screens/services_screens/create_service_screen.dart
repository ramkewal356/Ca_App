import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final TextEditingController _servicecontroller = TextEditingController();
  final TextEditingController _subservicecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text('Service Name', style: AppTextStyle().labletext),
        SizedBox(height: 5),
        TextformfieldWidget(
            fillColor: ColorConstants.white,
            controller: _servicecontroller,
            hintText: 'Please enter your service name'),
        SizedBox(height: 10),
        Text('Sub-Service Name', style: AppTextStyle().labletext),
        SizedBox(height: 5),
        TextformfieldWidget(
            fillColor: ColorConstants.white,
            controller: _subservicecontroller,
            hintText: 'Please enter your sub service'),
        SizedBox(height: 10),
        Text('Service Description', style: AppTextStyle().labletext),
        SizedBox(height: 5),
        TextformfieldWidget(
            fillColor: ColorConstants.white,
            maxLines: 3,
            minLines: 3,
            controller: _descriptioncontroller,
            hintText: 'Please enter your service description'),
        SizedBox(height: 15),
        CommonButtonWidget(
          buttonTitle: 'SEND',
          onTap: () {},
        )
      ],
    );
  }
}
