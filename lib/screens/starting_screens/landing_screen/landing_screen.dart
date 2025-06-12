import 'dart:math';

import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/blocs/team_member/team_member_bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/screens/starting_screens/landing_screen/search_service_widget.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/common_button_widget.dart';

import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_drawer.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_search_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  String searchText = '';
  bool isLogin = false;
  int? serviceId;
  @override
  void initState() {
    super.initState();
    _isLoggin();
    _getActiveCaList();
  }

  void _getActiveCaList() {
    context.read<TeamMemberBloc>().add(GetActiveCaWithServiceEvent());
  }

  void _isLoggin() async {
    String? token = await SharedPrefsClass().getToken();

    if (token != null) {
      isLogin = true;
      _getUser();
    }
  }

  void _getUser() {
    BlocProvider.of<AuthBloc>(context).add(GetUserByIdEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        UserModel? userdata =
            state is GetUserByIdSuccess ? state.getUserByIdData : null;
        return Scaffold(
          backgroundColor: ColorConstants.white,
          appBar: CustomAppbar(
            // backIconVisible: true,
            bgColor: ColorConstants.white,
            centerIcon: Image.asset(
              splashLogo,
              height: 40,
            ),
            backIcon: Builder(builder: (BuildContext context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: ColorConstants.white,
                  ));
            }),
            // time: '${getLocalizedGreeting()}, ',
            title: 'Client',
            actionIcons: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Image.asset(
              //     appLogo,
              //     width: 80,
              //     color: ColorConstants.white,
              //   ),
              // ),
              IconButton(
                  visualDensity: VisualDensity(horizontal: -4),
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_outlined,
                    // color: ColorConstants.white,
                  )),
              IconButton(
                  visualDensity: VisualDensity(horizontal: -4),
                  onPressed: () {},
                  icon: Icon(
                    Icons.account_circle_outlined,
                    // color: ColorConstants.white,
                  )),
            ],
          ),
          drawer: CustomDrawer(
            isLogin: isLogin,
            userName:
                '${userdata?.data?.firstName ?? ""} ${userdata?.data?.lastName ?? ''}',
            lastLogin: userdata?.data?.lastLogin ?? '',
            emailAddress: userdata?.data?.email ?? 'xyz@gmail.com',
            profileUrl: '${userdata?.data?.profileUrl ?? ""}',
            menuItems: [
              {
                "imgUrl": Icons.dashboard,
                "label": "Dashboard",
                "onTap": () {
                  // _getUser();
                }
              },
              {
                "imgUrl": Icons.account_circle_outlined,
                "label": "My Profile",
                "onTap": () {
                  context.push('/myProfile');
                }
              },
              {
                "imgUrl": Icons.help_sharp,
                "label": "Help & Support",
                "onTap": () {
                  context.push('/help&support', extra: true);
                }
              },
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  padding: EdgeInsets.only(left: 10, right: 60),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: Image.asset(landingTopImg).image,
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        'Expert Financial Solutions for Your Business',
                        style: AppTextStyle().landingTopTitle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 100),
                        child: Text(
                          'CABA offers professional chartered accountant services to help you navigate financial complexities with confidence.',
                          style: AppTextStyle().landingSubTitle,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 150,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: ColorConstants.buttonColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Our Services',
                              style: AppTextStyle().smallbuttontext,
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: ColorConstants.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: CustomCard(
                      child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: CustomSearchLocation(
                              prefixIcon: Icon(
                                Icons.location_on_outlined,
                                color: ColorConstants.darkGray,
                              ),
                              controller: _locationController,
                              state: '',
                              hintText: 'Location'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                          child: SizedBox(
                        height: 40,
                        child: SearchServiceWidget(
                          controller: _controller,
                          hintText: 'Service',
                          serviceController: _locationController,
                          onServiceSelected: (id) {
                            serviceId = id;
                          },
                        ),
                      )),
                      // Expanded(
                      //     child: SizedBox(
                      //   height: 40,
                      //   child: CustomSearchField(
                      //       borderRadius: 5.0,
                      //       // ignore: deprecated_member_use
                      //       borderColor: ColorConstants.darkGray.withOpacity(0.5),
                      //       prefixIcon: Icon(
                      //         Icons.dns_outlined,
                      //         color: ColorConstants.darkGray,
                      //       ),
                      //       controller: _controller,
                      //       serchHintText: 'Services'),
                      // )),
                      SizedBox(width: 8),
                      CommonButtonWidget(
                        borderRadius: 5,
                        buttonWidth: 80,
                        buttonheight: 40,
                        buttonTitle: 'Search',
                        onTap: () {
                          if (_controller.text.isEmpty ||
                              _controller.text == '') {
                            Utils.toastErrorMessage('Please select service');
                          } else {
                            context.push('/ca_search',
                                extra: {"serviceId": serviceId});
                          }
                        },
                      )
                    ],
                  )),
                ),
                Text(
                  'Expert Chartered Accountants',
                  style: AppTextStyle().landingAccountTitle,
                ),
                Text(
                  'Connect with our specialized teams of certified professionals across different expertise areas',
                  style: AppTextStyle().landingSubTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                BlocBuilder<TeamMemberBloc, TeamMemberState>(
                  builder: (context, state) {
                    if (state is GetActiveCaWithServiceSuccess) {
                      var caData =
                          state.getActiveCaWithServicesModel.data?.content ??
                              [];
                      return SizedBox(
                        height: 315,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: caData.length,
                          itemBuilder: (context, index) {
                            var data = caData[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 10 : 0, right: 10),
                              child: cacard(
                                  image: clientImg,
                                  title: '${data.firstName} ${data.lastName}',
                                  subtilte: 'Tax Planning & Compliance',
                                  subtitle2:
                                      'Specialized in corporate tax, GST, and regulatory compliance',
                                  totalCa: '45',
                                  viewAllOnTap: () {},
                                  allCaOnTap: () {},
                                  rating: '4.7'),
                            );
                          },
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: ColorConstants.buttonColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View All Chartered Accountants',
                        style: AppTextStyle().smallbuttontext,
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: ColorConstants.white,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: double.infinity,

                  // ignore: deprecated_member_use
                  color: ColorConstants.buttonColor.withOpacity(0.1),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Ours Services',
                        style: AppTextStyle().landingAccountTitle,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: Text(
                          'CABA offers a wide range of professional accounting services to help your business thrive financially.',
                          style: AppTextStyle().landingSubTitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          itemCount: 6,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 10 : 0, right: 10),
                              child: SizedBox(
                                width: 200,
                                child: CustomCard(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: ColorConstants.buttonColor
                                              // ignore: deprecated_member_use
                                              .withOpacity(0.5)),
                                      child: Icon(Icons.privacy_tip_outlined),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Auditing & Security',
                                      style: AppTextStyle().labletext,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Comprehensive auditing services to ensure financial accuracy and security for your business operations.',
                                      style: AppTextStyle().landingSubTitle,
                                    )
                                  ],
                                )),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  color: ColorConstants.buttonColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Get 3 Months Free Financial Advisory',
                        style: AppTextStyle().buttontext,
                      ),
                      Text(
                        'Sign up for our annual business accounting package and receive 3 months of complimentary financial advisory services worth \$1,500.',
                        style: AppTextStyle().landingSubtitletext22,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            size: 18,
                            color: ColorConstants.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Offer ends in 30 days',
                            style: AppTextStyle().landingSubtitletext22,
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.percent,
                            size: 18,
                            color: ColorConstants.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Save up to 25% on annual packages',
                            style: AppTextStyle().landingSubtitletext22,
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 120,
                        height: 35,
                        decoration: BoxDecoration(
                            color: ColorConstants.white,
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Learn More',
                              style: AppTextStyle().textMediumButtonStyle,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 18,
                              // ignore: deprecated_member_use
                              color:
                                  ColorConstants.buttonColor.withOpacity(0.7),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: ColorConstants.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "What You'll Get",
                                    style: AppTextStyle().labletext,
                                  ),
                                  buildFeature("Monthly Financial Review",
                                      "Comprehensive analysis of your business finances"),
                                  buildFeature("Tax Planning Strategy",
                                      "Personalized tax optimization recommendations"),
                                  buildFeature("Growth Consultation",
                                      "Expert advice on scaling your business"),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: ColorConstants.darkGray
                                                // ignore: deprecated_member_use
                                                .withOpacity(0.5))),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text("Regular Price",
                                              style: AppTextStyle()
                                                  .landinghinttext),
                                          Text("\$1,500",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                          Text("Special Offer",
                                              style: AppTextStyle()
                                                  .landinghinttext),
                                          Text("FREE",
                                              style:
                                                  AppTextStyle().getgreenText),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: -10,
                              right: -15,
                              child: Transform.rotate(
                                angle: pi / 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Color(0xFF03364E),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    'Save Rs 1500',
                                    style: AppTextStyle().checkboxTitle,
                                  ),
                                ),
                              ))
                        ],
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      'Why Choose CABA?',
                      style: AppTextStyle().headingtext,
                    ),
                    Text(
                      'We Combine expertise, and innovation to deliver exceptional financial services that help your business thrive.',
                      style: AppTextStyle().landingSubTitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          buildInfoCard(
                            icon: Icons
                                .verified, // Use relevant icons or custom assets
                            title: "Certified Expertise",
                            description:
                                "Our team consists of certified chartered accountants with extensive industry experience",
                          ),
                          buildInfoCard(
                            icon: Icons.support_agent,
                            title: "Dedicated Support",
                            description:
                                "Personal attention and tailored solutions for every client's unique needs",
                          ),
                          buildInfoCard(
                            icon: Icons.access_time,
                            title: "Timely Service",
                            description:
                                "Quick response times and adherence to all regulatory deadlines",
                          ),
                          buildInfoCard(
                            icon: Icons.work_outline,
                            title: "Industry Experience",
                            description:
                                "15+ years of experience serving diverse business sectors",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomCard(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          buildContainer(
                              title: '15+', subtitle: 'Years of \nExperience'),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: VerticalDivider(),
                            ),
                          ),
                          buildContainer(
                              title: '1000+', subtitle: 'Satisfied \nClients'),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: VerticalDivider(),
                            ),
                          ),
                          buildContainer(
                              title: '98%', subtitle: 'Client \nRetention'),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: VerticalDivider(),
                            ),
                          ),
                          buildContainer(
                              title: '24/7', subtitle: 'Support \nAvailable'),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Commitment Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: ColorConstants.buttonColor.withOpacity(0.1),
                          border: Border.all(color: ColorConstants.darkGray),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Center(
                              child: Text("Our Commitment to Excellence",
                                  style: AppTextStyle().textButtonStyle),
                            ),
                            const SizedBox(height: 12),
                            bulletPoint(
                                "Comprehensive financial solutions tailored to your needs"),
                            bulletPoint(
                                "Regular updates and transparent communication"),
                            bulletPoint(
                                "Advanced technology for accurate reporting"),
                            bulletPoint(
                                "Strict confidentiality and data security"),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CommonButtonWidget(
                    buttonIconVisible: true,
                    buttonIcon: Icon(
                      Icons.timeline_outlined,
                      color: ColorConstants.white,
                    ),
                    buttonTitle: 'Start Your Financial Journey',
                    onTap: () {},
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'What Our Clients Say',
                  style: AppTextStyle().headingtext,
                ),
                SizedBox(height: 10),
                Text(
                  'Hear from businesses that have transformed their financial processes with CABA.',
                  style: AppTextStyle().landinghinttextblack,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 10 : 0, right: 10),
                        child: SizedBox(
                          width: 265,
                          child: CustomCard(
                              child: Column(
                            children: [
                              SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  clientImg,
                                  width: 170,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Sarah Johnson',
                                style: AppTextStyle().lableText,
                              ),
                              Text(
                                "CEO, TechSolutions Inc.",
                                style: AppTextStyle().lableText,
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  5,
                                  (index) {
                                    return Icon(
                                      Icons.star,
                                      color: ColorConstants.yellowColor,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '"CABA’s expert team transformed our financial processes and helped us navigate complex tax regulations with ease. Their strategic guidance has been invaluable for our business growth."',
                                style: AppTextStyle().landingratingText,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  // ignore: deprecated_member_use
                  color: ColorConstants.buttonColor.withOpacity(0.1),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        'Stay Updated with CABA Insights',
                        style: AppTextStyle().cardLableText,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'Subscribe to our newsletter for expert financial insights, tax updates, and business tips delivered straight to your inbox.',
                          style: AppTextStyle().landinghinttextblack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomCard(
                          child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: CustomSearchField(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 5),
                                    child: Icon(Icons.email_outlined),
                                  ),
                                  controller: _controller,
                                  serchHintText: 'Enter your email address'),
                            ),
                          ),
                          SizedBox(width: 10),
                          CommonButtonWidget(
                            buttonWidth: 140,
                            buttonheight: 40,
                            buttonTitle: 'Subscribe Now',
                            onTap: () {},
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cacard(
      {required String image,
      required String title,
      required String subtilte,
      required String subtitle2,
      required String totalCa,
      required VoidCallback viewAllOnTap,
      required VoidCallback allCaOnTap,
      required String rating}) {
    return Stack(
      children: [
        Card(
          color: ColorConstants.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            width: 212,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  child: Image.asset(
                    image,
                    width: 212,
                    height: 176,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text(
                    title,
                    style: AppTextStyle().landingCardTitle,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: ColorConstants.buttonColor
                          // ignore: deprecated_member_use
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    subtilte,
                    style: AppTextStyle().landingCardSubTitle,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    subtitle2,
                    style: AppTextStyle().landingCardsubtitle2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: viewAllOnTap,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          child: Text(
                            'View all CAs',
                            style: AppTextStyle().landingviewAll,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: allCaOnTap,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: ColorConstants.buttonColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '$totalCa+ CAs',
                            style: AppTextStyle().landingCardbutton,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
                color: ColorConstants.white,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: ColorConstants.yellowColor,
                  size: 20,
                ),
                SizedBox(width: 2),
                Text(
                  rating,
                  style: AppTextStyle().lableText,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildFeature(String title, String subtitle) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: ColorConstants.buttonColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          SizedBox(height: 2),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 182,
      height: 165,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: ColorConstants.buttonColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2)),
              child: Icon(icon, size: 30, color: ColorConstants.darkGray)),
          SizedBox(height: 12),
          Text(title, style: AppTextStyle().textCardStyle),
          SizedBox(height: 10),
          Text(description, style: AppTextStyle().landingSubTitletext11),
        ],
      ),
    );
  }

  Widget buildContainer({required String title, required String subtitle}) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyle().landingAccountTitle20,
        ),
        Text(
          subtitle,
          style: AppTextStyle().landingCardTitle,
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: AppTextStyle().landingSubTitle)),
        ],
      ),
    );
  }
}
