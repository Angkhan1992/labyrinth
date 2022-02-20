import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/setting/profile_widget.dart';
import 'package:labyrinth/widgets/setting/setting_widget.dart';
import 'package:provider/provider.dart';

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
    await Future.delayed(const Duration(seconds: 2), null);
    return 0;
  }

  @override
  Widget build(BuildContext context) {
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
                      return Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: offsetBase,
                              ),
                              tag,
                            ],
                          ),
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
                height: offsetBase,
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
            ],
          ),
        ),
      ),
    );
  }
}
