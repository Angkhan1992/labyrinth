import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/encrypt_provider.dart';
import 'package:labyrinth/providers/loading_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/providers/socket_provider.dart';
import 'package:labyrinth/screens/setting/request_screen.dart';
import 'package:labyrinth/screens/setting/scan_screen.dart';
import 'package:labyrinth/screens/setting/user_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/setting/friend_widget.dart';
import 'package:labyrinth/widgets/setting/setting_widget.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({
    Key? key,
  }) : super(key: key);

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen>
    with SingleTickerProviderStateMixin {
  List<UserModel> _friends = [];
  List<UserModel> _invitedUsers = [];
  List<UserModel> _requestUsers = [];

  final _friendNotifier = ValueNotifier(0);
  final _inviteNotifier = ValueNotifier(0);

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    Timer.run(() => _initData());
    socketService!.updateFriend(
      update: _updateFriend,
    );
  }

  void _updateFriend(dynamic data) {
    String userID = data['content'].toString().replaceAll('user', '');
    switch (data['name']) {
      case 'invite_user':
        _invitedUser(userID);
        break;
      case 'accept_user':
        _acceptUser(userID);
        break;
    }
  }

  void _invitedUser(String userID) async {
    var resp = await NetworkProvider.of().post(
      kGetUser,
      {
        'id': userID,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var user = UserModel()..setFromJson(resp['result']);
        _invitedUsers.insert(0, user);
        _inviteNotifier.value = _invitedUsers.length;
      }
    }
  }

  void _acceptUser(String userID) async {
    var resp = await NetworkProvider.of().post(
      kGetUser,
      {
        'id': userID,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var user = UserModel()..setFromJson(resp['result']);
        _friends.insert(0, user);
        _friendNotifier.value = _friends.length;
      }
    }
  }

  void _initData() async {
    var user = Provider.of<UserModel>(context, listen: false);
    var resp = await NetworkProvider.of().post(
      kContactUser,
      {
        'id': user.id!,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        _friends.clear();
        _friends = (resp['result']['friend'] as List)
            .map((e) => UserModel()..setFromJson(e))
            .toList();
        _friends.sort((b, a) => a.usrRegdate!.compareTo(b.usrRegdate!));

        _invitedUsers.clear();
        _invitedUsers = (resp['result']['invite'] as List)
            .map((e) => UserModel()..setFromJson(e))
            .toList();
        _invitedUsers.sort((b, a) => a.usrRegdate!.compareTo(b.usrRegdate!));

        _requestUsers.clear();
        _requestUsers = (resp['result']['request'] as List)
            .map((e) => UserModel()..setFromJson(e))
            .toList();
        _requestUsers.sort((b, a) => a.usrRegdate!.compareTo(b.usrRegdate!));

        _friendNotifier.value = _friends.length;
        _inviteNotifier.value = _invitedUsers.length;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: S.current.friends.semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.qr_code_scanner,
              color: kAccentColor,
            ),
            onPressed: () => NavigatorProvider.of(context).push(
              screen: const QrScanScreen(),
              pop: (data) {
                if (data != null) {
                  _dialogUserCard(data);
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: offsetBase,
          vertical: offsetSm,
        ),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                FriendTab(
                  iconData: Icons.supervisor_account_outlined,
                  title: 'Friends',
                  count: 0,
                ),
                ValueListenableBuilder<int>(
                  valueListenable: _inviteNotifier,
                  builder: (context, value, view) {
                    return FriendTab(
                      iconData: Icons.login,
                      title: 'Invited',
                      count: value,
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _friendWidget(),
                  _invitedWidget(),
                ],
              ),
            ),
            const SizedBox(
              height: offsetBase,
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 48.0,
        height: 48.0,
        decoration: const BoxDecoration(
          color: kAccentColor,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => NavigatorProvider.of(context).push(
            screen: const RequestScreen(),
            pop: (value) {},
          ),
        ),
      ),
    );
  }

  Widget _friendWidget() {
    return ValueListenableBuilder<int>(
      valueListenable: _friendNotifier,
      builder: (context, value, view) {
        return _friends.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    'Not any friends yet'.regularText(),
                    const SizedBox(
                      height: offsetXMd,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: offsetSm),
                itemBuilder: (context, index) {
                  var user = _friends[index];
                  return user.friendItem(
                    detail: () => NavigatorProvider.of(context)
                        .push(screen: UserScreen(user: user)),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: offsetSm,
                  );
                },
                itemCount: _friends.length,
              );
      },
    );
  }

  Widget _invitedWidget() {
    return ValueListenableBuilder<int>(
      valueListenable: _inviteNotifier,
      builder: (context, value, view) {
        return _invitedUsers.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    'Not any invited users yet'.regularText(),
                    const SizedBox(
                      height: offsetXMd,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: offsetSm),
                itemBuilder: (context, index) {
                  var user = _invitedUsers[index];
                  var currentUser =
                      Provider.of<UserModel>(context, listen: false);
                  return user.inviteItem(
                    accept: () => _accept(currentUser.id!, user),
                    decline: () => _decline(currentUser.id!, user),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: offsetSm,
                  );
                },
                itemCount: _invitedUsers.length,
              );
      },
    );
  }

  void _accept(String senderID, UserModel receiver) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kAcceptRequest,
      {
        'senderID': senderID,
        'receiverID': receiver.id!,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null) {
      if (resp['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
        );
        socketService!.acceptFriend(senderID, receiver.id!);

        _invitedUsers.remove(receiver);
        _inviteNotifier.value = _invitedUsers.length;

        _friends.add(receiver);
        _friendNotifier.value = _friends.length;
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

  void _decline(String senderID, UserModel receiver) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kDeclineRequest,
      {
        'senderID': senderID,
        'receiverID': receiver.id!,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null) {
      if (resp['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
        );
        socketService!.declineFriend(senderID, receiver.id!);

        _invitedUsers.remove(receiver);
        _inviteNotifier.value = _invitedUsers.length;
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

  void _request(UserModel currentUser, String userid) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kSendRequest,
      {
        'senderID': currentUser.id!,
        'receiverID': userid,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null) {
      if (resp['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
        );
        socketService!.inviteFriend(currentUser.id!, userid);
        var user = UserModel()..setFromJson(resp['result']);
        _requestUsers.add(user);
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

  void _dialogUserCard(dynamic data) {
    var jsonUser = jsonDecode(data.toString().decryptString);
    if (kDebugMode) {
      print('[QR Code] json : $jsonUser');
    }
    String id = jsonUser['usr_id'];
    String userID = jsonUser['usr_userid'];

    String avatar = jsonUser['usr_avatar'] ?? '';
    String name = jsonUser['usr_name'];
    String email = jsonUser['usr_email'];
    String gender = jsonUser['usr_gender'];
    String country = jsonUser['usr_country'];

    var currentUser = Provider.of<UserModel>(context, listen: false);
    var tag = currentUser.usrID! == userID
        ? 'Yours'.tag(background: kAccentColor)
        : 'Unknown'.tag(background: Colors.grey);

    var requestAvailable = currentUser.usrID! != userID;
    for (var friend in _friends) {
      if (friend.usrID! == userID) {
        tag = 'Friend'.tag(background: Colors.green);
        requestAvailable = false;
        break;
      }
    }
    for (var request in _requestUsers) {
      if (request.usrID! == userID) {
        tag = 'Requested'.tag(background: kAccentColor);
        requestAvailable = false;
        break;
      }
    }
    for (var invited in _invitedUsers) {
      if (invited.usrID! == userID) {
        tag = 'Invited'.tag(background: Colors.red);
        requestAvailable = false;
        break;
      }
    }

    DialogProvider.of(context).bubbleDialog(
      child: Column(
        children: [
          LabyrinthAvatar(url: avatar),
          const SizedBox(
            height: offsetSm,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              name.mediumText(),
              const SizedBox(
                width: offsetBase,
              ),
              tag,
            ],
          ),
          const SizedBox(
            height: offsetSm,
          ),
          AvatarCardItem(
            iconData: LineIcons.code,
            value: userID,
          ),
          AvatarCardItem(
            iconData: LineIcons.userAlt,
            value: email,
          ),
          AvatarCardItem(
            iconData: LineIcons.genderless,
            value: gender == '1' ? S.current.female : S.current.male,
          ),
          AvatarCardItem(
            iconData: LineIcons.users,
            value: country,
          ),
        ],
      ),
      actions: [
        'Dismiss'.button(
          color: Colors.red,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        if (requestAvailable)
          'Request'.button(
            color: Colors.green,
            onPressed: () {
              Navigator.of(context).pop();
              _request(currentUser, id);
            },
          ),
      ],
    );
  }
}
