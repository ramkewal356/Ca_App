import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/coomon_ca_container.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_popup_filter.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_search_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CaSearchListScreen extends StatefulWidget {
  final int serviceId;
  const CaSearchListScreen({super.key, required this.serviceId});

  @override
  State<CaSearchListScreen> createState() => _CaSearchListScreenState();
}

class _CaSearchListScreenState extends State<CaSearchListScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String filter = '';
  String filterTitle = 'All';
  Map<String, String> filterOptions = {"All": '', "Online": 'true'};
  @override
  void initState() {
    super.initState();
    _getViewCaByService(isFilter: true);
    _scrollController.addListener(_onScroll);
  }

  _getViewCaByService({bool isPagination = false, bool isFilter = false}) {
    context.read<ServiceBloc>().add(GetCaByServiceNameEvent(
        serviceId: widget.serviceId,
        isPagination: isPagination,
        isFilter: isFilter,
        filter: filter));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getViewCaByService(isPagination: true);
    }
  }

  void _onChangedFilter(String value) {
    setState(() {
      filter = value;
      filterTitle = (value == '' ? 'All' : filterOptions[value] ?? '');
    });
    _getViewCaByService(isFilter: true);
  }

  void _getUser() {
    BlocProvider.of<AuthBloc>(context).add(GetUserByIdEvent());
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('servviceoid.....${widget.serviceId}');
    return CustomLayoutPage(
      bgColor: ColorConstants.white,
      appBar: AppBar(
        title: Text(
          'CA Search List',
          style: AppTextStyle().cardLableText,
        ),
        backgroundColor: ColorConstants.white,
        shadowColor: ColorConstants.white,
        elevation: 2,
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 600),
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(searchCaTopImg), fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  'Find Your Perfect Chartered Accountant',
                  style: AppTextStyle().headingText24,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Connect with certified professionals who understand your business needs. Search, compare, and schedule consultations with expert CAs in your area.',
                  textAlign: TextAlign.center,
                  style: AppTextStyle().landingSubtitletext22,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: CustomCard(
                child: Row(
              children: [
                Expanded(
                    child: SizedBox(
                  height: 40,
                  child: CustomSearchField(
                      borderRadius: 5.0,
                      // ignore: deprecated_member_use
                      borderColor: ColorConstants.darkGray.withOpacity(0.5),
                      prefixIcon: Icon(
                        Icons.search,
                        color: ColorConstants.darkGray,
                      ),
                      controller: _searchController,
                      serchHintText: 'Search'),
                )),
                SizedBox(width: 8),
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
                CommonButtonWidget(
                  borderRadius: 5,
                  buttonWidth: 80,
                  buttonheight: 40,
                  buttonTitle: 'Search',
                  onTap: () {
                    // context.push('/ca_search');
                  },
                )
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Over 126+ certified accountants ready to help your business',
                    style: AppTextStyle().getgreenText,
                  ),
                ),
                SizedBox(width: 10),
                CustomFilterPopupWidget(
                  title: filterTitle,
                  filterOptions: filterOptions,
                  onFilterChanged: _onChangedFilter,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                if (state is ServiceLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.buttonColor,
                    ),
                  );
                } else if (state is ServiceError) {
                  return Center(
                    child: Text(
                      'No data found',
                      style: AppTextStyle().getredText,
                    ),
                  );
                } else if (state is GetCaByServiceNameSuccess) {
                  return ListView.builder(
                    // controller: _scrollController,
                    itemCount: state.caList.length + (state.isLastPage ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index == state.caList.length) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.buttonColor,
                          ),
                        );
                      }
                      var data = state.caList[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            top: index == 0 ? 15 : 0,
                            bottom: 15,
                            left: 10,
                            right: 10),
                        child: GestureDetector(
                          onTap: () {
                            context.push('/ca_details', extra: {
                              "userId": data.caId.toString()
                            }).then((onValue) {
                              _getUser();
                            });
                          },
                          child: CommonCaContainer(
                            imageUrl: data.profileUrl ?? '',
                            name: '${data.fullName}',
                            title: 'Certified Public Accountant',
                            tag: state.subService,
                            address:
                                '123 Marine Drive, Mumbai, Maharashtra, 400020, India',
                            isOnline: data.isOnline ?? false,
                            rating: 4.9,
                            reviews: 174,
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          )
        ],
      ),
    );
  }
}
