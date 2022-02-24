import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/providers/socket_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/setting/setting_widget.dart';

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
        var type = data['id'];
        if (type == 'join_user') _joinUser(data);
        if (type == 'remove_room') _removeRoom(data);
        if (type == 'leave_user') _leaveUser(data);
      },
    );
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
    var usrID = data['title'] as String;
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: offsetBase,
                vertical: offsetXMd,
              ),
              child: Column(
                children: [
                  room.amount == '2'
                      ? _twoRoom(room)
                      : _fourRoom(
                          room,
                        ),
                  const SizedBox(
                    height: offsetBase,
                  ),
                  'Description'.mediumText(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _twoRoom(RoomModel room) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < 2; i++) ...{
              Container(
                width: 144.0,
                height: 144.0,
                decoration: BoxDecoration(
                  color: heroColors[i],
                  borderRadius: BorderRadius.circular(offsetSm),
                  boxShadow: [
                    kTopLeftShadow,
                    kBottomRightShadow,
                  ],
                ),
                child: Center(
                  child: room.getUser(i) != null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LabyrinthAvatar(
                              url: room.getUser(i)!.usrAvatar!,
                            ),
                            const SizedBox(
                              height: offsetSm,
                            ),
                            room.getUser(i)!.usrName!.regularText(
                                  color: Colors.white,
                                  fontSize: fontSm,
                                ),
                          ],
                        )
                      : Container(),
                ),
              ),
            },
          ],
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(offsetSm),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.white, kAccentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  kTopLeftShadow,
                  kBottomRightShadow,
                ],
              ),
              child: 'VS'.mediumText(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fourRoom(RoomModel room) {
    return Container();
  }
}
