import 'dart:async';
import 'dart:convert';
import 'package:ca_app/blocs/chat/chat_bloc.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/utils/constanst/validator.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:ca_app/widgets/custom_search_field.dart';
import 'package:ca_app/widgets/typing_indicator.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatScreen extends StatefulWidget {
  final String name;
  final String profileImg;
  final String title;
  final bool isOnline;
  final String senderId;
  final String receiverId;
  final String role;
  const ChatScreen(
      {super.key,
      required this.name,
      required this.profileImg,
      required this.title,
      required this.isOnline,
      required this.senderId,
      required this.receiverId,
      required this.role});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  final _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool isWebSocketConnected = false;
  final ScrollController _emojiScrollController = ScrollController();
  bool emojiShowing = false;
  late StompClient stompClient;
  Timer? _typingTimer;
  bool _isTyping = false;
  bool _isOtherUserTyping = false;
  bool onClickSearch = false;
  bool isSearch = false;
  bool isReceiverOnline = false;
  bool isForwardMessage = false;
  bool isEditableMessage = true;
  bool isEditable = false;
  Messages? repliedMessage;
  Messages? onClickRepliedMessage;
  Messages? onEditMessage;

  Messages? forwardMessage;

  String searchText = '';
  String selectMessage = '';
  // int? selectMessageId;

  @override
  void initState() {
    super.initState();
    connectWebSocket();
    _getChatHisytory();
    _controller.addListener(sendTyping);
  }

  void _getChatHisytory({bool isSearch = false}) {
    _newMessages.clear();
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
        },
        onDebugMessage: (msg) => debugPrint('DEBUG: $msg'),
      ),
    );

    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) {
    debugPrint("Connected to STOMP WebSocket!");
    isWebSocketConnected = true;
    sendPresence();

    stompClient.subscribe(
      destination: '/user/${widget.senderId}/queue/messages',
      callback: (frame) {
        debugPrint(" WebSocket hello ram");
        if (!mounted || frame.body == null) return;

        debugPrint("message body ${frame.body}");

        final Map<String, dynamic> jsonBody = jsonDecode(frame.body!);
        final messageId = jsonBody["messageId"];
        final receiverId = jsonBody["receiverId"];
        final senderId = jsonBody["senderId"];

        final isForActiveChat = senderId.toString() == widget.receiverId ||
            receiverId.toString() == widget.receiverId;

        if (!isForActiveChat) {
          debugPrint("⛔ Message not for current chat");
          return;
        }
        bool alreadyExists = allMessages.any((m) => m.messageId == messageId);
        if (alreadyExists) {
          debugPrint("🔁 Duplicate message skipped (messageId: $messageId)");
          return;
        }

        final chatTime = jsonBody["timestamp"];
        final messageText = jsonBody["message"];
        final replyToId = jsonBody["replyToMessageId"];
        final replyToText = jsonBody["replyToMessageText"];
        final isForwarded = jsonBody["isForwarded"];
        final isEdited = jsonBody["isEdited"];
        final editedAt = jsonBody["editedAt"];
        final forwardedUserName = jsonBody["forwardedFromUserName"];

        debugPrint("🟡 websocket id $messageId");
        // if (senderId.toString() == widget.senderId) {
        //   debugPrint("🟡 Skipped duplicate self message from WebSocket");
        //   return;
        // }
        bool isSelf = senderId.toString() == widget.senderId;
        if (!mounted) return;

        setState(() {
          _newMessages.add(
            Messages(
                text: messageText,
                time: timeFormate(chatTime),
                isUser: isSelf,
                isRead: false,
                messageId: messageId,
                isEdited: isEdited,
                isForwarded: isForwarded,
                forwardedFromUserName: forwardedUserName,
                editedAt: editedAt,
                replyToMessageId: replyToId,
                replyToMessageText: replyToText),
          );
        });

        if (isWebSocketConnected) {
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) _sendReadReceipt();
          });
        }
        // Scroll to bottom

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      },
    );
    stompClient.subscribe(
      destination: '/user/${widget.senderId}/queue/online-status',
      callback: (frame) {
        debugPrint('Presence update received body.....,: ${frame.body}');
        final data = jsonDecode(frame.body!);
        final int presenceUserId = data['targetUserId'];
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
      destination: '/user/${widget.senderId}/queue/message-edited',
      callback: (editBody) {
        debugPrint("Typing status from other user: ${editBody.body}");
        if (editBody.body == null || !mounted) return;

        final Map<String, dynamic> editedMessage = jsonDecode(editBody.body!);

        final int editedMessageId = editedMessage["messageId"];
        final String newText = editedMessage["newContent"];
        final String? newEditedAt = editedMessage["editedAt"];

        bool updated = false;

        setState(() {
          for (var msg in _newMessages) {
            if (msg.messageId == editedMessageId) {
              msg.text = newText;
              msg.editedAt = newEditedAt;
              msg.isEdited = true;
              updated = true;
              break;
            }
          }

          if (!updated) {
            for (var msg in allMessages) {
              if (msg.messageId == editedMessageId) {
                msg.text = newText;
                msg.editedAt = newEditedAt;
                msg.isEdited = true;
                break;
              }
            }
          }
        });

        if (updated) {
          debugPrint("✅ Message with ID $editedMessageId updated");
        } else {
          debugPrint(
              "⚠️ Edited message ID $editedMessageId not found in local list");
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
    debugPrint('payload for reply....$message');
    stompClient.send(
      destination: '/app/chat',
      body: _controller.text.isNotEmpty ? jsonEncode(message) : "",
    );
    setState(() {
      _controller.clear();
      repliedMessage = null;
    });
    _scrollToBottom();
  }

  void editMessage() {
    debugPrint('payload for edit....${onEditMessage?.messageId}}');
    final message = {
      "senderId": int.parse(widget.senderId),
      "messageId": onEditMessage?.messageId,
      "newContent": _editController.text
    };
    debugPrint('payload for edit....$message');
    stompClient.send(
      destination: '/app/chat/edit',
      body: _editController.text.isNotEmpty ? jsonEncode(message) : "",
    );
    context.pop();
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

  void _forwardMessages() async {
    final result = await context.push<String>(
      '/chat_history',
      extra: {'role': widget.role, 'message': forwardMessage},
    );

    if (!mounted) return;

    if (result == 'forward') {
      setState(() {
        isForwardMessage = false;
      });

      Utils.toastSuccessMessage('Forward message sent!');
    }
  }

  final List<Messages> _newMessages = [];
  List<Messages> allMessages = [];
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendPresence() {
    if (!stompClient.connected) return;
    stompClient.send(
      destination: '/app/check-online',
      body: jsonEncode({
        "requesterId": int.parse(widget.senderId),
        "targetUserId": int.parse(widget.receiverId),
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
        automaticallyImplyLeading: !(onClickSearch || isForwardMessage),
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
            : isForwardMessage
                ? _onSelectMessage()
                : _buildHeader(isOnline: isReceiverOnline),
        backgroundColor: ColorConstants.white,
        shadowColor: ColorConstants.white,
        elevation: 2,
        actions: [
          (onClickSearch || isForwardMessage)
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
                  child: BlocBuilder<ChatBloc, ChatState>(
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
                        final history = state.chatData
                                .map((chat) => Messages(
                                    text: chat.message ?? '',
                                    time: timeFormate(chat
                                        .timestamp), // Or use formatted chat.createdAt
                                    isUser: chat.senderId.toString() ==
                                        widget.senderId,
                                    messageId: chat.messageId,
                                    replyToMessageId: chat.replyToMessageId,
                                    isEdited: chat.isEdited,
                                    isForwarded: chat.isForwarded,
                                    editedAt: chat.editedAt,
                                    forwardedFromUserName:
                                        chat.forwardedFromUserName,
                                    replyToMessageText: chat.replyToMessageText,
                                    isRead: chat.isRead ?? false))
                                .toList() ??
                            [];
                        allMessages = [...history, ..._newMessages];
                        if (_isOtherUserTyping) {
                          allMessages.add(Messages(
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
                                // physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  debugPrint(
                                      'forwared message,,,,,,,,,,,,,,${allMessages[index]}');
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
                Offstage(
                  offstage: !emojiShowing,
                  child: EmojiPicker(
                    textEditingController: _controller,
                    scrollController: _emojiScrollController,
                    config: Config(
                      height: 256,
                      checkPlatformCompatibility: true,
                      searchViewConfig: const SearchViewConfig(),
                      viewOrderConfig: ViewOrderConfig(
                          top: EmojiPickerItem.searchBar,
                          middle: EmojiPickerItem.emojiView,
                          bottom: EmojiPickerItem.categoryBar),
                      emojiViewConfig: EmojiViewConfig(
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 28 *
                            (foundation.defaultTargetPlatform ==
                                    TargetPlatform.iOS
                                ? 1.2
                                : 1.0),
                      ),
                      skinToneConfig: const SkinToneConfig(),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: const BottomActionBarConfig(),
                    ),
                  ),
                ),
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

  Widget _onSelectMessage() {
    final bool canEdit = onEditMessage?.isUser == true &&
        isWithin15Minutes(onEditMessage?.time ?? '');

    return Row(
      children: [
        _iconButton(
            onTap: () {
              setState(() {
                isForwardMessage = false;
              });
            },
            icon: Icon(Icons.arrow_back)),
        SizedBox(width: 10),
        Text('1'),
        Spacer(),
        _iconButton(
            onTap: () {
              setState(() {
                repliedMessage = onClickRepliedMessage;
                isForwardMessage = false;
              });
            },
            icon: Image.asset(
              replyArrowImg,
              width: 25,
              height: 25,
            )),
        (canEdit)
            ? _iconButton(
                onTap: () {
                  setState(() {
                    isForwardMessage = false;
                    isEditable = true;
                    _editController.text = onEditMessage?.text ?? '';
                    selectMessage = onEditMessage?.text ?? '';
                  });

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showEditModal();
                  });
                },
                icon: Text('Edit'))
            : SizedBox(width: 20),
        widget.role == 'CA'
            ? _iconButton(
                onTap: _forwardMessages,
                icon: Image.asset(
                  forwardAllImg,
                  height: 25,
                  width: 25,
                ))
            : SizedBox.shrink(),
        SizedBox(width: 10)
      ],
    );
  }

  Future<bool?> _showEditModal() {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Edit your message',
                            style: TextStyle(fontSize: 18)),
                        IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ColorConstants.buttonColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5))),
                        // alignment: Alignment.topRight,
                        child: Text(
                          '$selectMessage ',
                          style: AppTextStyle().smallbuttontext,
                        ),
                      ),
                    ),
                    TextField(
                      controller: _editController,
                      decoration: InputDecoration(
                        hintText: 'Enter new message...',
                        // ignore: deprecated_member_use
                        fillColor: ColorConstants.buttonColor.withOpacity(0.2),
                        filled: true,
                        prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.emoji_emotions,
                              color: Colors.amber,
                            )),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: ColorConstants.buttonColor,
                          ),
                          onPressed: editMessage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(Messages message) {
    if (message.text == '__TYPING_INDICATOR__') {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TypingIndicator(name: widget.name)),
      );
    }
    bool isSelected =
        isForwardMessage && forwardMessage?.messageId == message.messageId;
    return Stack(
      children: [
        Align(
          alignment:
              message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity! > 0) {
                // Swiped right → trigger reply
                setState(() {
                  repliedMessage = message;
                });
              }
            },
            onLongPress: () {
              setState(() {
                isForwardMessage = true;
                onClickSearch = false;
                forwardMessage = message;
                onClickRepliedMessage = message;
                onEditMessage = message;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .8),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blueGrey : Colors.grey[200],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(message.isUser ? 12 : 0),
                    bottomRight: Radius.circular(message.isUser ? 0 : 12)),
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.isForwarded == true)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              forwardAllImg,
                              width: 18,
                              height: 20,
                              color: message.isUser
                                  ? ColorConstants.white
                                  : ColorConstants.black,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Forwarded',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: message.isUser
                                      ? ColorConstants.white
                                      : ColorConstants.black,
                                  fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    if (message.replyToMessageText != null)
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                        padding: EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                            border: Border(
                                left: BorderSide(
                                    width: 4,
                                    color: ColorConstants.buttonColor))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.isUser ? 'You' : widget.name,
                              style: AppTextStyle().labletext,
                            ),
                            Text(
                              message.replyToMessageText!,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        alignment: WrapAlignment.end,
                        runSpacing: 0,
                        spacing: 0,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                                color: message.isUser
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (message.isEdited != null &&
                                  message.isEdited == true)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    'Edited',
                                    style: AppTextStyle().landingSubtitletext22,
                                  ),
                                ),
                              Text(
                                message.time,
                                style: TextStyle(
                                  color: message.isUser
                                      ? Colors.white
                                      : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                              if (message.isUser)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Icon(
                                    message.isRead
                                        ? Icons.done_all
                                        : Icons.check,
                                    size: 19,
                                    color: message.isRead
                                        ? ColorConstants.white
                                        : ColorConstants.white,
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isSelected)
          Positioned.fill(
            child: InkWell(
              onTap: () {
                setState(() {
                  isForwardMessage = false;
                  forwardMessage = null;
                });
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: ColorConstants.buttonColor.withOpacity(0.2)),
              ),
            ),
          )
      ],
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
                    emojiShowing ? Icons.keyboard : Icons.emoji_emotions,
                    color: Colors.orangeAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      emojiShowing = !emojiShowing;
                      if (emojiShowing) {
                        FocusScope.of(context).unfocus(); // hide keyboard
                      } else {
                        FocusScope.of(context)
                            .requestFocus(_focusNode); // show keyboard
                      }
                    });
                  }),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  onTap: () {
                    if (emojiShowing) {
                      setState(() {
                        emojiShowing = false;
                      });
                    }
                  },
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
                  onPressed: sendMessage),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton({required VoidCallback onTap, required Widget icon}) {
    return IconButton(onPressed: onTap, icon: icon);
  }
}

class Messages {
  String text;
  final String time;
  final bool isUser;
  final dynamic isForwarded;
  dynamic forwardedFromUserName;
  dynamic editedAt;
  dynamic isEdited;
  bool isRead;
  final int? messageId;
  final int? replyToMessageId;
  final String? replyToMessageText;
  Messages(
      {required this.text,
      required this.time,
      required this.isUser,
      required this.isRead,
      this.isForwarded,
      this.forwardedFromUserName,
      this.editedAt,
      this.isEdited,
      this.messageId,
      this.replyToMessageId,
      this.replyToMessageText});
}
