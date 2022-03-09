import 'dart:async';

import 'package:flutter/material.dart';
import 'package:labyrinth/widgets/home/room_wait_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/providers/socket_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';

class RoomScreen extends StatefulWidget {
  final bool isCreator;
  const RoomScreen({
    Key? key,
    this.isCreator = false,
  }) : super(key: key);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  RoomModel? _room;
  UserModel? _currentUser;

  final _valueEvent = ValueNotifier(RoomScreenStatus.none);

  @override
  void initState() {
    super.initState();

    Timer.run(() => _socket());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _socket() {
    _room = Provider.of<RoomModel>(context, listen: false);
    _currentUser = Provider.of<UserModel>(context, listen: false);
    socketService!.updateRoom(
      _room!,
      _currentUser!,
      update: (data) {
        var type = data['id'];
        if (type == 'join_user') _joinUser(data);
        if (type == 'remove_room') _removeRoom(data);
        if (type == 'leave_user') _leaveUser(data);
      },
    );
    if (widget.isCreator) {
      socketService!.joinRoom(_room!, _currentUser!);
    }
  }

  void _joinUser(dynamic data) async {
    var usrID = data['title'] as String;
    var resp = await NetworkProvider.of().post(
      kGetUser,
      {
        'id': usrID.replaceAll('user', ''),
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var addUser = UserModel()..setFromJson(resp['result']);
        _room!.addUser(addUser);
        return;
      } else {
        if (mounted) {
          DialogProvider.of(context).showSnackBar(
            resp['msg'],
            type: SnackBarType.error,
          );
        }
      }
    } else {
      if (mounted) {
        DialogProvider.of(context).showSnackBar(
          S.current.server_error,
          type: SnackBarType.error,
        );
      }
    }
    Navigator.of(context).pop();
  }

  void _removeRoom(dynamic data) async {
    if (_room!.getStatus().isWaiting) {
      DialogProvider.of(context).showSnackBar(
        'This room was removed by creator',
        type: SnackBarType.info,
      );
      Navigator.of(context).pop();
    } else {}
  }

  void _leaveUser(dynamic data) async {
    var usrID = (data['title'] as String).replaceAll('user', '');
    _room!.removeUser(usrID);
  }

  @override
  Widget build(BuildContext context) {
    var _currentUser = Provider.of<UserModel>(context, listen: false);
    return Consumer<RoomModel>(
      builder: (context, room, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: room.name.semiBoldText(
              fontSize: fontXMd,
              color: kAccentColor,
            ),
            leading: Container(),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(LineIcons.userFriends),
              ),
            ],
          ),
          body: ValueListenableBuilder(
            builder: (context, value, child) {
              return room.getStatus().isWaiting
                  ? RoomWaitWidget(
                      currentUser: _currentUser,
                      status: _valueEvent.value,
                      room: room,
                      joinUser: () => _joinToUser(),
                    )
                  : Container();
            },
            valueListenable: _valueEvent,
          ),
        );
      },
    );
  }

  void _joinToUser() async {
    if (_valueEvent.value != RoomScreenStatus.none) {
      return;
    }
    _valueEvent.value = RoomScreenStatus.joinUser;
    var resp = await NetworkProvider.of().post(
      kJoinRoom,
      {
        'roomid': _room!.id,
        'userid': _currentUser!.id!,
      },
    );
    _valueEvent.value = RoomScreenStatus.none;
    if (resp != null) {
      if (resp['ret'] == 10000) {
        socketService!.joinRoom(_room!, _currentUser!);
      }
    }
  }
}

enum RoomScreenStatus {
  none,
  joinUser,
  joinTour,
}
