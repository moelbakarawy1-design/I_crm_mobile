import 'dart:async';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/featuer/Auth/data/repository/auth_repository.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  // 1. Singleton Pattern: Ensures only one instance exists in the app
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  // Variables
  IO.Socket? _socket;
  bool _isConnecting = false;
  Completer<bool>? _connectionCompleter;

  // 2. Broadcast Streams (Solves the multiple listener problem)
  // Allows both ChatCubit and MessagesCubit to listen simultaneously.
  final _newMessageController = StreamController<dynamic>.broadcast();
  final _messageStatusController = StreamController<dynamic>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();
  final _roleUpdatedController = StreamController<dynamic>.broadcast();

  // Getters for Streams
  Stream<dynamic> get newMessageStream => _newMessageController.stream;
  Stream<dynamic> get messageStatusStream => _messageStatusController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;
  Stream<dynamic> get roleUpdatedStream => _roleUpdatedController.stream;

  IO.Socket? get socket => _socket;
  bool get isConnected => _socket?.connected ?? false;

  /// 🔗 Connect to Socket
  Future<bool> connect() async {
    if (isConnected) {
      print('✅ [SocketService] Already connected: ${_socket!.id}');
      return true;
    }

    if (_isConnecting) {
      print('⏳ [SocketService] Connection in progress...');
      return _connectionCompleter?.future ?? Future.value(false);
    }

    final token = LocalData.accessToken;
    if (token == null || token.isEmpty) {
      print('❌ [SocketService] No auth token available');
      return false;
    }

    _isConnecting = true;
    _connectionCompleter = Completer<bool>();

    try {
      print('🔗 [SocketService] Connecting to: ${EndPoints.socketUrl}');
      
      // Cleanup previous instance if exists
      _socket?.dispose();

      _socket = IO.io(
        EndPoints.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setAuth({'token': token})
            .build(),
      );

      _setupInternalListeners();

      _socket!.connect();

      // Wait for connection with timeout
      return await _connectionCompleter!.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print('⚠️ [SocketService] Connection timed out');
          _isConnecting = false;
          if (_socket != null && !_socket!.connected) {
             _socket!.disconnect();
          }
          return false;
        },
      );
    } catch (e) {
      print('❌ [SocketService] Exception: $e');
      _isConnecting = false;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.complete(false);
      }
      return false;
    }
  }

  /// 🛠 Setup Internal Listeners to feed Streams
  void _setupInternalListeners() {
    if (_socket == null) return;

    // --- Connection Events ---
    _socket!.onConnect((_) {
      print('✅ [SocketService] Connected: ${_socket!.id}');
      _isConnecting = false;
      _connectionStatusController.add(true);
      
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.complete(true);
      }
    });

    _socket!.onDisconnect((reason) {
      print('⚠️ [SocketService] Disconnected: $reason');
      _connectionStatusController.add(false);
      _isConnecting = false;
    });

    _socket!.onConnectError((error) {
      print('❌ [SocketService] Connect Error: $error');
      _isConnecting = false;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.complete(false);
      }
    });

    // --- Debug: Print all events ---
    _socket!.onAny((event, data) {
       // print('📡 [SOCKET RAW] $event'); 
    });

    // --- Data Events (Feed to Streams) ---
    
    // 1. New Message
    _socket!.on('newMessage', (data) {
      print('📥 [SocketService] New Message: $data');
      _newMessageController.add(data);
    });

    // 2. Receive Message (Alternative name)
    _socket!.on('receive_message', (data) {
       print('📥 [SocketService] Receive Message: $data');
       _newMessageController.add(data);
    });

    // 3. Status Update
    _socket!.on('messageStatusUpdated', (data) {
      print('🔄 [SocketService] Status Update: $data');
      _messageStatusController.add(data);
    });

    // 4. Role Updated
    _socket!.on('roleUpdated', (data) {
      print('👑 [SocketService] Role Updated: $data');
      _roleUpdatedController.add(data);
      // Automatically handle role update
      handleRoleUpdate();
    });
  }

  /// 🟢 Join Chat Room
  void joinChat(String chatId) {
    if (isConnected) {
      _socket!.emit('join_chat', {'chatId': chatId});
      print('👉 [SocketService] Joined Room: $chatId');
    }
  }

  /// 🔴 Leave Chat Room
  void leaveChat(String chatId) {
    if (isConnected) {
      _socket!.emit('leave_chat', {'chatId': chatId});
      print('👈 [SocketService] Left Room: $chatId');
    }
  }

  /// 📤 Send Message
  Future<void> sendMessage(String chatId, String message) async {
    if (!isConnected) {
      print('⏳ [SocketService] Reconnecting before sending...');
      final success = await connect();
      if (!success) return;
    }

    _socket!.emit('send_message', {
      'chatId': chatId,
      'message': message,
    });
    print('📤 [SocketService] Sent: $message');
  }

  /// 🔄 Handle Role Update
  Future<void> handleRoleUpdate() async {
    try {
      print('🔄 [SocketService] Handling role update...');
      
      // 1. Fetch updated user data from /users/me
      final authRepo = AuthRepository();
      final updatedUser = await authRepo.getUserProfile();
      
      print('📥 [SocketService] Fetched updated user data');
      
      // 2. Extract new role and permissions
      final newRole = updatedUser.role?.name ?? '';
      final newPermissions = updatedUser.role?.permissions ?? [];
      
      print('👑 [SocketService] New Role: $newRole');
      print('🔑 [SocketService] New Permissions: $newPermissions');
      
      // 3. Update only role and permissions in local storage
      await LocalData.updateRoleAndPermissions(
        userRole: newRole,
        permissions: newPermissions,
      );
      
      print('✅ [SocketService] Updated local storage with new role and permissions');
      
      // 4. Disconnect and reconnect socket to use new token/role
      print('🔌 [SocketService] Disconnecting socket...');
      disconnect();
      
      // Wait a bit before reconnecting
      await Future.delayed(const Duration(milliseconds: 500));
      
      print('🔗 [SocketService] Reconnecting socket with new role...');
      await connect();
      
      print('✅ [SocketService] Role update complete!');
    } catch (e) {
      print('❌ [SocketService] Error handling role update: $e');
    }
  }

  /// 🔌 Disconnect Completely
  void disconnect() {
    print('🔌 [SocketService] Disconnecting...');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnecting = false;
    // Note: We do NOT close the StreamControllers here because 
    // the app might reconnect later (e.g., logout -> login).
  }
}