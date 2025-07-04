import 'dart:convert';

import 'package:ca_app/blocs/chat/chat_bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/all_chat_history_model.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_appbar.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class AllChatHistoryScreen extends StatefulWidget {
  const AllChatHistoryScreen({super.key});

  @override
  State<AllChatHistoryScreen> createState() => _AllChatHistoryScreenState();
}

class _AllChatHistoryScreenState extends State<AllChatHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  late StompClient stompClient;
  String searchText = '';
  @override
  void initState() {
    super.initState();
    _getAllChathistory(isSearch: true);
    connectWebSocket();
  }

  void _getAllChathistory({bool isSearch = false, bool isPagination = false}) {
    context.read<ChatHistoryBloc>().add(GetAllChatHistoryEvent(
        isSearch: isSearch,
        searchText: searchText,
        isPagination: isPagination));
  }

  void onSearch(String text) {
    setState(() {
      searchText = text;
    });
    _getAllChathistory(isSearch: true);
  }

  void connectWebSocket() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url:
            'https://cabaonline.xyz/api/chat-websocket', // Replace with your actual backend URL
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) =>
            debugPrint('WebSocket error: $error'),
        stompConnectHeaders: {},
        webSocketConnectHeaders: {},
        onDisconnect: (frame) => debugPrint('Disconnected'),
        onDebugMessage: (msg) => debugPrint('DEBUG: $msg'),
      ),
    );

    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) async {
    int? userId = await SharedPrefsClass().getUserId();
    stompClient.subscribe(
      destination: '/user/$userId/queue/chat-list',
      callback: (frame) {
        debugPrint("🟢 Received chat list update from WebSocket");

        final List<dynamic> data = jsonDecode(frame.body!);
        final updatedList = data.map((e) => AllChatData.fromJson(e)).toList();

        context.read<ChatHistoryBloc>().add(UpdateChatListEvent(updatedList));
      },
    );
  }

  @override
  void dispose() {
    if (stompClient.connected) {
      stompClient.deactivate(); // ✅ disconnects WebSocket
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      bgColor: ColorConstants.white,
      appBar: CustomAppbar(
        title: 'Chat History',
        backIconVisible: true,
      ),
      onRefresh: () async {},
      child: Column(
        children: [
          // SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: CustomSearchField(
              borderRadius: 50,
              // ignore: deprecated_member_use
              fillColor: ColorConstants.buttonColor.withOpacity(0.1),
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Icon(Icons.search),
              ),
              controller: _searchController,
              serchHintText: 'Search ..', onChanged: onSearch,
            ),
          ),
          Expanded(child: BlocBuilder<ChatHistoryBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatHistoryloading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.buttonColor,
                  ),
                );
              } else if (state is ChatError) {
                return Center(
                  child: Text(
                    'No data found',
                    style: AppTextStyle().redText,
                  ),
                );
              } else if (state is ChatHistorySuccess) {
                return ListView.builder(
                  itemCount: state.allChatData.length,
                  itemBuilder: (context, index) {
                    var data = state.allChatData[index];
                    return ListTile(
                      visualDensity: VisualDensity(horizontal: -4),
                      onTap: () {
                        context.push('/chat_screen', extra: {
                          "name": '${data.fullName}',
                          "title": '',
                          "profileImg": data.profileUrl ?? '',
                          "isOnline": true,
                          "senderId": state.senderId,
                          "receiverId": data.userId.toString(),
                        }).then((onValue) {
                          _getAllChathistory(isSearch: true);
                        });
                      },
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: (data.profileUrl ?? '').isEmpty
                            ? AssetImage(clientImg)
                            : Image.network(
                                data.profileUrl ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ).image,
                        child: (data.profileUrl ?? '').isEmpty
                            ? Text(data.fullName?[0].toString() ?? "")
                            : SizedBox.shrink(),
                      ),
                      title: Text(
                        '${data.fullName}',
                        style: AppTextStyle().labletext,
                      ),
                      subtitle: Text(
                        '${data.lastMessage}',
                        style: AppTextStyle().cardValueText,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timeFormate(data.lastMessageTime),
                            style: AppTextStyle().rating10,
                          ),
                          data.unreadCount == 0
                              ? SizedBox.shrink()
                              : Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorConstants.buttonColor,
                                  ),
                                  child: Text(
                                    '${data.unreadCount}',
                                    style: AppTextStyle().statustext,
                                  ),
                                )
                        ],
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ))
        ],
      ),
    );
  }
}
