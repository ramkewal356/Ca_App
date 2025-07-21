import 'package:ca_app/blocs/help_and_support/help_and_support_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpAndSupportViewScreen extends StatefulWidget {
  final int contactId;
  const HelpAndSupportViewScreen({super.key, required this.contactId});

  @override
  State<HelpAndSupportViewScreen> createState() =>
      _HelpAndSupportViewScreenState();
}

class _HelpAndSupportViewScreenState extends State<HelpAndSupportViewScreen> {
  @override
  void initState() {
    context
        .read<HelpAndSupportBloc>()
        .add(GetContactByContactIdEvent(contactId: widget.contactId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'View History',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<HelpAndSupportBloc, HelpAndSupportState>(
          builder: (context, state) {
            if (state is GetContactByContactIdLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.buttonColor,
                ),
              );
            } else if (state is HelpAndSupportError) {
              return Center(
                child: Text('No Data Found'),
              );
            } else if (state is GetContactByContactIdSuccess) {
              var data = state.getContactByContactIdModel.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _textItem(
                            lable: 'Id', value: '#${data?.contactId}'),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Response',
                            style: AppTextStyle().hintText,
                          ),
                          SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                                color: data?.response == 'OPEN'
                                    ? ColorConstants.yellowColor
                                    : ColorConstants.greenColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                '${data?.response}',
                                style: AppTextStyle().statustext,
                              ),
                            ),
                          ),
                        ],
                      ))
                     
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: _textItem(
                            lable: 'User Name', value: '${data?.userName}'),
                      ),
                      Expanded(
                        child: _textItem(
                            lable: 'Created Date',
                            value: dateFormate(data?.createdDate)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // _textItem(lable: 'Subject', value: 'Swabi jhjndskjfjk'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _textItem(
                            lable: 'Subject', value: '${data?.subject}'),
                      ),
                      data?.comment != null
                          ? Expanded(
                              child: _textItem(
                                  lable: 'Comment', value: '${data?.comment}'),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Message: ',
                    style: AppTextStyle().hintText,
                  ),
                  SizedBox(height: 5),
                  TextformfieldWidget(
                      readOnly: true,
                      maxLines: 3,
                      minLines: 3,
                      controller:
                          TextEditingController(text: '${data?.message}'),
                      hintText: 'Description'),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
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
