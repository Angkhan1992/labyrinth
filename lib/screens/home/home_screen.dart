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

  var _notifyPendingRooms = ValueNotifier<List<RoomModel>>([]);
  var _notifyActiveRooms = ValueNotifier<List<RoomModel>>([]);

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
        List<RoomModel> pendingRooms = [];
        List<RoomModel> activeRooms = [];
        var rooms = (resp['result'] as List)
            .map((e) => RoomModel()..setFromJson(e))
            .toList();
        for (var room in rooms) {
          if (room.getStatus().isWaiting) {
            pendingRooms.add(room);
          } else {
            activeRooms.add(room);
          }
        }
        if (kDebugMode) {
          print('[Home] rooms : ${rooms.length}');
        }
        _notifyPendingRooms.value = pendingRooms;
        _notifyActiveRooms.value = activeRooms;
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
    switch (type) {
      case 'create_room':
        _socketCreateRoom(
          user: currentUser,
          data: data,
        );
        break;
      case 'join_room':
        _socketJoinRoom(
          user: currentUser,
          data: data,
        );
        break;
      case 'remove_room':
        _socketRemoveRoom(
          user: currentUser,
          data: data,
        );
        break;
      case 'leave_user':
        _socketLeaveUser(
          user: currentUser,
          data: data,
        );
        break;
      case 'leave_tour':
        _socketLeaveTour(
          user: currentUser,
          data: data,
        );
        break;
    }
  }

  void _socketCreateRoom({
    UserModel? user,
    dynamic data,
  }) async {
    var roomid = data['title'] as String;
    var resp = await NetworkProvider.of().post(
      kGetRoom,
      {
        'roomid': roomid.replaceAll('room', ''),
        'userid': user!.id!,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var room = RoomModel()..setFromJson(resp['result']);
        var _pendingRooms = _notifyPendingRooms.value;
        _notifyPendingRooms.value = _pendingRooms..add(room);
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
        var _pendingRoom = _notifyPendingRooms.value;
        for (var room in _pendingRoom) {
          if (roomid == room.id) {
            room.addUser(user);
          }
        }
        _notifyPendingRooms.value = _pendingRoom;

        var _activeRoom = _notifyActiveRooms.value;
        for (var room in _activeRoom) {
          if (roomid == room.id) {
            room.addUser(user);
          }
        }
        _notifyActiveRooms.value = _activeRoom;
      }
    }
  }

  void _socketRemoveRoom({
    UserModel? user,
    dynamic data,
  }) async {}

  void _socketLeaveUser({
    UserModel? user,
    dynamic data,
  }) async {}

  void _socketLeaveTour({
    UserModel? user,
    dynamic data,
  }) async {}

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
    return ValueListenableBuilder(
      valueListenable: _notifyPendingRooms,
      builder: (context, value, child) {
        var _rooms = _notifyPendingRooms.value;
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
            _rooms.isEmpty
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
                      return _rooms[index].listWidget(
                        detail: () {
                          var currentRoom =
                              Provider.of<RoomModel>(context, listen: false);
                          currentRoom.setFromJson(_rooms[index].toJson());

                          NavigatorProvider.of(context).push(
                            screen: const RoomScreen(),
                            pop: (val) {
                              if (val != null) {
                                var currentUser = Provider.of<UserModel>(
                                    context,
                                    listen: false);
                                _leaveRoom(currentRoom, currentUser);
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
                    itemCount: _rooms.length,
                  ),
          ],
        );
      },
    );
  }

  Widget _activeWidget() {
    return ValueListenableBuilder(
      valueListenable: _notifyActiveRooms,
      builder: (context, value, child) {
        var _rooms = _notifyActiveRooms.value;
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
            _rooms.isEmpty
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
                      return RoomModel().listWidget();
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: offsetSm,
                      );
                    },
                    itemCount: _rooms.length,
                  ),
          ],
        );
      },
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
