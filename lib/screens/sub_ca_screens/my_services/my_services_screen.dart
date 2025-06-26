import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/custom_text_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyServicesScreen extends StatefulWidget {
  final int caId;
  const MyServicesScreen({super.key, required this.caId});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  final TextEditingController _serchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchText = '';
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _getServiceList(isSearch: true);
    _scrollController.addListener(_onScroll);
  }

  void _getServiceList({bool isSearch = false, bool isPagination = false}) {
    context.read<ServiceBloc>().add(GetServiceByCaIdEvent(
        caId: widget.caId,
        isSearch: isSearch,
        searchText: searchText,
        isPagination: isPagination));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 🔹 Trigger pagination event

      _getServiceList(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _getServiceList(isSearch: true);
  }
  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'My Service',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CustomSearchField(
              focusNode: _searchFocus,
                controller: _serchController,
              serchHintText: 'search..by id ,service name,subservice name',
              onChanged: _onSearchChanged,
            ),
            SizedBox(height: 5),
            BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                if (state is ServiceLoading) {
                  return Expanded(
                      child: Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.buttonColor,
                    ),
                  ));
                } else if (state is ServiceError) {
                  return Expanded(
                      child: Center(
                    child: Text(
                      'No Data Found',
                      style: AppTextStyle().redText,
                    ),
                  ));
                } else if (state is GetServiceByCaIdSuccess) {
                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.serviceList.length + (state.isLastPage ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == state.serviceList.length) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: ColorConstants.buttonColor,
                          ));
                        }
                        var data = state.serviceList[index];
                        return CustomCard(
                            child: Column(
                          children: [
                            CustomTextInfo(
                                flex1: 3,
                                flex2: 4,
                                lable: 'ID',
                                value: '#${data.serviceId}'),
                            CustomTextInfo(
                                flex1: 3,
                                flex2: 4,
                                lable: 'SERVICE NAME',
                                value: '${data.serviceName}'),
                            CustomTextInfo(
                                flex1: 3,
                                flex2: 4,
                                lable: 'SUBSERVICE NAME',
                                value: '${data.subService}'),
                            CustomTextInfo(
                                flex1: 3,
                                flex2: 4,
                                lable: 'CREATE DATE/TIME',
                                value:
                                    '${dateFormate(data.createdDate)} / ${timeFormate(data.createdDate)}'),
                            CustomTextInfo(
                                flex1: 3,
                                flex2: 4,
                                lable: 'DESCRIPTIONS',
                                value:
                                    '${data.serviceDesc}'),
                          ],
                        ));
                      },
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
