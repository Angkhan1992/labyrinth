import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/screens/setting/notification_screen.dart';
import 'package:labyrinth/screens/setting/profile_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class SettingScreen extends StatefulWidget {
  final UserModel userModel;
  const SettingScreen({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
            screen: ProfileScreen(
              userModel: widget.userModel,
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
                userModel: widget.userModel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
