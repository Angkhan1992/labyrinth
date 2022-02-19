import 'dart:async';

import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  RoomModel? _room;

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
    var user = Provider.of<UserModel>(context, listen: false);
    socketService!.joinRoom(
      _room!,
      user,
      update: (data) {
        var type = data['name'];
        if (type == 'join_user') _joinUser(data);
        if (type == 'remove_room') _removeRoom(data);
        if (type == 'leave_user') _leaveUser(data);
      },
    );
  }

  void _joinUser(dynamic data) async {
    var usrID = data['content']['usr_id'] as String;
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
            type: SnackBarType.ERROR,
          );
        }
      }
    } else {
      if (mounted) {
        DialogProvider.of(context).showSnackBar(
          S.current.server_error,
          type: SnackBarType.ERROR,
        );
      }
    }
    Navigator.of(context).pop();
  }

  void _removeRoom(dynamic data) async {
    if (_room!.getStatus().isWaiting) {
      Navigator.of(context).pop();
      DialogProvider.of(context).showSnackBar(
        'This room was removed by creator',
        type: SnackBarType.INFO,
      );
    } else {}
  }

  void _leaveUser(dynamic data) async {
    var usrID = data['content'] as String;
    _room!.removeUser(usrID);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomModel>(
      builder: (context, room, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: room.name.semiBoldText(
              fontSize: fontXMd,
              color: kAccentColor,
            ),
          ),
          body: Column(
            children: [],
          ),
        );
      },
    );
  }
}
