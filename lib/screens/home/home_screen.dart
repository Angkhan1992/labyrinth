import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/loading_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/providers/socket_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/button.dart';
import 'package:labyrinth/widgets/home/home_widget.dart';
import 'package:labyrinth/screens/home/room_screen.dart';
import 'package:labyrinth/widgets/textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  final List<RoomModel> _pendingRooms = [];
  final List<RoomModel> _activeRooms = [];

  @override
  void initState() {
    super.initState();

    Timer.run(() => _initData());
  }

  void _initData() async {
    var currentUser = Provider.of<UserModel>(context, listen: false);
    var resp = await NetworkProvider.of().post(
      kGetRooms,
      {
        'id': currentUser.id!,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        _pendingRooms.clear();
        _activeRooms.clear();
        var rooms = (resp['result'] as List)
            .map((e) => RoomModel()..setFromJson(e))
            .toList();
        for (var room in rooms) {
          if (room.getStatus().isWaiting) {
            _pendingRooms.add(room);
          } else {
            _activeRooms.add(room);
          }
        }
        setState(() {});
        if (kDebugMode) {
          print('[Home] rooms : ${rooms.length}');
        }
      }
    }
    socketService!.updateRoomList(
      update: _updateRoom,
    );
  }

  void _updateRoom(dynamic data) {
    if (!mounted) {
      return;
    }
    var currentUser = Provider.of<UserModel>(context, listen: false);

    var type = data['id'] as String;
    if (type == 'create_room') _socketCreateRoom(user: currentUser, data: data);
    if (type == 'join_room') _socketJoinRoom(user: currentUser, data: data);
    if (type == 'remove_room') _socketRemoveRoom(user: currentUser, data: data);
    if (type == 'leave_user') _socketLeaveUser(user: currentUser, data: data);
    if (type == 'leave_tour') _socketLeaveTour(user: currentUser, data: data);
    if (type == 'update_status') {
      _socketRoomStatus(user: currentUser, data: data);
    }
  }

  void _socketCreateRoom({
    UserModel? user,
    dynamic data,
  }) async {
    var roomid = (data['title'] as String).replaceAll('room', '');
    var resp = await NetworkProvider.of().post(
      kGetRoom,
      {
        'roomid': roomid.replaceAll('room', ''),
        'userid': user!.id!,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var isContained = false;
        for (var room in _pendingRooms) {
          if (room.id == roomid) {
            isContained = true;
            break;
          }
        }
        for (var room in _activeRooms) {
          if (room.id == roomid) {
            isContained = true;
            break;
          }
        }
        if (isContained) {
          return;
        }
        var room = RoomModel()..setFromJson(resp['result']);
        _pendingRooms.insert(0, room);
        setState(() {});
      }
    }
  }

  void _socketJoinRoom({
    UserModel? user,
    dynamic data,
  }) async {
    var roomid = (data['title'] as String).replaceAll('room', '');
    var userid = (data['content'] as String).replaceAll('user', '');
    var resp = await NetworkProvider.of().post(
      kGetUser,
      {
        'id': userid,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var user = UserModel()..setFromJson(resp['result']);
        for (var room in _pendingRooms) {
          if (roomid == room.id) {
            room.addUser(user);
          }
        }

        for (var room in _activeRooms) {
          if (roomid == room.id) {
            room.addUser(user);
          }
        }
        if (mounted) setState(() {});
      }
    }
  }

  void _socketRemoveRoom({
    UserModel? user,
    dynamic data,
  }) async {
    var roomid = (data['title'] as String).replaceAll('room', '');
    for (var room in _pendingRooms) {
      if (room.id == roomid) {
        _pendingRooms.remove(room);
        break;
      }
    }
    for (var room in _activeRooms) {
      if (room.id == roomid) {
        _pendingRooms.remove(room);
        break;
      }
    }
    setState(() {});
  }

  void _socketLeaveUser({
    UserModel? user,
    dynamic data,
  }) async {
    var roomid = (data['title'] as String).replaceAll('room', '');
    var userid = (data['content'] as String).replaceAll('user', '');
    for (var room in _pendingRooms) {
      if (room.id == roomid) {
        room.removeUser(userid);
        break;
      }
    }
    for (var room in _activeRooms) {
      if (room.id == roomid) {
        room.removeUser(userid);
        break;
      }
    }
    setState(() {});
  }

  void _socketLeaveTour({
    UserModel? user,
    dynamic data,
  }) async {}

  void _socketRoomStatus({
    UserModel? user,
    dynamic data,
  }) async {
    var roomid = (data['title'] as String).replaceAll('room', '');
    var status = data['content'] as String;
    switch (status.roomStatus) {
      case RoomStatus.waiting:
        break;
      case RoomStatus.prepare:
        for (var room in _pendingRooms) {
          if (room.id == roomid) {
            _pendingRooms.remove(room);
            room.setStatus(status.roomStatus);
            _activeRooms.insert(0, room);
            break;
          }
        }
        break;
      case RoomStatus.play:
        for (var room in _activeRooms) {
          if (room.id == roomid) {
            room.setStatus(status.roomStatus);
            break;
          }
        }
        break;
      case RoomStatus.result:
        for (var room in _activeRooms) {
          if (room.id == roomid) {
            _activeRooms.remove(room);
            break;
          }
        }
        break;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: S.current.home.semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
        leading: Container(),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: offsetBase,
            vertical: offsetXMd,
          ),
          child: Column(
            children: [
              _createWidget(),
              const SizedBox(
                height: offsetXMd,
              ),
              _pendingWidget(),
              const SizedBox(
                height: offsetXMd,
              ),
              _activeWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createWidget() {
    return Column(
      children: [
        Row(
          children: [
            S.current.create_match.thinText(),
            const Spacer(),
            HelpButton(
              onClick: () {},
            ),
          ],
        ),
        const SizedBox(
          height: offsetSm,
        ),
        Row(
          children: [
            CreateRoomWidget(
              icon: const Icon(
                Icons.looks_two_outlined,
                color: Colors.white,
              ),
              title: 'Create\n2 ${S.current.match_game}',
              color: Colors.green,
              onClick: () => _dialogCreateRoom('2'),
            ),
            const SizedBox(
              width: offsetBase,
            ),
            CreateRoomWidget(
              icon: const Icon(
                Icons.looks_4_outlined,
                color: Colors.white,
              ),
              title: 'Create\n4 ${S.current.match_game}',
              color: Colors.red,
              onClick: () => _dialogCreateRoom('4'),
            ),
          ],
        ),
      ],
    );
  }

  void _dialogCreateRoom(String amount) {
    var _nameController = TextEditingController();
    DialogProvider.of(context).bubbleDialog(
      child: Column(
        children: [
          'You can create a room per a day'.mediumText(),
          const SizedBox(
            height: offsetBase,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              'Room Name'.thinText(fontSize: fontSm),
              const SizedBox(
                height: fontXSm,
              ),
              CustomTextField(
                controller: _nameController,
                textInputAction: TextInputAction.done,
                hintText: 'Room Name',
                prefixIcon: const Icon(Icons.drive_file_rename_outline_sharp),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: offsetSm),
          child: S.current.cancel.button(
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: offsetSm),
          child: S.current.create.button(
            onPressed: () {
              Navigator.of(context).pop();
              var name = _nameController.text;
              if (name.isEmpty) {
                DialogProvider.of(context).showSnackBar(
                  'Please input room name',
                  type: SnackBarType.waring,
                );
                return;
              }
              _createRoom(name, amount);
            },
          ),
        ),
      ],
    );
  }

  void _createRoom(String name, String amount) async {
    var currentUser = Provider.of<UserModel>(context, listen: false);
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kCreateRoom,
      {
        'user_id': currentUser.id!,
        'name': name,
        'amount': amount,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var currentRoom = Provider.of<RoomModel>(context, listen: false);
        currentRoom.setFromJson(resp['result']);
        socketService!.createRoom(currentRoom, currentUser);
        List<String> ids = (resp['result']['notification'] as List)
            .map((e) => e.toString())
            .toList();
        if (kDebugMode) {
          print('[Notification] IDS : $ids');
        }
        for (var id in ids) {
          socketService!.notiRoom(currentRoom, id);
        }

        NavigatorProvider.of(context).push(
          screen: const RoomScreen(
            isCreator: true,
          ),
          pop: (val) {
            if (val != null) {
              _leaveRoom(currentRoom, currentUser);
            }
          },
        );
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.error,
        );
      }
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.error,
      );
    }
  }

  Widget _pendingWidget() {
    return Column(
      children: [
        Row(
          children: [
            S.current.pending_room.thinText(
              color: Colors.red,
            ),
            const Spacer(),
            HelpButton(
              onClick: () {},
            ),
          ],
        ),
        const SizedBox(
          height: offsetSm,
        ),
        _pendingRooms.isEmpty
            ? SizedBox(
                height: 90.0,
                child: Center(
                  child: 'Have not any room yet'.thinText(
                    fontSize: fontSm,
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  var room = _pendingRooms[index];
                  return room.listWidget(
                    detail: () {
                      var currentRoom =
                          Provider.of<RoomModel>(context, listen: false);
                      currentRoom.setFromJson(room.toJson());
                      NavigatorProvider.of(context).push(
                        screen: const RoomScreen(),
                        pop: (val) {
                          if (val != null) {
                            if (!mounted) return;
                            var currentUser = Provider.of<UserModel>(
                              context,
                              listen: false,
                            );
                            _leaveRoom(room, currentUser);
                          }
                        },
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: offsetSm,
                  );
                },
                itemCount: _pendingRooms.length,
              ),
      ],
    );
  }

  Widget _activeWidget() {
    return Column(
      children: [
        Row(
          children: [
            S.current.active_room.thinText(
              color: Colors.green,
            ),
            const Spacer(),
            HelpButton(
              onClick: () {},
            ),
          ],
        ),
        const SizedBox(
          height: offsetSm,
        ),
        _activeRooms.isEmpty
            ? SizedBox(
                height: 90.0,
                child: Center(
                  child: 'Have not any room yet'.thinText(
                    fontSize: fontSm,
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  var room = _activeRooms[index];
                  return room.listWidget(
                    isStatus: true,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: offsetSm,
                  );
                },
                itemCount: _activeRooms.length,
              ),
      ],
    );
  }

  void _leaveRoom(RoomModel room, UserModel user) async {
    LoadingProvider.of(context).show();
    await NetworkProvider.of().post(
      kLeaveUser,
      {
        'room_id': room.id,
        'user_id': user.id!,
      },
    );
    LoadingProvider.of(context).hide();
    socketService!.leaveRoom(room, user);
  }
}
