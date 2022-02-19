import 'dart:async';

import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/loading_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/providers/socket_provider.dart';
import 'package:labyrinth/screens/setting/request_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/setting/friend_widget.dart';
import 'package:provider/provider.dart';

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

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    Timer.run(() => _initData());
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
        _invitedUsers.clear();
        _invitedUsers = (resp['result']['invite'] as List)
            .map((e) => UserModel()..setFromJson(e))
            .toList();

        setState(() {});
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.ERROR,
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
            onPressed: () {},
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
                FriendTab(
                  iconData: Icons.login,
                  title: 'Invited',
                  count: _invitedUsers.length,
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
    return _friends.isEmpty
        ? Center(
            child: 'Not have any friend'.regularText(),
          )
        : ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: offsetSm),
            itemBuilder: (context, index) {
              var user = _friends[index];
              return user.friendItem();
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: offsetSm,
              );
            },
            itemCount: _friends.length,
          );
  }

  Widget _invitedWidget() {
    return _invitedUsers.isEmpty
        ? Center(
            child: 'Not have any invited'.regularText(),
          )
        : ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: offsetSm),
            itemBuilder: (context, index) {
              var user = _invitedUsers[index];
              var currentUser = Provider.of<UserModel>(context, listen: false);
              return user.inviteItem(
                accept: () => _accept(currentUser.id!, user.id!),
                decline: () => _decline(currentUser.id!, user.id!),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: offsetSm,
              );
            },
            itemCount: _invitedUsers.length,
          );
  }

  void _accept(String senderID, String receiverID) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kAcceptRequest,
      {
        'senderID': senderID,
        'receiverID': receiverID,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null) {
      if (resp['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
        );
        socketService!.acceptFriend(senderID, receiverID);
        _initData();
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.ERROR,
      );
    }
  }

  void _decline(String senderID, String receiverID) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kDeclineRequest,
      {
        'senderID': senderID,
        'receiverID': receiverID,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null) {
      if (resp['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
        );
        socketService!.declineFriend(senderID, receiverID);
        _initData();
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.ERROR,
      );
    }
  }
}
