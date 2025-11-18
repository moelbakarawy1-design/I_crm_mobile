import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  IO.Socket? socket;
  bool _isConnecting = false;
  bool _isDisposed = false;
  Completer<bool>? _connectionCompleter;

  Future<bool> connect() async {
    if (socket != null && socket!.connected) {
      print('✅ Socket already connected: ${socket!.id}');
      return true;
    }

    if (_isConnecting && _connectionCompleter != null) {
      print('⏳ Connection already in progress, waiting...');
      return await _connectionCompleter!.future;
    }

    final token = LocalData.accessToken;
    if (token == null || token.isEmpty) {
      print('❌ Cannot connect socket: No auth token available');
      return false;
    }

    _isConnecting = true;
    _connectionCompleter = Completer<bool>();

    try {
      print('🔗 Connecting to Socket.IO: ${EndPoints.socketUrl}');
      if (socket != null) {
        socket!.dispose();
        socket = null;
      }

     socket = IO.io(
  EndPoints.socketUrl,
  IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .enableReconnection()
      .setReconnectionAttempts(3)
      .setAuth({'token': token})  
      .build(),
);


      // ✅ Listeners
      socket!.onConnect((_) {
        if (_isDisposed) return;
        print('✅ Socket connected: ${socket!.id}');
        _isConnecting = false;

        // ✅ Listen for *all* incoming events for debugging
        socket!.onAny((event, data) {
          print('📡 [SOCKET EVENT] $event => $data');
        });

        if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
          _connectionCompleter!.complete(true);
        }
      });

      socket!.onDisconnect((reason) {
        if (_isDisposed) return;
        print('⚠️ Socket disconnected: $reason');
      });

      socket!.onConnectError((error) {
        if (_isDisposed) return;
        print('⚠️ Connection error: $error');
        if (!_connectionCompleter!.isCompleted) _connectionCompleter!.complete(false);
      });

      print('📡 Initiating connection...');
      socket!.connect();

      final connected = await _connectionCompleter!.future.timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print('⚠️ Connection timeout after 10 seconds');
          _isConnecting = false;
          return false;
        },
      );

      return connected;
    } catch (e) {
      print('❌ Socket connection exception: $e');
      if (!_connectionCompleter!.isCompleted) _connectionCompleter!.complete(false);
      return false;
    }
  }

  /// 🟢 Join specific chat room
  void joinChat(String chatId) {
    if (socket?.connected ?? false) {
      socket?.emit('join_chat', {'chatId': chatId});
      print('📡 Joined chat room: $chatId');
    } else {
      print('❌ Cannot join chat: socket not connected');
    }
  }

  /// 🟡 Send message event
  Future<void> sendMessage(String chatId, String message) async {
  if (!(socket?.connected ?? false)) {
    print('⏳ Socket not connected, waiting to connect...');
    final connected = await connect();
    if (!connected) {
      print('❌ Failed to connect socket. Message not sent.');
      return;
    }
  }

  socket?.emit('send_message', {
    'chatId': chatId,
    'message': message,
  });

  print('📤 Message sent via socket → $message');
}


  /// 🟢 Listen for new message
  void onNewMessage(Function(dynamic) callback) {
    socket?.off('newMessage');
    socket?.on('newMessage', (data) {
      print('📥 [newMessage] => $data');
      callback(data);
    });
  }

  /// 🟣 Listen for receive_message (some servers use this name)
  void onReceiveMessage(Function(dynamic) callback) {
    socket?.off('receive_message');
    socket?.on('receive_message', (data) {
      print('📩 [receive_message] => $data');
      callback(data);
    });
  }

  /// 🔄 Listen for message status updates
  void onMessageStatusUpdated(Function(dynamic) callback) {
    socket?.off('messageStatusUpdated');
    socket?.on('messageStatusUpdated', (data) {
      print('🔄 [messageStatusUpdated] => $data');
      callback(data);
    });
  }
  

  void disconnect() {
    _isDisposed = true;
    print('🔌 Disconnecting socket...');
    socket?.disconnect();
    socket?.dispose();
    socket = null;
    _isConnecting = false;
  }
}
