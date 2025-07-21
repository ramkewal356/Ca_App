import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';

class CommonCaContainer extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String title;
  final String tag;
  final String address;
  final bool isOnline;
  final double rating;
  final int reviews;
  final String exprience;
  final String totalClient;
  final bool isVisibleButton;
  final VoidCallback? onChatTap;
  final VoidCallback? onSendEnquiry;
  final String lastLogout;
  const CommonCaContainer(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.title,
      required this.tag,
      required this.address,
      required this.isOnline,
      required this.rating,
      required this.reviews,
      this.exprience = '',
      this.totalClient = '',
      this.isVisibleButton = false,
      this.onChatTap,
      this.onSendEnquiry,
      this.lastLogout = ''});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: ColorConstants.white,
          surfaceTintColor: ColorConstants.white,
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: ColorConstants.darkGray)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl.isEmpty
                      ? Image.asset(
                          clientImg,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          imageUrl,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name and online status
                      Row(
                        children: [
                          Text(name, style: AppTextStyle().textCardStyle),
                          SizedBox(width: 10),
                         
                          Text(
                            isOnline ? '● Online' : '',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                     Colors.green),
                          )
                        ],
                      ),

                      /// Title
                      title.isEmpty
                          ? SizedBox.shrink()
                          : Text(title, style: AppTextStyle().landingSubTitle),
                      if (!isOnline)
                        Text(
                          'Last seen $lastLogout',
                          style: AppTextStyle().rating8,
                        ),
                      /// Tag
                      tag.isEmpty
                          ? SizedBox.shrink()
                          : Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color:
                                    // ignore: deprecated_member_use
                                    ColorConstants.buttonColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(tag,
                                  style: AppTextStyle().landingSubTitle),
                            ),
                      SizedBox(height: 5),

                      /// Address
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 18, color: ColorConstants.buttonColor),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              address,
                              style: AppTextStyle().landingCardSubTitle,
                            ),
                          ),
                        ],
                      ),

                      /// exprience
                      exprience.isEmpty
                          ? SizedBox.shrink()
                          : Row(
                              children: [
                                Icon(Icons.workspace_premium_outlined,
                                    size: 18,
                                    color: ColorConstants.buttonColor),
                                SizedBox(width: 4),
                                Text(
                                  '$exprience years exprience',
                                  style: AppTextStyle().landingCardSubTitle,
                                ),
                              ],
                            ),

                      /// exprience
                      totalClient.isEmpty
                          ? SizedBox.shrink()
                          : Row(
                              children: [
                                Icon(Icons.groups_2_outlined,
                                    size: 18,
                                    color: ColorConstants.buttonColor),
                                SizedBox(width: 4),
                                Text(
                                  '$totalClient+ clients served',
                                  style: AppTextStyle().landingCardSubTitle,
                                ),
                              ],
                            ),

                      /// Buttons
                      isVisibleButton
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: onChatTap,
                                    icon: Icon(
                                      Icons.chat,
                                      size: 16,
                                      color: ColorConstants.buttonColor,
                                    ),
                                    label: Text(
                                      "Chat Now",
                                      style: AppTextStyle().chatButton,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      fixedSize: Size(110, 30), // Width, Height
                                      minimumSize: Size(110, 30),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: ColorConstants.buttonColor),
                                        borderRadius: BorderRadius.circular(
                                            8), // Border radius
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: onSendEnquiry,
                                  icon: Icon(
                                    Icons.send,
                                    size: 16,
                                    color: ColorConstants.white,
                                  ),
                                  label: Text(
                                    "Send Enquiry",
                                    style: AppTextStyle().enquiryButton,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorConstants.buttonColor,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    fixedSize: Size(120, 30),
                                    minimumSize: Size(120, 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
            right: 4,
            top: 4,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 20),
                    Text(
                      '$rating',
                      style: AppTextStyle().rating10,
                    )
                  ],
                ),
                SizedBox(height: 4),
                Text("($reviews reviews)", style: AppTextStyle().rating8),
              ],
            ))
      ],
    );
  }
}
