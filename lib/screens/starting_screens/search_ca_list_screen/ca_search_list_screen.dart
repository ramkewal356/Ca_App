import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/screens/starting_screens/landing_screen/search_service_widget.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/common_button_widget.dart';
import 'package:ca_app/widgets/coomon_ca_container.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_popup_filter.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CaSearchListScreen extends StatefulWidget {
  final int serviceId;
  final String serviceName;
  final String searchText;
  const CaSearchListScreen(
      {super.key,
      required this.serviceId,
      required this.serviceName,
      required this.searchText});

  @override
  State<CaSearchListScreen> createState() => _CaSearchListScreenState();
}

class _CaSearchListScreenState extends State<CaSearchListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _showSearch = true;
  String filter = '';
  String filterTitle = 'All';
  Map<String, String> filterOptions = {"All": '', "Online": 'true'};
  int? selectedServiceId;
  String? selectedServiceName;
  int totalca = 0;
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    selectedServiceId = widget.serviceId;
    selectedServiceName = widget.serviceName;
    _serviceController.text = widget.serviceName;
    _searchController.text = widget.searchText;
    _getViewCaByService(isFilter: true);
    _scrollController.addListener(_onScroll);
  }

  _getViewCaByService(
      {bool isPagination = false,
      bool isFilter = false,
      bool isSearch = false}) {
    context.read<ServiceBloc>().add(GetCaByServiceNameEvent(
        serviceId: selectedServiceId ?? 0,
        isPagination: isPagination,
        isFilter: isFilter,
        filter: filter,
        isSearch: isSearch,
        searchText: _searchController.text));
  }

  void _onScroll() {
    if (_scrollController.offset > 250 && _showSearch) {
      setState(() => _showSearch = false);
    } else if (_scrollController.offset <= 250 && !_showSearch) {
      setState(() => _showSearch = true);
    }
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('servviceoid.....${widget.serviceName}');
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
            height: _showSearch ? 220 : 0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(searchCaTopImg), fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70),
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: CustomCard(
                child: Row(
              children: [
                Expanded(
                    child: SizedBox(
                  height: 40,
                  child: SearchServiceWidget(
                    controller: _serviceController,
                    hintText: 'Service',
                    onServiceSelected: (id) {
                      setState(() {
                        selectedServiceId = id;
                        selectedServiceName = _serviceController.text;
                      });
                    },
                  ),
                )),
                SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                      height: 40,
                      child: CustomSearchField(
                          focusNode: _searchFocus,
                          controller: _searchController,
                          serchHintText: 'Search ca')),
                ),
                SizedBox(width: 8),
                CommonButtonWidget(
                  borderRadius: 5,
                  buttonWidth: 80,
                  buttonheight: 40,
                  buttonTitle: 'Search',
                  onTap: () {
                    // context.push('/ca_search');
                    _getViewCaByService(isFilter: true);
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
                    controller: _scrollController,
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
                              "userId": data.caId.toString(),
                              "serviceId": selectedServiceId,
                              "serviceName": selectedServiceName
                            }).then((onValue) {
                              _getUser();

                              _getViewCaByService(isFilter: true);
                            });
                          },
                          child: CommonCaContainer(
                            imageUrl: data.profileUrl ?? '',
                            name: '${data.fullName}',
                            title: data.professionalTitle ?? "",
                            tag: state.subService,
                            address:
                                data.firmAddress ?? data.address ?? '',
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
