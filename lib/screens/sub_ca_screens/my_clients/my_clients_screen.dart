import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_item.dart';
import 'package:flutter/material.dart';

class MyClientsScreen extends StatefulWidget {
  const MyClientsScreen({super.key});

  @override
  State<MyClientsScreen> createState() => _MyClientsScreenState();
}

class _MyClientsScreenState extends State<MyClientsScreen> {
  final TextEditingController _serchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'My Clients',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CustomSearchField(
                controller: _serchController,
                serchHintText: 'search..by id ,service name,subservice name'),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CustomCard(
                      child: Column(
                    children: [
                      CustomTextItem(lable: 'ID', value: '#123'),
                      CustomTextItem(
                          lable: 'SERVICE NAME', value: 'GST service'),
                      CustomTextItem(
                          lable: 'SUBSERVICE NAME', value: 'gst number'),
                      CustomTextItem(
                          lable: 'CREATE DATE/TIME',
                          value: '04/02/2025 / 11:19'),
                      CustomTextItem(
                          lable: 'SERVICE DESCRIPTIONS',
                          value:
                              '#1 jhcjdcjhchjd bhjbjjdn hjkjknd hdjkdkjjkd jh'),
                    ],
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
