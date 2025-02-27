// import 'package:ca_app/blocs/auth/auth_bloc.dart';
// import 'package:ca_app/blocs/auth/auth_state.dart';
// import 'package:ca_app/utils/constanst/colors.dart';
// import 'package:ca_app/utils/constanst/text_style.dart';
// import 'package:ca_app/utils/constanst/validator.dart';
// import 'package:ca_app/widgets/common_button_widget.dart';
// import 'package:ca_app/widgets/custom_appbar.dart';
// import 'package:ca_app/widgets/custom_dropdown_button.dart';
// import 'package:ca_app/widgets/custom_layout.dart';
// import 'package:ca_app/widgets/custom_phone_field.dart';
// import 'package:ca_app/widgets/custom_search_location.dart';
// import 'package:ca_app/widgets/image_picker.dart';
// import 'package:ca_app/widgets/textformfield_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';


// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _pancardController = TextEditingController();
//   final TextEditingController _adharcardController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();

//   String countryCode = '91';
//   String? selectedValue;
//   @override
//   void initState() {
//     _locationController.text = 'Padrauna, Uttar Pradesh, India';
//     _firstNameController.text = 'Vishal';
//     _lastNameController.text = 'Singh';
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomLayoutPage(
//       appBar: CustomAppbar(
//         title: 'My Profile',
//         backIconVisible: true,
//       ),
//       child: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
              
//                 Center(
//                     child: ImagePickerWidget(
//                   userImg: '',
//                   initialImage: null,
//                   onImagePicked: (value) {
//                     debugPrint('dfdgsfdghsfdgsdgh ,,,,,,${value.toString()}');
//                   },
//                 )),
//                 SizedBox(height: 20),
//                 Text('First Name', style: AppTextStyle().labletext),
//                 SizedBox(height: 5),
//                 TextformfieldWidget(
//                     readOnly: true,
//                     controller: _firstNameController,
//                     hintText: 'First name'),
//                 SizedBox(height: 10),
//                 Text('Last Name', style: AppTextStyle().labletext),
//                 SizedBox(height: 5),
//                 TextformfieldWidget(
//                     readOnly: true,
//                     controller: _lastNameController,
//                     hintText: 'Last name'),
//                 SizedBox(height: 10),
//                 Text('Email', style: AppTextStyle().labletext),
//                 SizedBox(height: 5),
//                 TextformfieldWidget(
//                   readOnly: true,
//                   fillColor: ColorConstants.white,
//                   keyboardType: TextInputType.emailAddress,
//                   controller: _emailController,
//                   hintText: 'Enter email id',
//                   // validator: (email) {
//                   //   return ValidatorClass.validateEmail(email);
//                   // },
//                 ),
//                 SizedBox(height: 10),
//                 Text('Mobile No', style: AppTextStyle().labletext),
//                 SizedBox(height: 5),
//                 CustomPhoneField(
//                   readOnly: true,
//                   intialCountryCode: countryCode,
//                   // focusNode: _focusNode,
//                   controller: TextEditingController(text: '9917823234'),
//                   onChanged: (phone) {
//                     debugPrint('complete phone number ${phone.completeNumber}');
//                   },
//                   onCountryChanged: (country) {
//                     setState(() {
//                       countryCode = country.dialCode;
//                     });
//                     debugPrint('complete phone number ${country.name}');
//                   },
//                   validator: (value) {
//                     if (value == null || value.completeNumber.isEmpty) {
//                       return 'Please enter phone number';
//                     } else if (value.completeNumber.length < 10 ||
//                         value.completeNumber.length > 15) {
//                       return 'Please enter a valid phone number';
//                     } else {
//                       var isValid =
//                           ValidatorClass.isValidMobile(value.completeNumber);
//                       if (!isValid) {
//                         return 'Please enter a valid phone number';
//                       }
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 Text('Select Gender', style: AppTextStyle().labletext),
//                 SizedBox(height: 5),
//                 CustomDropdownButton(
//                   hintText: 'Select gender',
//                   fillColor: ColorConstants.white,
//                   initialValue: selectedValue,
//                   dropdownItems: ['male', 'female', 'other'],
//                   onChanged: (p0) {
//                     setState(() {
//                       selectedValue = p0;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select gender';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 Text('Pan Card', style: AppTextStyle().labletext),
//                 SizedBox(height: 5),
//                 TextformfieldWidget(
//                     controller: _pancardController, hintText: '******'),
//                 SizedBox(height: 10),
//                 Text('Aadhar Card', style: AppTextStyle().labletext),
//                 SizedBox(height: 5),
//                 TextformfieldWidget(
//                     controller: _adharcardController,
//                     hintText: 'xxx-xxxx-yyyyy'),
//                 SizedBox(height: 10),
//                 Text('Location', style: AppTextStyle().labletext),
//                 SizedBox(height: 5),
//                 CustomSearchLocation(
//                     controller: _locationController,
//                     state: '',
//                     hintText: 'Select location'),
//                 SizedBox(height: 10),
//                 SizedBox(height: 20),
//                 BlocConsumer<AuthBloc, AuthState>(
//                   listener: (context, state) {
//                     // if (state is RegisterSuccess) {
//                     //   context.push('/login');
//                     // }
//                   },
//                   builder: (context, state) {
//                     return CommonButtonWidget(
//                         // loader: state is RegisterLoading,
//                         buttonTitle: 'Save & Update',
//                         onTap: () {
//                           debugPrint('selected Value $countryCode');
//                           debugPrint('phone number ${_phoneController.text}');

//                           if (_formKey.currentState!.validate()) {}
//                         });
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
