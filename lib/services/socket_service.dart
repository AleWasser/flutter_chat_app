import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket? get socket => _socket;

  Function get emit => _socket!.emit;

  void connect() async {
    final token = await AuthService.getToken();

    _socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    _socket?.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket?.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket?.disconnect();
  }
}
