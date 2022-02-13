import 'package:flutter/material.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/game_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/screens/setting/account_screen.dart';
import 'package:labyrinth/screens/setting/notification_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class SettingScreen extends StatefulWidget {
  final UserModel userModel;
  final GameProvider gameProvider;
  final Function(UserModel, GameProvider)? update;

  const SettingScreen({
    Key? key,
    required this.userModel,
    required this.update,
    required this.gameProvider,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UserModel? _user;
  GameProvider? _gameProvider;

  @override
  void initState() {
    super.initState();
    _user = widget.userModel;
    _gameProvider = widget.gameProvider;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: S.current.setting.semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.account_circle_outlined,
            color: kAccentColor,
          ),
          onPressed: () => NavigatorProvider.of(context).push(
            screen: AccountScreen(
              userModel: _user!,
              update: (updatedUser) {
                setState(() {
                  _user = updatedUser;
                });
                widget.update!(_user!, _gameProvider!);
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_active_outlined,
              color: kAccentColor,
            ),
            onPressed: () => NavigatorProvider.of(context).push(
              screen: NotificationScreen(
                userModel: _user!,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: offsetSm,
            vertical: offsetXMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _gameProvider!.getSettingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
