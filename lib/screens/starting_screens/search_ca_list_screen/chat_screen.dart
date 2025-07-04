import 'dart:async';
import 'dart:convert';
import 'package:ca_app/blocs/chat/chat_bloc.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';


class ChatScreen extends StatefulWidget {
  final String name;
  final String profileImg;
  final String title;
  final bool isOnline;
  final String senderId;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.name,
    required this.profileImg,
    required this.title,
    required this.isOnline,
    required this.senderId,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  bool isWebSocketConnected = false;
  late StompClient stompClient;
  Timer? _typingTimer;
  bool _isTyping = false;
  bool _isOtherUserTyping = false;
  bool onClickSearch = false;
  bool isSearch = false;
  bool isReceiverOnline = false;
  Message? repliedMessage;
  String searchText = '';
  @override
  void initState() {
    super.initState();
    connectWebSocket();
    _getChatHisytory();
    _controller.addListener(sendTyping);
  }

  void _getChatHisytory({bool isSearch = false}) {
    context.read<ChatBloc>().add(GetChatHistoryEvent(
        senderId: widget.senderId,
        receiverId: widget.receiverId,
        isSearch: isSearch,
        searchText: searchText));
  }

  void onSearch(String text) {
    setState(() {
      searchText = text;
    });
    _getChatHisytory(isSearch: true);
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
        onDisconnect: (frame) {
          debugPrint('Disconnected');
          setState(() {
            isReceiverOnline = false;
          });
        },
        onDebugMessage: (msg) => debugPrint('DEBUG: $msg'),
      ),
    );

    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) {
    debugPrint("Connected to STOMP WebSocket!");
    isWebSocketConnected = true;
    // sendPresence(true);
    stompClient.subscribe(
      destination: '/user/${widget.senderId}/queue/messages',
      callback: (frame) {
        debugPrint(" WebSocket hello ram");
        if (!mounted || frame.body == null) return;

        debugPrint("message body ${frame.body}");
        final Map<String, dynamic> jsonBody = jsonDecode(frame.body!);
        final senderId = jsonBody["senderId"];
        final chatTime = jsonBody["timestamp"];
        final messageText = jsonBody["message"];
        final replyToId = jsonBody["replyToMessageId"];
        final replyToText = jsonBody["replyToMessageText"];
        if (senderId.toString() == widget.senderId) {
          debugPrint("🟡 Skipped duplicate self message from WebSocket");
          return;
        }

        setState(() {
          _newMessages.add(
            Message(
                text: messageText,
                time: timeFormate(chatTime),
                isUser: false,
                isRead: false,
                replyToMessageId: replyToId,
                replyToMessageText: replyToText),
          );
        });

        // Scroll to bottom
        _scrollToBottom();
        if (isWebSocketConnected) {
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) _sendReadReceipt();
          });
        }
      },
    );
    stompClient.subscribe(
      destination: '/user/${widget.senderId}/queue/presence',
      callback: (frame) {
        debugPrint('Presence update received body.....,: ${frame.body}');
        final data = jsonDecode(frame.body!);
        final int presenceUserId = data['userId'];
        final bool isOnline = data['online'];

        if (presenceUserId.toString() == widget.receiverId) {
          debugPrint('Presence update received: $isOnline');
          setState(() {
            isReceiverOnline = isOnline;
          });
        }
      },
    );
    stompClient.subscribe(
      destination: '/user/${widget.senderId}/queue/typing-status',
      callback: (typingStatus) {
        final data = jsonDecode(typingStatus.body!);
        final typing = data['isTyping'] == true;
        final typingUserId = data['senderId'];

        // Update UI: Show "User is typing..." indicator
        if (typingUserId.toString() == widget.receiverId) {
          debugPrint("Typing status from other user: $typing");

          setState(() {
            _isOtherUserTyping = typing;
          });
        }
      },
    );
    // Optional: Listen for read-receipt acknowledgment
    stompClient.subscribe(
      destination: '/user/${widget.senderId}/queue/read-receipt',
      callback: (frame) {
        debugPrint("📨 Read receipt: ${frame.body}");
        final Map<String, dynamic> receipt = jsonDecode(frame.body!);
        final receiverId = receipt["receiverId"];

        setState(() {
          for (var msg in _newMessages) {
            if (msg.isUser && receiverId.toString() == widget.receiverId) {
              msg.isRead = true;
            }
          }
        });
      },
    );

    if (mounted && isWebSocketConnected) {
      _sendReadReceipt();
    }
  }

  void sendMessage() {
    final message = {
      "senderId": int.parse(widget.senderId),
      "receiverId": int.parse(widget.receiverId),
      "message": _controller.text.trim(),
      "replyToMessageId":
          repliedMessage != null ? repliedMessage?.messageId ?? 0 : null,
      "replyToMessageText": repliedMessage?.text
    };

    stompClient.send(
      destination: '/app/chat',
      body: _controller.text.isNotEmpty ? jsonEncode(message) : "",
    );
    setState(() {
      _newMessages.add(Message(
          text: message["message"].toString(),
          time: TimeOfDay.now().format(context),
          isUser: true,
          isRead: false,
          replyToMessageText: repliedMessage?.text));
      _controller.clear();
      repliedMessage = null;
    });
    _scrollToBottom();
  }

  void _sendReadReceipt() {
    if (!isWebSocketConnected) {
      debugPrint(" WebSocket not connected. Skipping read receipt.");
      return;
    }
    final dto = {
      "senderId": int.parse(widget.receiverId),
      "receiverId": int.parse(widget.senderId),
    };

    stompClient.send(
      destination: '/app/read',
      body: jsonEncode(dto),
    );
  }

  void sendTyping() {
    if (widget.receiverId.isEmpty || widget.senderId.isEmpty) return;

    // Send typing: true only once when user starts typing
    if (!_isTyping) {
      _isTyping = true;

      stompClient.send(
        destination: '/app/typing',
        body: jsonEncode({
          "senderId": int.parse(widget.senderId),
          "receiverId": int.parse(widget.receiverId),
          "isTyping": true,
        }),
      );
    }

    // Restart the timer for sending typing: false
    _typingTimer?.cancel();
    _typingTimer = Timer(Duration(seconds: 1), () {
      _isTyping = false;

      stompClient.send(
        destination: '/app/typing',
        body: jsonEncode({
          "senderId": int.parse(widget.senderId),
          "receiverId": int.parse(widget.receiverId),
          "isTyping": false,
        }),
      );
    });
  }

  final List<Message> _newMessages = [];
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendPresence(bool online) {
    stompClient.send(
      destination: '/app/presence',
      body: jsonEncode({
        "userId": int.parse(widget.senderId),
        "online": online,
      }),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    // sendPresence(false);
    if (stompClient.connected) {
      stompClient.deactivate(); // ✅ disconnects WebSocket
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      bgColor: ColorConstants.white,
      onRefresh: () async {
        _getChatHisytory();
      },
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 70,
        automaticallyImplyLeading: !onClickSearch,
        title: onClickSearch
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomSearchField(
                  borderRadius: 50,
                  // ignore: deprecated_member_use
                  fillColor: ColorConstants.buttonColor.withOpacity(0.1),
                  filled: true,
                  prefixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        onClickSearch = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  controller: _searchController,
                  serchHintText: 'Search ..', onChanged: onSearch,
                ),
              )
            : _buildHeader(isOnline: isReceiverOnline),
        backgroundColor: ColorConstants.white,
        shadowColor: ColorConstants.white,
        elevation: 2,
        actions: [
          onClickSearch
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      onClickSearch = true;
                    });
                  },
                  icon: Icon(Icons.search))
        ],
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
              chatbgImg,
              fit: BoxFit.cover,
            )),
            Column(
              children: [
                // _buildHeader(),

                Expanded(
                  child: BlocConsumer<ChatBloc, ChatState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is Chatloading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorConstants.buttonColor,
                          ),
                        );
                      } else if (state is ChatError) {
                        return Center(child: Text('No data found'));
                      } else if (state is ChatSuccess) {
                        final history = state.chatData.data?.messages
                                ?.map((chat) => Message(
                                    text: chat.message ?? '',
                                    time: timeFormate(chat
                                        .timestamp), // Or use formatted chat.createdAt
                                    isUser: chat.senderId.toString() ==
                                        widget.senderId,
                                    messageId: chat.messageId,
                                    replyToMessageId: chat.replyToMessageId,
                                    replyToMessageText: chat.replyToMessageText,
                                    isRead: chat.isRead ?? false))
                                .toList() ??
                            [];
                        final allMessages = [...history, ..._newMessages];
                        if (_isOtherUserTyping) {
                          allMessages.add(Message(
                            text: '__TYPING_INDICATOR__', // special marker
                            time: '',
                            isUser: false,
                            isRead: false,
                          ));
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });
                        return allMessages.isEmpty
                            ? Center(
                                child: Text(
                                  'No data found',
                                  style: AppTextStyle().getredText,
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount: allMessages.length,
                                itemBuilder: (context, index) {
                                  return _buildMessageBubble(
                                      allMessages[index]);
                                },
                              );
                      }
                      return Container();
                    },
                  ),
                ),

                _buildInputBar(),
                SizedBox(height: 10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({bool isOnline = false}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      horizontalTitleGap: 15,
      visualDensity: VisualDensity(horizontal: -4),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: widget.profileImg.isEmpty
            ? AssetImage(clientImg)
            : Image.network(
                widget.profileImg,
                fit: BoxFit.cover,
              ).image, // Replace with NetworkImage or other source
      ),
      title: Text(widget.name, style: AppTextStyle().cardLableText),
      subtitle: Text("● ${isOnline ? 'Online' : 'Offline'}",
          style: isOnline
              ? AppTextStyle().onlineText
              : AppTextStyle().offlineText),
    );
  }

  Widget _buildMessageBubble(Message message) {
    if (message.text == '__TYPING_INDICATOR__') {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Typing...',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
            // Swiped right → trigger reply
            setState(() {
              repliedMessage = message;
            });
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.blueGrey : Colors.grey[200],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(message.isUser ? 12 : 0),
                bottomRight: Radius.circular(message.isUser ? 0 : 12)),
          ),
          child: Column(
            crossAxisAlignment: message.isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (message.replyToMessageText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message.replyToMessageText!,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    message.time,
                    style: TextStyle(
                      color: message.isUser ? Colors.white70 : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                  if (message.isUser)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        message.isRead ? Icons.done_all : Icons.check,
                        size: 18,
                        color: message.isRead
                            ? ColorConstants.darkRedColor
                            : ColorConstants.buttonColor,
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius:
              BorderRadius.circular(repliedMessage != null ? 15 : 30)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (repliedMessage != null)
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 4, top: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
                border: Border(left: BorderSide(color: Colors.blue, width: 4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      repliedMessage!.text,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        repliedMessage = null;
                      });
                    },
                  )
                ],
              ),
            ),
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
                    Icons.file_copy,
                    color: ColorConstants.buttonColor,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(
                    Icons.send,
                    color: ColorConstants.buttonColor,
                  ),
                  onPressed: sendMessage),
            ],
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final String time;
  final bool isUser;
  bool isRead;
  final int? messageId;
  final int? replyToMessageId;
  final String? replyToMessageText;
  Message(
      {required this.text,
      required this.time,
      required this.isUser,
      required this.isRead,
      this.messageId,
      this.replyToMessageId,
      this.replyToMessageText});
}
