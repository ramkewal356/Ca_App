import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchServiceWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
 
  final void Function(int)? onServiceSelected;
  const SearchServiceWidget(
      {super.key,
      required this.controller,
      required this.hintText,
    
      required this.onServiceSelected});

  @override
  State<SearchServiceWidget> createState() => _SearchServiceWidgetState();
}

class _SearchServiceWidgetState extends State<SearchServiceWidget> {
  int? _serviceId;
  void _navigateToSearchPage() async {
  
    final selectedService = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SerchServiceScreen(
             
              )),
    );

    if (selectedService != null && selectedService is Map) {
      // Set selected values
      widget.controller?.text = selectedService['serviceName'];
      final serviceId = selectedService['serviceId'];
      // If you want to use serviceId somewhere
      setState(() {
        _serviceId = serviceId;
        debugPrint("Selected Service ID: $_serviceId");
      });
      widget.onServiceSelected?.call(_serviceId ?? 0);
      // You can also call a callback or update a model here
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.dns_outlined,
          color: ColorConstants.darkGray,
        ),
        hintText: widget.hintText,
        prefixIconConstraints: BoxConstraints(maxWidth: 30),
        hintStyle: AppTextStyle().hintText,
        fillColor: ColorConstants.white,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        // border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: Color(0xFFCDCDCD),
            // color: redColor,
            // width: 2.0,
          ),
        ),

        errorStyle: TextStyle(
          color: Colors.red[900],
          fontSize: 13,
        ),
      ),
      onTap: _navigateToSearchPage,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select service';
        }
        return null;
      },
    );
  }
}

class SerchServiceScreen extends StatefulWidget {
 
  const SerchServiceScreen({
    super.key,
  });

  @override
  State<SerchServiceScreen> createState() => _SerchServiceScreenState();
}

class _SerchServiceScreenState extends State<SerchServiceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String searchText = '';

  List<String> predictions = [];
  @override
  void initState() {
    super.initState();

    _getServiceList(isFilterByLocation: true);
    _scrollController.addListener(_onScroll);
  }

  void _getServiceList(
      {bool isSearch = false,
      bool isPagination = false,
      bool isFilterByLocation = false}) {
    // debugPrint('location ..bbbbbbb...${widget.location}');
    context.read<AssignServiceBloc>().add(GetServiceForCustomerEvent(
        isFilterByLocation: isFilterByLocation,
        location: '',
        isSearch: isSearch,
        searchText: searchText,
        isPagination: isPagination));
  }

  _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
    _getServiceList(isSearch: true);
  }

  _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _getServiceList(isPagination: true);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      predictions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('location ..bbbbbbb..22222222222222222.${widget.location}');

    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorConstants.white,
        // ignore: deprecated_member_use
        shadowColor: ColorConstants.darkGray.withOpacity(0.5),
        title: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
                hintText: "Search Services",
                helperStyle: AppTextStyle().hintText,
                border: InputBorder.none
                // border: OutlineInputBorder(),
                ),
            onChanged: _onSearchChanged),
        actions: [
          IconButton(onPressed: _clearSearch, icon: const Icon(Icons.close))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AssignServiceBloc, ServiceState>(
          builder: (context, state) {
            if (state is GetServiceLoading) {
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
            } else if (state is GetServiceForIndivisualCustomerSuccess) {
              return state.serviceForCustomerList.isEmpty
                  ? Center(
                      child: Text(
                      'No data found',
                      style: AppTextStyle().getredText,
                    ))
                  : ListView.separated(
                      controller: _scrollController,
                      itemCount: state.serviceForCustomerList.length +
                          (state.isLastPage ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == state.serviceForCustomerList.length) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorConstants.buttonColor,
                            ),
                          );
                        }
                        var data = state.serviceForCustomerList[index];
                        return ListTile(
                          splashColor: ColorConstants.buttonColor,
                          leading: const Icon(
                            Icons.dns_outlined,
                            color: ColorConstants.darkGray,
                          ),
                          title: Text(data.subService ?? ''),
                          onTap: () {
                            Navigator.pop(context, {
                              'serviceName': data.subService,
                              'serviceId': data.serviceId,
                            });
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
