import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/coomon_ca_container.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_dropdown_button.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CaDetailsScreen extends StatefulWidget {
  final String userId;
  const CaDetailsScreen({super.key, required this.userId});

  @override
  State<CaDetailsScreen> createState() => _CaDetailsScreenState();
}

class _CaDetailsScreenState extends State<CaDetailsScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    BlocProvider.of<AuthBloc>(context)
        .add(GetUserByIdEvent(userId: widget.userId));
  }

  final Map<int, int> ratingStats = {
    5: 75,
    4: 15,
    3: 5,
    2: 4,
    1: 1,
  };
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Sarah Johnson",
      "date": "2 weeks ago",
      "rating": 5,
      "comment":
          "Jennifer was extremely helpful with my business tax preparation. She identified several deductions I had missed and saved me thousands of dollars."
    },
    {"name": "Michael Chen", "date": "1 month ago", "rating": 5, "comment": ""},
  ];
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      bgColor: ColorConstants.white,
      appBar: AppBar(
        title: Text(
          'Ca Details',
          style: AppTextStyle().cardLableText,
        ),
        backgroundColor: ColorConstants.white,
        shadowColor: ColorConstants.white,
        elevation: 2,
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is GetUserLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstants.buttonColor,
              ),
            );
          } else if (state is GetUserByIdSuccess) {
            var userData = state.getUserByIdData?.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    CommonCaContainer(
                      imageUrl: '${userData?.profileUrl ?? ''}',
                      name: '${userData?.firstName} ${userData?.lastName}',
                      title: 'Certified Public Accountant',
                      tag: 'Tax Planning & Preparation',
                      address: '${userData?.address ?? ''}',
                      isOnline: true,
                      rating: 4.9,
                      reviews: 174,
                      exprience: '12',
                      totalClient: '500',
                      isVisibleButton: true,
                      onChatTap: () async {
                        String? token = await SharedPrefsClass().getToken();

                        if (token != null) {
                          context.push('/chat_screen');
                        } else {
                          context.push('/login');
                        }
                      },
                      onSendEnquiry: () async {
                        String? token = await SharedPrefsClass().getToken();

                        if (token != null) {
                          _sendEnquiryModal(
                            onTap: () {},
                          );
                        } else {
                          context.push('/login');
                        }
                      },
                    ),
                    SizedBox(height: 5),
                    CustomCard(
                        // ignore: deprecated_member_use
                        cardColor: ColorConstants.buttonColor.withOpacity(0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About ${userData?.firstName??''} ${userData?.lastName??''}',
                              style: AppTextStyle().landingAccountTitle20,
                            ),
                            Text(
                              'Jennifer is a seasoned CPA with over 12 years of experience in tax planning and preparation. She specializes in helping small to medium businesses optimize their tax strategies and ensure compliance with current regulations.',
                              style: AppTextStyle().textSmallButtonStyle,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Certifications',
                              style: AppTextStyle().landingAccountTitle20,
                            ),
                            SizedBox(height: 10),
                            itemText('Certified Public Accountant (CPA)'),
                            SizedBox(height: 10),
                            itemText('Enrolled Agent (EA)'),
                            SizedBox(height: 10),
                            itemText('QuickBooks ProAdvisor'),
                            SizedBox(height: 20),
                            Text(
                              'Education',
                              style: AppTextStyle().landingAccountTitle20,
                            ),
                            SizedBox(height: 10),
                            itemText1('MBA in Accounting - UC Berkeley'),
                            SizedBox(height: 10),
                            itemText1(
                                'Bachelor of Accounting - San Jose State University')
                          ],
                        )),
                    CustomCard(
                        // ignore: deprecated_member_use
                        cardColor: ColorConstants.buttonColor.withOpacity(0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Services',
                              style: AppTextStyle().landingAccountTitle20,
                            ),
                            SizedBox(height: 20),
                            itemText('Tax Planning & Preparation'),
                            SizedBox(height: 10),
                            itemText('Business Tax Returns'),
                            SizedBox(height: 10),
                            itemText('Individual Tax Returns'),
                            SizedBox(height: 10),
                            itemText('Tax Consultation'),
                            SizedBox(height: 10),
                            itemText('IRS Representation'),
                            SizedBox(height: 10),
                            itemText('Financial Planning')
                          ],
                        )),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '4.9',
                          style: AppTextStyle().headingtext,
                        )
                      ],
                    ),
                    Text(
                      'All reviews',
                      style: AppTextStyle().cardLableText,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '196 total',
                          style: AppTextStyle().textMediumButtonStyle,
                        ),
                        Text(
                          'Write a review',
                          style: AppTextStyle().textMediumButtonStyle,
                        )
                      ],
                    ),
                    CustomCard(
                        child: Column(
                      children: [
                        ...ratingStats.entries.map((entry) => RatingBarRow(
                              stars: entry.key,
                              percent: entry.value,
                            )),
                      ],
                    )),
                    SizedBox(height: 10),
                    Text(
                      'Client Reviews',
                      style: AppTextStyle().cardLableText,
                    ),
                    SizedBox(height: 10),
                    ...reviews.map((review) => ReviewTile(review)),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  itemText(String lable) {
    return Row(
      children: [
        Icon(
          Icons.task_alt_outlined,
          size: 18,
          color: ColorConstants.buttonColor,
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            lable,
            style: AppTextStyle().textSmallButtonStyle,
          ),
        )
      ],
    );
  }

  itemText1(String lable) {
    return Row(
      children: [
        Icon(
          Icons.workspace_premium_outlined,
          size: 18,
          color: ColorConstants.buttonColor,
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            lable,
            style: AppTextStyle().textSmallButtonStyle,
          ),
        )
      ],
    );
  }

  void _sendEnquiryModal({required VoidCallback onTap}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                  child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Send Enquiry',
                          style: AppTextStyle().textButtonStyle,
                        ),
                        IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                    Text(
                      'Fill out the form below and Jennifer Smith will get back to you within 24 hours.',
                      style: AppTextStyle().landinghinttextblack,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Service Type',
                      style: AppTextStyle().listTileText,
                    ),
                    SizedBox(height: 5),
                    CustomDropdownButton(
                        dropdownItems: [],
                        initialValue: '',
                        hintText: 'select service'),
                    SizedBox(height: 8),
                    Text(
                      'Subject',
                      style: AppTextStyle().listTileText,
                    ),
                    SizedBox(height: 5),
                    TextformfieldWidget(
                        controller: _subjectController,
                        hintText: 'Brief subject of your enquiry'),
                    SizedBox(height: 8),
                    Text(
                      'Urgency Level',
                      style: AppTextStyle().listTileText,
                    ),
                    SizedBox(height: 5),
                    CustomDropdownButton(
                        dropdownItems: [],
                        initialValue: '',
                        hintText: 'General Enquiry'),
                    SizedBox(height: 8),
                    Text(
                      'Message',
                      style: AppTextStyle().listTileText,
                    ),
                    SizedBox(height: 5),
                    TextformfieldWidget(
                        maxLines: 3,
                        minLines: 3,
                        controller: _messageController,
                        hintText:
                            'Please describe your accounting needs in details'),
                    SizedBox(height: 15),
                    CommonButtonWidget(
                      buttonheight: 45,
                      buttonTitle: 'Send Enquiry',
                      onTap: onTap,
                    )
                  ],
                ),
              )),
            );
          },
        );
      },
    );
  }
}

class RatingBarRow extends StatelessWidget {
  final int stars;
  final int percent;

  const RatingBarRow({super.key, required this.stars, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (_) {},
            side: BorderSide(color: ColorConstants.buttonColor, width: 2),
          ),
          Text(
            '$stars - star',
            style: AppTextStyle().labletext,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                  height: 15,
                  width: percent * 2.0, // adjust as needed
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            '$percent%',
            style: AppTextStyle().labletext,
          ),
        ],
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final Map<String, dynamic> review;

  const ReviewTile(this.review, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(review['name'], style: AppTextStyle().textCardStyle),
        Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(Icons.star,
                    color:
                        index < review['rating'] ? Colors.orange : Colors.grey,
                    size: 20);
              }),
            ),
            SizedBox(width: 8),
            Text(
              review['date'],
              style: AppTextStyle().landingSubTitle,
            ),
          ],
        ),
        SizedBox(height: 4),
        if (review['comment'].isNotEmpty)
          Text(
            review['comment'],
            style: AppTextStyle().landingSubTitle,
          ),
        Divider(height: 24),
      ],
    );
  }
}
