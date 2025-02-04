// ignore_for_file: deprecated_member_use

import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class CustomPhoneField extends StatefulWidget {
  final String? intialCountryCode;
  final FocusNode? focusNode;
  final Function(PhoneNumber)? onChanged;
  final Function(Country)? onCountryChanged;
  final String? Function(PhoneNumber?)? validator;
  final TextEditingController controller;
  final bool readOnly;

  const CustomPhoneField({
    super.key,
    required this.intialCountryCode,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onCountryChanged,
    this.validator,
    this.readOnly = false,
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  String initialCountryCode = '91';
  var _phoneKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        var list = countries
            .where((code) => code.dialCode == widget.intialCountryCode)
            .toList();
        if (list.isNotEmpty) {
          // controllers[4].text = list.first.dialCode;
          initialCountryCode = list.first.code;
          //  = list.first.code;
          debugPrint('isocode.................... ${list.first.code}');
        }
        _phoneKey = GlobalKey();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<PhoneNumber>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        initialValue: PhoneNumber(
            countryCode: '+${widget.intialCountryCode}',
            countryISOCode: initialCountryCode,
            number: widget.controller.text),
        builder: (fieldState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntlPhoneField(
                key: _phoneKey,
                controller: widget.controller,
                // style: AppTextStyle.hintText,
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                initialCountryCode: initialCountryCode,
                readOnly: widget.readOnly,
                keyboardType: TextInputType.phone,
                showCountryFlag: true,
                showCursor: !widget.readOnly,
                dropdownIconPosition: IconPosition.trailing,
                // dropdownIcon: Icon(
                //   Icons.arrow_drop_down,
                //   color: ColorConstants.darkGray,
                // ),
                disableLengthCheck: true,
                flagsButtonPadding: EdgeInsets.only(left: 10),
                // dropdownTextStyle: AppTextStyle.hintText,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  filled: widget.readOnly,
                  fillColor: widget.readOnly
                      ? ColorConstants.buttonColor.withOpacity(0.1)
                      : ColorConstants.white,
                  hintStyle: AppTextStyle().hintText,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: ColorConstants.darkGray,
                      // width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: ColorConstants.darkGray,
                      // width: 2.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: ColorConstants.darkGray,
                      // width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: ColorConstants.darkGray,
                      // width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: ColorConstants.darkGray,
                      // color: redColor,
                      // width: 2.0,
                    ),
                  ),
                  errorStyle: TextStyle(
                    // color: ColorConstants.redColor,
                    fontSize: 13,
                  ),
                ),
                // initialValue:
                //     '${widget.intialCountryCode}${widget.controller.text}',
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  fieldState.didChange(value);
                },
                onCountryChanged: widget.onCountryChanged,
                // validator: (value) => widget.validator?.call(value),
              ),
              if (fieldState.hasError) ...[
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    fieldState.errorText!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red[900],
                    ),
                  ),
                ),
              ],
            ],
          );
        });
  }
}
