import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:ca_app/utils/constanst/text_style.dart';
import 'package:ca_app/widgets/custom_layout.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatScreen extends StatefulWidget {
  final String name;
  final String profileImg;
  final String title;
  final bool isOnline;
  const ChatScreen(
      {super.key,
      required this.name,
      required this.profileImg,
      required this.title,
      required this.isOnline});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late WebSocketChannel channel;
  @override
  void initState() {
    super.initState();
    // channel = WebSocketChannel.connect(
    //   Uri.parse(
    //       'ws://cabaonline.xyz/api/chat-websocket'), // e.g., ws://echo.websocket.org
    // );
    wsconnect();
  }

  void wsconnect() async {
    try {
      final wsUrl = Uri.parse('wss://cabaonline.xyz/api/chat-websocket');
      channel = WebSocketChannel.connect(wsUrl);
      print("WebSocket connected!");
    } catch (e) {
      print("WebSocket connection failed: $e");
    }
  }

  final List<Message> _messages = [
    Message(
        text:
            "Hello! I'm Jennifer. How can I help you with your accounting needs today?",
        time: "10:30 AM",
        isUser: false),
    Message(text: "Hello!", time: "10:31 AM", isUser: true),
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    final now = TimeOfDay.now();
    final formattedTime = now.format(context);
    final userMsg = _controller.text.trim();
    channel.sink.add(userMsg); // Send plain string

    setState(() {
      _messages.add(Message(text: userMsg, time: formattedTime, isUser: true));
      _controller.clear();
    });
    // Scroll to bottom after short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomLayoutPage(
      bgColor: ColorConstants.white,
      appBar: AppBar(
        // title: Text(
        //   'Ca Details',
        //   style: AppTextStyle().cardLableText,
        // ),
        titleSpacing: 0,
        toolbarHeight: 90,
        title: _buildHeader(),
        backgroundColor: ColorConstants.white,
        shadowColor: ColorConstants.white,
        elevation: 2,
      ),
      child: Column(
        children: [
          // _buildHeader(),
          SizedBox(height: 8),
          Expanded(
            child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final now = TimeOfDay.now();
                    final formattedTime = now.format(context);

                    _messages.add(
                      Message(
                          text: snapshot.data.toString(),
                          time: formattedTime,
                          isUser: false),
                    );

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      }
                    });
                  }

                  return ListView.builder(
                    reverse: false,
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  );
                }),
          ),

          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      horizontalTitleGap: 10,
      visualDensity: VisualDensity(horizontal: -4),
      leading: CircleAvatar(
        radius: 35,
        backgroundImage: widget.profileImg.isEmpty
            ? AssetImage(clientImg)
            : Image.network(
                widget.profileImg,
                fit: BoxFit.cover,
              ).image, // Replace with NetworkImage or other source
      ),
      title: Text(widget.name, style: AppTextStyle().cardLableText),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppTextStyle().rating10,
          ),
          Text("● ${widget.isOnline == true ? 'Online' : 'Offline'}",
              style: widget.isOnline == true
                  ? AppTextStyle().onlineText
                  : AppTextStyle().offlineText),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blueGrey[700] : Colors.grey[200],
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
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(
                color: message.isUser ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: "Type your message....."),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.emoji_emotions,
                color: Colors.orangeAccent,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.send,
                color: ColorConstants.buttonColor,
              ),
              onPressed: _sendMessage),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final String time;
  final bool isUser;

  Message({required this.text, required this.time, required this.isUser});
}
