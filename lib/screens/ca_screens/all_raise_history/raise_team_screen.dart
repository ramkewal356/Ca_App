import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';

class RaiseTeamScreen extends StatefulWidget {
  const RaiseTeamScreen({super.key});

  @override
  State<RaiseTeamScreen> createState() => _RaiseTeamScreenState();
}

class _RaiseTeamScreenState extends State<RaiseTeamScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchField(
            controller: _searchController, serchHintText: 'search'),
        Expanded(
          child: ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) {
              return CustomCard(
                  child: Column(
                children: [
                  CustomTextInfo(
                      flex1: 2, flex2: 3, lable: 'ID', value: '#234'),
                  CustomTextInfo(
                      flex1: 2,
                      flex2: 3,
                      lable: 'CLIENT(RECEIVER)',
                      value: '#234'),
                  CustomTextInfo(
                      flex1: 2, flex2: 3, lable: 'CA(SENDER)', value: '#234'),
                  CustomTextInfo(
                      flex1: 2, flex2: 3, lable: 'DATE', value: '#234'),
                  CustomTextInfo(
                      flex1: 2, flex2: 3, lable: 'DESCRIPTION', value: '#234'),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CommonButtonWidget(
                      buttonWidth: 100,
                      buttonTitle: 'View',
                      onTap: () {},
                    ),
                  )
                ],
              ));
            },
          ),
        )
      ],
    );
  }
}
