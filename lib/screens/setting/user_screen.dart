import 'package:flutter/material.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/loading_provider.dart';
import 'package:labyrinth/providers/socket_provider.dart';
import 'package:labyrinth/widgets/setting/user_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/setting/profile_widget.dart';
import 'package:labyrinth/widgets/setting/setting_widget.dart';

class UserScreen extends StatefulWidget {
  final UserModel user;
  const UserScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Future<int> _friendShip() async {
    var currentUser = Provider.of<UserModel>(context, listen: false);
    var resp = await NetworkProvider.of().post(
      kGetRelation,
      {
        'senderID': currentUser.id!,
        'receiverID': widget.user.id!,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        return resp['result']['type'];
      } else {
        return 3;
      }
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: 'User Detail'.semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: offsetSm,
            vertical: offsetXMd,
          ),
          child: Column(
            children: [
              LabyrinthAvatar(url: widget.user.usrAvatar!),
              const SizedBox(
                height: offsetSm,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.user.usrName!.mediumText(fontSize: fontMd),
                  FutureBuilder<int>(
                    future: _friendShip(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      var currentUser =
                          Provider.of<UserModel>(context, listen: false);
                      var tag = currentUser.usrID! == widget.user.usrID
                          ? 'Yours'.tag(background: kAccentColor)
                          : 'Unknown'.tag(background: Colors.grey);
                      var type = snapshot.data!;
                      switch (type) {
                        case 0:
                          tag = 'Friend'.tag(background: Colors.green);
                          break;
                        case 1:
                          tag = 'Requested'.tag(background: kAccentColor);
                          break;
                        case 2:
                          tag = 'Invited'.tag(background: Colors.red);
                          break;
                      }
                      return Row(
                        children: [
                          const SizedBox(
                            width: offsetBase,
                          ),
                          tag,
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: offsetXSm,
              ),
              '${S.current.last_updated} : ${widget.user.usrUpdate!.split(" ").first}'
                  .thinText(fontSize: fontXSm),
              const SizedBox(
                height: offsetSm,
              ),
              FutureBuilder<int>(
                future: _friendShip(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  var type = snapshot.data!;
                  switch (type) {
                    case 0:
                      return Row(
                        children: [
                          Expanded(
                            child: UserIntroItem(
                              title: 'Wins',
                              value: '156'.roundValue,
                              iconData: LineIcons.award,
                            ),
                          ),
                          Expanded(
                            child: UserIntroItem(
                              title: 'Follows',
                              value: '102538'.roundValue,
                              iconData: LineIcons.userFriends,
                            ),
                          ),
                          Expanded(
                            child: UserIntroItem(
                              title: 'Friends',
                              value: '48630'.roundValue,
                              iconData: LineIcons.addressBook,
                            ),
                          ),
                        ],
                      );
                    case 1:
                      return SizedBox(
                        width: 160.0,
                        child: 'Follow'.button(
                          color: kAccentColor,
                          padding: const EdgeInsets.all(offsetSm),
                          onPressed: () => _follow(currentUser),
                        ),
                      );
                    case 2:
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: offsetBase),
                        child: Row(
                          children: [
                            Expanded(
                              child: 'Decline'.button(
                                color: Colors.red,
                                padding: const EdgeInsets.all(offsetSm),
                                onPressed: () => _decline(currentUser),
                              ),
                            ),
                            Expanded(
                              child: 'Accept'.button(
                                color: Colors.green,
                                padding: const EdgeInsets.all(offsetSm),
                                onPressed: () => _accept(currentUser),
                              ),
                            ),
                          ],
                        ),
                      );
                    case 3:
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: offsetBase),
                        child: Row(
                          children: [
                            Expanded(
                              child: 'Follow'.button(
                                color: kAccentColor,
                                padding: const EdgeInsets.all(offsetSm),
                                onPressed: () => _follow(currentUser),
                              ),
                            ),
                            Expanded(
                              child: 'Request'.button(
                                color: Colors.red,
                                padding: const EdgeInsets.all(offsetSm),
                                onPressed: () => _request(currentUser),
                              ),
                            ),
                          ],
                        ),
                      );
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: offsetSm,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(offsetSm),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(offsetBase),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      S.current.user_information.semiBoldText(fontSize: fontMd),
                      const SizedBox(
                        height: offsetSm,
                      ),
                      ProfileItemWidget(
                        title: S.current.userID,
                        content: widget.user.usrID!,
                      ),
                      const SizedBox(
                        height: offsetSm,
                      ),
                      ProfileItemWidget(
                        title: S.current.fullName,
                        content: widget.user.usrName!,
                      ),
                      const SizedBox(
                        height: offsetSm,
                      ),
                      ProfileItemWidget(
                        title: S.current.email,
                        content: widget.user.usrEmail!,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(offsetBase),
                child: 'Report User'.button(
                  color: Colors.red,
                  onPressed: () async {
                    LoadingProvider.of(context).show();
                    await NetworkProvider.of().post(
                      kReport,
                      {
                        'senderID': currentUser.id!,
                        'receiverID': widget.user.id!,
                      },
                    );
                    LoadingProvider.of(context).hide();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _follow(UserModel currentUser) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kAddFollow,
      {
        'senderID': currentUser.id!,
        'receiverID': widget.user.id!,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null) {
      if (resp['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
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

  void _request(UserModel currentUser) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kSendRequest,
      {
        'senderID': currentUser.id!,
        'receiverID': widget.user.id!,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null) {
      if (resp['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
        );
        socketService!.inviteFriend(currentUser.id!, widget.user.id!);
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

  void _accept(UserModel currentUser) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kAcceptRequest,
      {
        'senderID': currentUser.id!,
        'receiverID': widget.user.id!,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null) {
      if (resp['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
        );
        socketService!.acceptFriend(currentUser.id!, widget.user.id!);
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

  void _decline(UserModel currentUser) async {
    LoadingProvider.of(context).show();
    var resp = await NetworkProvider.of().post(
      kDeclineRequest,
      {
        'senderID': currentUser.id!,
        'receiverID': widget.user.id!,
      },
    );
    LoadingProvider.of(context).hide();
    if (resp != null) {
      if (resp['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
        );
        socketService!.declineFriend(currentUser.id!, widget.user.id!);
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
}
