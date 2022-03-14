import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/loading_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/providers/socket_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/home/room_play_widget.dart';
import 'package:labyrinth/widgets/home/room_prepare_widget.dart';
import 'package:labyrinth/widgets/home/room_result_widget.dart';
import 'package:labyrinth/widgets/home/room_wait_widget.dart';

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
        if (type == 'update_status') _roomStatus(data);
        if (type == 'init_board') _initBoard(data);
      },
    );
    if (widget.isCreator) {
      socketService!.joinRoom(_room!, _currentUser!);
    }
  }

  void _joinUser(dynamic data) async {
    if (!mounted) return;
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
        _room!.addUser(
          addUser,
          joinAll: (owner) async {
            LoadingProvider.of(context).show();
            if (owner.id == _currentUser!.id) {
              var resp = await NetworkProvider.of().post(
                kUpdateRoom,
                {
                  'id': _room!.id,
                  'rm_status': RoomStatus.prepare.rawValue,
                },
              );
              if (resp != null) {
                if (resp['ret'] == 10000) {
                  socketService!.updateRoomStatus(
                    _room!,
                    RoomStatus.prepare.rawValue,
                  );
                  return;
                }
              }
            }
          },
        );
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
    if (!mounted) {
      return;
    }
    if (_room!.getStatus().isWaiting) {
      DialogProvider.of(context).showSnackBar(
        'This room was removed by creator',
        type: SnackBarType.info,
      );
      Navigator.of(context).pop();
    }
  }

  void _leaveUser(dynamic data) async {
    var usrID = (data['title'] as String).replaceAll('user', '');
    _room!.removeUser(usrID);
  }

  void _roomStatus(dynamic data) async {
    if (!mounted) return;
    LoadingProvider.of(context).hide();
    var status = data['title'] as String;
    _room!.setStatus(status.roomStatus);
  }

  void _initBoard(dynamic data) async {
    _room!.setBoardData(jsonDecode(data['title']) as List<dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    var _currentUser = Provider.of<UserModel>(context, listen: false);
    return Consumer<RoomModel>(
      builder: (context, room, child) {
        return Scaffold(
          body: Column(
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: offsetBase),
                child: room.getStatus().isPlay
                    ? Container()
                    : Row(
                        children: [
                          const SizedBox(
                            width: offsetSm,
                          ),
                          room.name.semiBoldText(
                            fontSize: fontXMd,
                            color: kAccentColor,
                          ),
                          const Spacer(),
                          room.getStatus().isWaiting
                              ? IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    LineIcons.userFriends,
                                    color: kAccentColor,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                  ),
                                ),
                        ],
                      ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  builder: (context, value, child) {
                    return room.getStatus().isWaiting
                        ? RoomWaitWidget(
                            currentUser: _currentUser,
                            status: _valueEvent.value,
                            room: room,
                            joinUser: () => _joinToUser(),
                          )
                        : room.getStatus().isPrepare
                            ? RoomPrepareWidget(
                                currentUser: _currentUser,
                                room: room,
                                onRun: () async {
                                  if (room.getUser(0)!.id! ==
                                      _currentUser.id!) {
                                    room.initBoard();
                                    socketService!.initBoardData(
                                        room, room.getBoardData());
                                  }
                                  LoadingProvider.of(context).show();
                                  if (room.isOwner(_currentUser)) {
                                    var resp = await NetworkProvider.of().post(
                                      kUpdateRoom,
                                      {
                                        'id': _room!.id,
                                        'rm_status': RoomStatus.play.rawValue,
                                      },
                                    );
                                    if (resp != null) {
                                      if (resp['ret'] == 10000) {
                                        socketService!.updateRoomStatus(
                                          _room!,
                                          RoomStatus.play.rawValue,
                                        );
                                        return;
                                      }
                                    }
                                  }
                                },
                              )
                            : room.getStatus().isPlay
                                ? RoomPlayWidget(
                                    room: room,
                                  )
                                : RoomResultWidget(
                                    room: room,
                                  );
                  },
                  valueListenable: _valueEvent,
                ),
              ),
            ],
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
