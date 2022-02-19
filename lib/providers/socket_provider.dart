import 'package:flutter/foundation.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/notification_provider.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

SocketProvider? socketService;

class SocketProvider {
  io.Socket? _socket;
  UserModel? _owner;

  SocketProvider();

  void init(UserModel user) {
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
        _socket!.emit(
          'self',
          {
            'user_id': 'user${_owner!.id}',
            'name': _owner!.usrName,
          },
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
          String title = 'Invited Friend';
          String name = value['content'];
          String description = '$name just sent a friend request.';
          switch (value['name']) {
            case 'invite_user':
              title = 'Invited';
              description = '$name just sent a friend request.';
              break;
            case 'accept_user':
              title = 'Accepted';
              description = '$name just accepted your friend request.';
              break;
            case 'decline_user':
              title = 'Declined';
              description = '$name just decline your friend request.';
              break;
          }
          NotificationProvider.showNotification(
            title: title,
            description: description,
            type: NotificationProvider.keyMessageChannel,
          );
        }
      });
    }
  }

  void updateRoomList({
    Function(dynamic)? update,
  }) {
    _socket!.on("update_room", (value) async {
      if (kDebugMode) {
        print("[Room List] update ===> ${value.toString()}");
      }
      update!(value);
    });
  }

  void updateFriend({
    Function(dynamic)? update,
  }) {
    _socket!.on("friend", (value) async {
      if (kDebugMode) {
        print("[Friend] invite ===> ${value.toString()}");
      }
      update!(value);
    });
  }

  void inviteFriend(String senderID, String receiverID) {
    _socket!.emit(
      'invite_friend',
      {
        'senderid': 'user$senderID',
        'receiverid': 'user$receiverID',
      },
    );
  }

  void acceptFriend(String senderID, String receiverID) {
    _socket!.emit(
      'accept_friend',
      {
        'senderid': 'user$senderID',
        'receiverid': 'user$receiverID',
      },
    );
  }

  void declineFriend(String senderID, String receiverID) {
    _socket!.emit(
      'decline_friend',
      {
        'senderid': 'user$senderID',
        'receiverid': 'user$receiverID',
      },
    );
  }

  void createRoom(RoomModel room, UserModel user) {
    _socket!.emit(
      'createRoom',
      {
        'room': {
          'id': 'room${room.id}',
          'name': room.name,
        },
        'userid': 'user${user.id}',
      },
    );
  }

  void joinRoom(
    RoomModel room,
    UserModel user, {
    Function(dynamic)? update,
  }) {
    _socket!.emit(
      'joinRoom',
      {
        'roomid': 'room${room.id}',
        'userid': 'user${user.id}',
      },
    );
    _socket!.on("update", (value) async {
      if (kDebugMode) {
        print("[Join Room] update ===> ${value.toString()}");
      }
      update!(value);
    });
  }

  void leaveRoom(RoomModel room, UserModel user) {
    _socket!.emit(
      'leaveRoom',
      {
        'roomid': 'room${room.id}',
        'userid': 'user${user.id}',
      },
    );
  }

  io.Socket? getSocket() {
    return _socket!;
  }
}
