import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/widgets/ca_subca_custom_widget/custom_recent_document.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';

class RecentDocumentScreen extends StatefulWidget {
  const RecentDocumentScreen({super.key});

  @override
  State<RecentDocumentScreen> createState() => _RecentDocumentScreenState();
}

class _RecentDocumentScreenState extends State<RecentDocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      bgColor: ColorConstants.white,
      appBar: CustomAppbar(
        title: 'Recent Document',
        backIconVisible: true,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ListView.builder(
                itemCount: 6,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CustomCard(
                      child: CustomRecentDocument(
                    id: '#123',
                    clientName: 'vinay',
                    documentName: 'chjdgchjdgcds',
                    category: 'hdgfhjsdghj',
                    subCategory: 'dfjhdhjdhj',
                    postedDate: 'jdfhhjdfhjsdhjf',
                    onTapDownload: () {},
                    onTapReRequest: () {},
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
