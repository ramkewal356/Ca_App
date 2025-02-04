import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequestDetailsScreen extends StatefulWidget {
  const RequestDetailsScreen({super.key});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'Request Details',
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
                    child:
                        _textItem(lable: 'CA(Sender)', value: 'Vishal Kumar'),
                  ),
                  Expanded(
                    child:
                        _textItem(lable: 'Documents Name', value: 'GST return'),
                  )
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Desciption : ',
                style: AppTextStyle().hintText,
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
              CommonButtonWidget(
                  buttonTitle: 'Upload Document',
                  onTap: () {
                    context.push('/customer_dashboard/upload_document');
                  })
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
          style: AppTextStyle().hintText,
        ),
        Text(
          value,
          style: AppTextStyle().cardValueText,
        )
      ],
    );
  }
}
