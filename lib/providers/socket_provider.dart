import 'package:flutter/foundation.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

SocketProvider? socketService;

class SocketProvider {
  io.Socket? _socket;
  UserModel? _owner;

  SocketProvider();

  factory SocketProvider.instance(UserModel user) {
    if (socketService == null) {
      return socketService = SocketProvider().._init(user);
    }
    return socketService!;
  }

  void _init(UserModel user) {
    if (_socket == null) {
      _owner = user;
      _socket = io.io(
        kSocketUrl,
        io.OptionBuilder()
            .setTransports(["websocket"])
            .disableAutoConnect()
            .build(),
      );
      _socket!.connect();

      _socket!.onConnect((_) {
        if (kDebugMode) {
          print('[SOCKET] connected');
        }
        var param = {
          'id': 'user${_owner!.id}',
          'name': _owner!.usrName,
          'type': 'user',
        };
        _socket!.emit(
          'self',
          param,
        );
      });

      _socket!.onDisconnect((_) {
        if (kDebugMode) {
          print('[SOCKET] disconnect');
        }
      });

      _socket!.onConnectError((data) {
        if (kDebugMode) {
          print('[SOCKET] onConnectError : $data');
        }
      });

      _socket!.onError((data) {
        if (kDebugMode) {
          print('[SOCKET] onError : $data');
        }
      });

      _socket!.on("notification", (value) {
        if (kDebugMode) {
          print("[SOCKET] receive notification ===> ${value.toString()}");
        }
      });
    }
  }

  io.Socket? getSocket() {
    return _socket!;
  }
}
