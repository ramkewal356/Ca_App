import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

typedef OnMessageReceived = void Function(Map<String, dynamic> data);
typedef OnPresenceReceived = void Function(bool isOnline);
typedef OnConnected = void Function();

class WebSocketService {
  late StompClient _stompClient;
  bool isConnected = false;

  void connect({
    required String senderId,
    required OnConnected onConnect,
    required OnMessageReceived onMessage,
    required OnPresenceReceived onPresence,
  }) {
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'https://cabaonline.xyz/api/chat-websocket?user-id=$senderId',
        onConnect: (StompFrame frame) {
          debugPrint('✅ WebSocket Connected');
          isConnected = true;
          _subscribeToTopics(senderId, onMessage, onPresence);
          onConnect();
        },
        onWebSocketError: (error) => debugPrint('WebSocket Error: $error'),
        onDisconnect: (_) {
          isConnected = false;
          debugPrint('WebSocket Disconnected');
        },
        onDebugMessage: (msg) => debugPrint('DEBUG: $msg'),
      ),
    );

    _stompClient.activate();
  }

  void _subscribeToTopics(
    String senderId,
    OnMessageReceived onMessage,
    OnPresenceReceived onPresence,
  ) {
    _stompClient.subscribe(
      destination: '/user/$senderId/queue/messages',
      callback: (frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          onMessage(data);
        }
      },
    );

    _stompClient.subscribe(
      destination: '/user/$senderId/queue/presence',
      callback: (frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          final isOnline = data['online'] == true;
          onPresence(isOnline);
        }
      },
    );
  }

  void sendPresence(String senderId, String receiverId) {
    if (!isConnected) return;
    final payload = {
      "requesterId": int.parse(senderId),
      "targetUserId": int.parse(receiverId),
    };
    debugPrint("📤 Sending presence: $payload");

    _stompClient.send(
      destination: '/app/check-online',
      body: jsonEncode(payload),
    );
  }

  void sendMessage(Map<String, dynamic> message) {
    if (!isConnected) return;
    _stompClient.send(
      destination: '/app/chat',
      body: jsonEncode(message),
    );
  }

  void disconnect() {
    if (isConnected) {
      _stompClient.deactivate();
    }
  }
}
