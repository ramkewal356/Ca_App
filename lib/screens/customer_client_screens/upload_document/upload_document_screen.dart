import 'package:ca_app/screens/customer_client_screens/upload_document/document_screen.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
        appBar: CustomAppbar(backIconVisible: true, title: 'Upload Document'),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: RadioListTile(
                      dense: true,
                      activeColor: ColorConstants.buttonColor,
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      value: 1,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                      title: Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Text(
                            'General Documents',
                            style: AppTextStyle().listTileText,
                          ))),
                ),
                Expanded(
                  child: RadioListTile(
                      dense: true,
                      activeColor: ColorConstants.buttonColor,
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      value: 2,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                      title: Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Text(
                            'Service Documents',
                            style: AppTextStyle().listTileText,
                          ))),
                ),
              ],
            ),
            if (selectedValue == 1) Expanded(child: GeneralDocument()),
            if (selectedValue == 2) Expanded(child: ServiceDocument())
          ],
        ));
  }
}

class GeneralDocument extends StatelessWidget {
  const GeneralDocument({super.key});

  @override
  Widget build(BuildContext context) {
    return DocumentScreen(
      serviceVisible: false,
    );
  }
}

class ServiceDocument extends StatelessWidget {
  const ServiceDocument({super.key});

  @override
  Widget build(BuildContext context) {
    return DocumentScreen(
      serviceVisible: true,
    );
  }
}
