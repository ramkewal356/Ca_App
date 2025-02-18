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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _servicecontroller = TextEditingController();
  final TextEditingController _subservicecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text('Service Name', style: AppTextStyle().labletext),
          SizedBox(height: 5),
          TextformfieldWidget(
            fillColor: ColorConstants.white,
            controller: _servicecontroller,
            hintText: 'Please enter your service name',
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return 'Please enter your service name';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Text('Sub-Service Name', style: AppTextStyle().labletext),
          SizedBox(height: 5),
          TextformfieldWidget(
            fillColor: ColorConstants.white,
            controller: _subservicecontroller,
            hintText: 'Please enter your sub service',
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return 'Please enter your sub service';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Text('Service Description', style: AppTextStyle().labletext),
          SizedBox(height: 5),
          TextformfieldWidget(
            fillColor: ColorConstants.white,
            maxLines: 3,
            minLines: 3,
            controller: _descriptioncontroller,
            hintText: 'Please enter your service description',
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return 'Please enter your service description';
              }
              return null;
            },
          ),
          SizedBox(height: 15),
          CommonButtonWidget(
            buttonTitle: 'SEND',
            onTap: () {
              if (_formKey.currentState!.validate()) {}
            },
          )
        ],
      ),
    );
  }
}
