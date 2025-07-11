import 'dart:convert';

import 'package:ca_app/blocs/chat/chat_bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/all_chat_history_model.dart';
import 'package:ca_app/screens/starting_screens/search_ca_list_screen/chat_screen.dart';
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
  final String role;
  final Messages? message;
  const AllChatHistoryScreen({super.key, required this.role, this.message});

  @override
  State<AllChatHistoryScreen> createState() => _AllChatHistoryScreenState();
}

class _AllChatHistoryScreenState extends State<AllChatHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  late StompClient stompClient;
  String searchText = '';
  List<int> selectedIds = [];
  List<String> selectedName = [];

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

  int? userId;
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
    userId = await SharedPrefsClass().getUserId();
    stompClient.subscribe(
      destination: '/user/$userId/queue/chat-list',
      callback: (frame) {
        debugPrint("🟢 Received chat list update from WebSocket");

        final List<dynamic> data = jsonDecode(frame.body!);
        final updatedList = data.map((e) => AllChatData.fromJson(e)).toList();
        if (!mounted) return;
        context.read<ChatHistoryBloc>().add(UpdateChatListEvent(updatedList));
      },
    );
  }

  // _sendForwardMessage() {
  //   context.pop({'status': 'forward', 'ids': selectedIds});
  // }
  _sendForwardMessage() {
    var forwardmsg = {
      "senderId": userId,
      "receiverIds": selectedIds,
      "originalMessageId": widget.message?.messageId
    };
    debugPrint('forword message body ${forwardmsg}');
    stompClient.send(
        destination: "/app/chat/forward", body: jsonEncode(forwardmsg));
    context.pop('forward');
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
    debugPrint('chat message.... ${widget.message}');
    return CustomLayoutPage(
      bgColor: ColorConstants.white,
      appBar: CustomAppbar(
        title: widget.message != null
            ? selectedIds.isNotEmpty
                ? '${selectedIds.length} Selected'
                : 'Forward to'
            : 'Chat History',
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
                return state.allChatData.isEmpty
                    ? Center(
                        child: Text(
                          'No data found',
                          style: AppTextStyle().getredText,
                        ),
                      )
                    : ListView.builder(
                  itemCount: state.allChatData.length,
                  itemBuilder: (context, index) {
                    var data = state.allChatData[index];
                          return Material(
                            color: selectedIds.contains(data.userId)
                                // ignore: deprecated_member_use
                                ? ColorConstants.buttonColor.withOpacity(0.2)
                                : Colors.transparent,
                            child: ListTile(
                              visualDensity: VisualDensity.compact,
                              selected: selectedIds.contains(data.userId),
                              tileColor: Colors.transparent,
                              selectedTileColor:
                                  // ignore: deprecated_member_use
                                  ColorConstants.buttonColor.withOpacity(0.2),
                              onTap: () {
                                if (widget.message != null) {
                                  setState(() {
                                    if (selectedIds.contains(data.userId)) {
                                      selectedIds.remove(data.userId);
                                      selectedName.remove(data.fullName);
                                    } else {
                                      selectedIds.add(data.userId ?? 0);
                                      selectedName
                                          .add(data.fullName.toString());
                                    }
                                  });
                                } else {
                                  context.push('/chat_screen', extra: {
                                    "name": '${data.fullName}',
                                    "title": '',
                                    "profileImg": data.profileUrl ?? '',
                                    "isOnline": true,
                                    "senderId": state.senderId,
                                    "receiverId": data.userId.toString(),
                                    "role": widget.role
                                  }).then((onValue) {
                                    _getAllChathistory(isSearch: true);
                                  });
                                }
                              },
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundImage:
                                        (data.profileUrl ?? '').isEmpty
                                            ? AssetImage(clientImg)
                                            : Image.network(
                                                data.profileUrl ?? '',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ).image,
                                    child: (data.profileUrl ?? '').isEmpty
                                        ? Text(
                                            data.fullName?[0].toString() ?? "")
                                        : SizedBox.shrink(),
                                  ),
                                  if (selectedIds.contains(data.userId))
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorConstants.buttonColor),
                                        child: Icon(
                                          Icons.check,
                                          size: 15,
                                          color: ColorConstants.white,
                                        ),
                                      ),
                                    )
                                ],
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
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          )),
          if (selectedIds.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: ColorConstants.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12, // Soft shadow
                    offset: Offset(0, -2), // Shadow above
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  CustomSearchField(
                    controller: _controller,
                    serchHintText: 'Type your message.....',
                    fillColor: Colors.grey[100],
                    filled: true,
                    borderRadius: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedName.join(' , '),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorConstants.buttonColor),
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Icon(
                              Icons.send,
                              color: ColorConstants.white,
                              size: 18,
                            ),
                          ),
                        ),
                        onPressed: _sendForwardMessage,
                      ),
                    ],
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  _showBottomModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container();
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: Colors.orangeAccent,
                  ),
                  onPressed: () {}),
              Expanded(
                child: TextField(
                  controller: _controller,
                  // onChanged: (_) => sendTyping(),
                  decoration: InputDecoration.collapsed(
                      hintText: "Type your message....."),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.attach_file_sharp,
                    color: ColorConstants.buttonColor,
                  ),
                  onPressed: () {}),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: ColorConstants.buttonColor,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
