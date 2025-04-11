import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_card.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_list_tile_card.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyClientsScreen extends StatefulWidget {
  const MyClientsScreen({super.key});

  @override
  State<MyClientsScreen> createState() => _MyClientsScreenState();
}

class _MyClientsScreenState extends State<MyClientsScreen> {
  final TextEditingController _serchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchText = '';
  @override
  void initState() {
    super.initState();
    _getClients(isSearch: true);
    _scrollController.addListener(_onScroll);
  }

  void _getClients({bool isSearch = false, bool isPagination = false}) {
    context.read<CustomerBloc>().add(GetCustomerBySubCaEvent(
        searchText: searchText,
        isPagination: isPagination,
        isSearch: isSearch));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 🔹 Trigger pagination event

      _getClients(isPagination: true);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _getClients(isSearch: true);
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      appBar: CustomAppbar(
        title: 'My Clients',
        backIconVisible: true,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 5),
            CustomSearchField(
              controller: _serchController,
              serchHintText: 'search..by user id ,user name,email',
              onChanged: _onSearchChanged,
            ),
            SizedBox(height: 5),
            Expanded(
              child: BlocBuilder<CustomerBloc, CustomerState>(
                builder: (context, state) {
                  if (state is CustomerLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.buttonColor,
                      ),
                    );
                  } else if (state is CustomerError) {
                    return Center(
                      child: Text('No Data Found'),
                    );
                  } else if (state is GetCustomerBySubCaSuccess) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: (state.getCustomers ?? []).length +
                          (state.isLastPage ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == state.getCustomers?.length) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.buttonColor,
                            ),
                          );
                        }
                        var data = state.getCustomers?[index];
                       
                        return GestureDetector(
                          onTap: () {
                            context.push('/ca_dashboard/view_client', extra: {
                              "userId": data?.userId.toString(),
                              "role": "SUBCA"
                            }).then((onValue) {
                              debugPrint(
                                  ',,,,cvnmvnc,v,,,,nv,mnv,mnv,nn,nn,v,,,');
                              _getClients(isSearch: true);
                            });
                          },
                          child: CustomCard(
                              child: CustomListTileCard(
                            id: '${data?.userId}',
                            title: '${data?.firstName} ${data?.lastName}',
                            subtitle1: '${data?.email}',
                            subtitle2: '+${data?.countryCode} ${data?.mobile}',
                            status: data?.status ?? false,
                            imgUrl: data?.profileUrl ?? '',
                            letter:
                                '${data?.firstName?[0]}${data?.lastName?[0]}',
                            isSecondary: Text(
                              data?.userResponse == 'ACCEPTED'
                                  ? 'Accepted by client'
                                  : 'Request sent',
                              style: data?.userResponse == 'ACCEPTED'
                                  ? AppTextStyle().getgreenText
                                  : AppTextStyle().getredText,
                            ),
                          )),
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
      ),
    );
  }
}
