import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/custom_dropdown/custom_dropdown_bloc.dart';
import 'package:ca_app/blocs/image_picker/image_picker_bloc.dart';
import 'package:ca_app/blocs/profile/profile_bloc.dart';
import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/data/models/get_services_list_model.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/common_multi_select_dropdown.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_bottomsheet_image_modal.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_phone_field.dart';
import 'package:ca_app/widgets/image_picker.dart';

import 'package:ca_app/widgets/textformfield_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class CaProfileScreen extends StatefulWidget {
  const CaProfileScreen({super.key});

  @override
  State<CaProfileScreen> createState() => _CaProfileScreenState();
}

class _CaProfileScreenState extends State<CaProfileScreen> {
  bool isEditable = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pancardController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _firmController = TextEditingController();
  final TextEditingController _firmAddressController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _icaiMemberController = TextEditingController();

  String? selectedYear;
  String? selectedMonth;
  String? selectedTitle;
  String? selectedGender;

  String countryCode = '91';
  String userProfile = '';
  List<TextEditingController> controllers = [];
  List<String> achievements = [];
  List<Map<String, dynamic>> selectedDegree = [];
  bool _controllersInitialized = false;
// controllers = existingAchievements
//     .map((text) => TextEditingController(text: text))
//     .toList();
  // ignore: unused_field
  late MultiSelectController<ServicesListData> _specializationController;
  List<String> _selectedSpecialization = [];

  @override
  void initState() {
    super.initState();
    addField();
    getUser();
    _fechAllData();
    _specializationController = MultiSelectController<ServicesListData>();
  }

  void addField() {
    setState(() {
      controllers.add(TextEditingController());
      // achievements = controllers.map((toElement) => toElement.text).toList();
    });
  }

  void removeField(int index) {
    setState(() {
      controllers[index].dispose(); // clean up
      controllers.removeAt(index);
      // achievements.removeAt(index);
    });
  }

  void printValues() {
    for (var i = 0; i < controllers.length; i++) {
      debugPrint("Field $i: ${controllers[i].text}");
    }
  }

  Future<void> getUser() async {
    context.read<AuthBloc>().add(GetUserByIdEvent());
  }

  void _fechAllData() {
    context.read<ProfileBloc>().add(GetAllTitleEvent());
    context.read<GetDegreeBloc>().add(GetCaDegreeEvent());
    _fetchService(isSearch: true);
  }

  void _fetchService({bool isSearch = false, bool isPagination = false}) {
    context.read<ServiceBloc>().add(GetCaServiceListEvent(
        isSearch: isSearch,
        searchText: '',
        isPagination: isPagination,
        pageNumber: -1,
        pageSize: -1));
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UpdateUserSuccess) {
          Utils.toastSuccessMessage('Profile Updated Successfully');
          if (mounted) {
            setState(() => isEditable = false); // ✅ triggers AppBar rebuild
          }
          getUser();
        } else if (state is UpdateProfileImgSuccess) {
          context.read<ImagePickerBloc>().add(ResetImagePickerEvent());
          if (mounted) {
            setState(() => isEditable = false); // ✅ triggers AppBar rebuild
          }
          getUser();
        } else if (state is AuthErrorState) {
          if (mounted) {
            setState(() => isEditable = false); // ✅ triggers AppBar rebuild
          }
          getUser();
        }
      },
      child: CustomLayoutPage(
        appBar: CustomAppbar(
          title: 'My Profile',
          backIconVisible: true,
          actionIcons: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isEditable = !isEditable;
                  });
                },
                icon: isEditable
                    ? Icon(
                        Icons.close,
                        color: ColorConstants.white,
                      )
                    : Icon(
                        Icons.edit_square,
                        color: ColorConstants.white,
                      ))
          ],
        ),
        onRefresh: () async {
          getUser();
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) =>
              (current is GetUserLoading || current is GetUserByIdSuccess),
          builder: (context, state) {
            if (state is GetUserLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.buttonColor,
                ),
              );
            } else if (state is GetUserByIdSuccess) {
              var data = state.getUserByIdData?.data;

              // data = state.getUserByIdData?.data;
              userProfile = data?.profileUrl ?? '';
              _firstNameController.text = data?.firstName ?? '';
              _lastNameController.text = data?.lastName ?? '';
              _emailController.text = data?.email ?? '';
              countryCode = data?.countryCode ?? '91';
              _phoneController.text = data?.mobile ?? '';

              _pancardController.text = data?.panCardNumber ?? '';
              _aboutController.text = data?.about ?? '';
              _icaiMemberController.text = data?.icaiMembershipId ?? '';
              _registrationController.text = data?.registrationNumber ?? '';
              selectedTitle = data?.professionalTitle ?? '';
              selectedYear = data?.years ?? '';
              selectedMonth = data?.months ?? '';
              _firmController.text = data?.companyName ?? '';
              _firmAddressController.text = data?.firmAddress ?? '';
              selectedGender = data?.gender ?? '';
              if (!_controllersInitialized) {
                List<String> certs = data?.userCertifications
                        ?.map((e) => e.toString())
                        .toList() ??
                    [];

                controllers = certs.isNotEmpty
                    ? certs.map((e) => TextEditingController(text: e)).toList()
                    : [TextEditingController()];

                _controllersInitialized = true;
              }
              // }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomCard(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cardTitile(
                                icon: Icons.person,
                                title: 'Persional information'),
                            BlocConsumer<ImagePickerBloc, ImagePickerState>(
                              listener: (context, state) {
                                if (state is ImagePickedSuccess) {
                                  context.read<AuthBloc>().add(
                                      UpdateProfileImageEvent(
                                          companyLogo: state.companyImage,
                                          imageUrl: state.imageFile));
                                }
                              },
                              builder: (context, state) {
                                return Center(
                                    child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 4,
                                          color: ColorConstants.white)),
                                  child: ImagePickerWidget(
                                    userImg: userProfile,
                                    initialImage: null,
                                    isEditable: isEditable,
                                  ),
                                ));
                              },
                            ),
                            lableText('First Name'),
                            TextformfieldWidget(
                                readOnly: true,
                                controller: _firstNameController,
                                hintText: 'Enter first name'),
                            SizedBox(height: 10),
                            lableText('Last Name'),
                            TextformfieldWidget(
                                readOnly: true,
                                controller: _lastNameController,
                                hintText: 'Enter last name'),
                            SizedBox(height: 10),
                            lableText('Email Address *'),
                            TextformfieldWidget(
                              readOnly: true,
                              controller: _emailController,
                              hintText: 'Enter email address',
                              validator: (p0) {
                                return ValidatorClass.validateEmail(p0);
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Phone Number *'),
                            CustomPhoneField(
                              readOnly: true,
                              intialCountryCode: countryCode,
                              // focusNode: _focusNode,
                              controller: _phoneController,
                              onChanged: (phone) {
                                debugPrint(
                                    'complete phone number ${phone.completeNumber}');
                              },
                              onCountryChanged: (country) {
                                setState(() {
                                  countryCode = country.dialCode;
                                });
                                debugPrint(
                                    'complete phone number ${country.name}');
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.completeNumber.isEmpty) {
                                  return 'Please enter phone number';
                                } else if (value.completeNumber.length < 10 ||
                                    value.completeNumber.length > 15) {
                                  return 'Please enter a valid phone number';
                                } else {
                                  var isValid = ValidatorClass.isValidMobile(
                                      value.completeNumber);
                                  if (!isValid) {
                                    return 'Please enter a valid phone number';
                                  }
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Gender *'),
                            CustomDropdownButton(
                              hintText: 'Select gender',
                              fillColor: ColorConstants.white,
                              initialValue: selectedGender,
                              dropdownItems: ['Male', 'Female', 'Other'],
                              onChanged: (p0) {
                                setState(() {
                                  selectedGender = p0;
                                  debugPrint('BBNdjhfdhjdhjj$selectedGender');
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select gender';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Pan Number *'),
                            TextformfieldWidget(
                              readOnly: _pancardController.text.isNotEmpty
                                  ? true
                                  : false,
                              controller: _pancardController,
                              hintText: '******',
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'Please enter pan card';
                                } else if (!ValidatorClass.isValidPanCard(p0)) {
                                  return 'Please enter valid pan card';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('About'),
                            TextformfieldWidget(
                              maxLines: 3,
                              minLines: 3,
                              controller: _aboutController,
                              hintText: 'Enter about us',
                            ),
                          ],
                        )),
                        CustomCard(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cardTitile(
                                icon: Icons.person,
                                title: 'Professional Details'),
                            SizedBox(height: 10),
                            lableText('ICAI Membership ID *'),
                            TextformfieldWidget(
                              controller: _icaiMemberController,
                              hintText: 'Enter membership id',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter membership id';
                                } else if (!ValidatorClass.isValidICAI(value)) {
                                  return 'Please enter valid membership id';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Registration Number *'),
                            TextformfieldWidget(
                              controller: _registrationController,
                              hintText: 'Enter registration number',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter registration number';
                                } else if (!ValidatorClass.isValidCARegNumber(
                                    value)) {
                                  return 'Please enter valid registration number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Professional Title *'),
                            BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                                var data = state is GetTitleSuccess
                                    ? state.getAllTitleModel.data
                                    : null;
                                return CustomDropdownButton(
                                  hintText: 'Select title',
                                  fillColor: ColorConstants.white,
                                  initialValue: selectedTitle,
                                  dropdownItems: data
                                          ?.map((toElement) =>
                                              toElement.title.toString())
                                          .toList() ??
                                      [],
                                  onChanged: (p0) {
                                    setState(() {
                                      selectedTitle = p0;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select title';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Years of Experience *'),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Select Year',
                                        style: AppTextStyle().lableText,
                                      ),
                                      BlocProvider(
                                        create: (context) =>
                                            CustomDropdownBloc(),
                                        child: CustomDropdownButton(
                                          // initialStateSelected: true,
                                          dropdownItems:
                                              List.generate(11, (i) => '$i'),
                                          initialValue: selectedYear,
                                          hintText: 'Select years',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select years';
                                            }
                                            return null;
                                          },
                                          onChanged: (p0) {
                                            setState(() {
                                              selectedYear = p0;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Select month',
                                        style: AppTextStyle().lableText,
                                      ),
                                      BlocProvider(
                                        create: (context) =>
                                            CustomDropdownBloc(),
                                        child: CustomDropdownButton(
                                          // initialStateSelected: true,
                                          dropdownItems: List.generate(
                                              12, (i) => '${i + 1}'),
                                          initialValue: selectedMonth,
                                          hintText: 'Select month',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select month';
                                            }
                                            return null;
                                          },
                                          onChanged: (p0) {
                                            setState(() {
                                              selectedMonth = p0;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            lableText('Firm Name *'),
                            TextformfieldWidget(
                              controller: _firmController,
                              hintText: 'Enter firm name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter firm name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Firm Address *'),
                            TextformfieldWidget(
                              maxLines: 3,
                              minLines: 3,
                              controller: _firmAddressController,
                              hintText: 'Enter firm address',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter firm address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Firm Logo *'),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorConstants.darkGray,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomBottomsheetImageModal(
                                        isProfileChange: false,
                                        isEditable: isEditable,
                                        icon: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: ColorConstants.darkGray
                                                  // ignore: deprecated_member_use
                                                  .withOpacity(0.5)),
                                          child: Center(
                                              child: Text(
                                            'Choose File',
                                            style: AppTextStyle().labletext,
                                          )),
                                        )),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                      child: Text(
                                    'No File Choosen',
                                    style: AppTextStyle().cardValueText,
                                  ))
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 100,
                              width: 120,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorConstants.darkGray),
                                  borderRadius: BorderRadius.circular(5)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  data?.companyLogo,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        )),
                        CustomCard(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cardTitile(
                                icon: Icons.settings,
                                title: 'Qualification & Services'),
                            SizedBox(height: 10),
                            lableText('Professional Qualification'),
                            BlocBuilder<GetDegreeBloc, ProfileState>(
                              builder: (context, state) {
                                var qdata = state is GetCaDegreeSuccess
                                    ? state.getCaDegreeListModel.data ?? []
                                    : null;
                                return CommonMultiSelectDropdown(
                                  hint: 'Select qualification',
                                  initialSelected: {
                                    for (final toElement
                                        in data?.caEducations ?? [])
                                      if ((toElement.degree ?? '').isNotEmpty)
                                        toElement.degree!:
                                            toElement.university ?? ''
                                  },
                                  options: qdata
                                          ?.map((toElement) =>
                                              toElement.degreeName.toString())
                                          .toList() ??
                                      [],
                                  onChanged: (qualToUni) {
                                    // do something with the result:
                                    //   { 'Bachelor’s': 'Delhi University', 'PhD': 'IIT Bombay' }
                                    selectedDegree = qualToUni.entries
                                        .map((toElement) => {
                                              "degree": toElement.key,
                                              "university": toElement.value
                                            })
                                        .toList();
                                    debugPrint(qualToUni.toString());
                                    debugPrint(selectedDegree.toString());
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Achievements & Recognition'),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controllers.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: index == controllers.length - 1
                                          ? 0
                                          : 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: TextformfieldWidget(
                                        controller: controllers[index],
                                        hintText: 'Enter achievements',
                                        validator: (p0) {
                                          return null;
                                        },
                                      )),
                                      IconButton(
                                          icon: Icon(
                                              index == controllers.length - 1
                                                  ? Icons.add_circle_outline
                                                  : Icons.remove_circle_outline,
                                              color: index ==
                                                      controllers.length - 1
                                                  ? ColorConstants.greenColor
                                                  : Colors.red),
                                          onPressed: () {
                                            if (controllers[index]
                                                .text
                                                .isNotEmpty) {
                                              if (index ==
                                                  controllers.length - 1) {
                                                addField(); // Add new input
                                                debugPrint(
                                                    'controllerlist,,,,${controllers[index].text}');
                                              } else {
                                                removeField(
                                                    index); // Remove this input
                                              }
                                            }
                                          }),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            lableText('Areas of Specialization'),
                            BlocBuilder<ServiceBloc, ServiceState>(
                              builder: (context, state) {
                                List<ServicesListData> listData =
                                    state is GetCaServiceListSuccess
                                        ? state.getCaServicesList
                                        : [];
                                debugPrint('sddsdddsf,,,,,${listData.length}');
                                return MultiSelectDialogField<ServicesListData>(
                                  initialValue: listData
                                      .where((test) =>
                                          data?.specializations?.any(
                                              (testData) =>
                                                  testData.toString() ==
                                                  test.subService.toString()) ??
                                          false)
                                      .toList(),
                                  items: listData
                                      .map((item) => MultiSelectItem(
                                          item, item.subService ?? ""))
                                      .toList(),
                                  searchable: true,
                                  title: Text(
                                    "Select Specialization",
                                    style: AppTextStyle().cardLableText,
                                  ),
                                  selectedColor: ColorConstants.buttonColor,
                                  dialogWidth:
                                      MediaQuery.of(context).size.width * 0.98,
                                  decoration: BoxDecoration(
                                    color: ColorConstants.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                      color: ColorConstants.darkGray,
                                    ),
                                  ),
                                  buttonIcon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: ColorConstants.darkGray,
                                  ),
                                  buttonText: Text('Select specialization'),
                                  onConfirm: (results) {
                                    _selectedSpecialization = results
                                        .map(((toElement) =>
                                            toElement.subService.toString()))
                                        .toList();
                                    debugPrint(
                                        'cvnvcbncbn $_selectedSpecialization');
                                  },
                                );
                              },
                            ),
                          ],
                        )),
                        isEditable
                            ? BlocBuilder<AuthBloc, AuthState>(
                                buildWhen: (_, curr) =>
                                    curr is AuthLoading ||
                                    curr is UpdateUserSuccess,
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: CommonButtonWidget(
                                      buttonheight: 45,
                                      buttonTitle: 'Save & Update',
                                      loader: state is AuthLoading,
                                      onTap: () {
                                        achievements = controllers
                                            .map((controller) =>
                                                controller.text.trim())
                                            .where((text) => text.isNotEmpty)
                                            .toList();
                                        Map<String, dynamic> body = {
                                          "userId": data?.id,
                                          "firstname":
                                              _firstNameController.text,
                                          "lastname": _lastNameController.text,
                                          "email": _emailController.text,
                                          "mobile": _phoneController.text,
                                          "panCardNumber":
                                              _pancardController.text,
                                          "about": _aboutController.text,
                                          "icaiMembershipId":
                                              _icaiMemberController.text,
                                          "registrationNumber":
                                              _registrationController.text,
                                          "professionalTitle": selectedTitle,
                                          "years": selectedYear,
                                          "months": selectedMonth,
                                          "companyName": _firmController.text,
                                          "firmAddress":
                                              _firmAddressController.text,
                                          "educations": selectedDegree,
                                          "certifications": [
                                            ...controllers.map(
                                                (toElement) => toElement.text)
                                          ],
                                          "specializations":
                                              _selectedSpecialization
                                        };

                                        debugPrint(
                                            "Achievements: $achievements");
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthBloc>().add(
                                              UpdateCaProfileEvent(body: body));
                                        }
                                      },
                                    ),
                                  );
                                },
                              )
                            : SizedBox.shrink(),
                        SizedBox(height: 5)
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  cardTitile({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(
          icon,
          color: ColorConstants.buttonColor,
        ),
        SizedBox(width: 5),
        Text(
          title,
          style: AppTextStyle().textButtonStyle,
        )
      ],
    );
  }

  lableText(String lable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        lable,
        style: AppTextStyle().textCardStyle,
      ),
    );
  }
}

class User {
  final String name;
  final int id;

  User({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}
