import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/screens/setting/account_screen.dart';
import 'package:labyrinth/screens/setting/game_env_screen.dart';
import 'package:labyrinth/screens/setting/notification_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/setting/setting_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();

    Timer.run(() => _initData());
  }

  void _initData() async {
    var gameProvider = Provider.of<GameModel>(context, listen: false);
    await gameProvider.init();
    setState(() {});
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
            screen: const AccountScreen(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_active_outlined,
              color: kAccentColor,
            ),
            onPressed: () => NavigatorProvider.of(context).push(
              screen: const NotificationScreen(),
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
          child: Consumer<GameModel>(
            builder: (context, game, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  game.getSettingWidget(
                    detail: () => NavigatorProvider.of(context).push(
                      screen: const GameEnvScreen(),
                    ),
                  ),
                  const SizedBox(
                    height: offsetSm,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(offsetSm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: offsetBase,
                        vertical: offsetBase,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              S.current.membership_awards
                                  .semiBoldText(fontSize: fontMd),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          SettingItem(
                            title: S.current.membership,
                            desc: S.current.membership_detail,
                            avatar: S.current.upgrade.mediumText(
                              fontSize: fontXSm,
                              color: kAccentColor,
                            ),
                            detail: () {},
                          ),
                          SettingItem(
                            title: S.current.awards,
                            desc: S.current.award_detail,
                            avatar: S.current.view_all.mediumText(
                              fontSize: fontXSm,
                              color: kAccentColor,
                            ),
                            detail: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: offsetSm,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(offsetSm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: offsetBase,
                        vertical: offsetBase,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              S.current.term_condition
                                  .semiBoldText(fontSize: fontMd),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          SettingItem(
                            title: S.current.term_condition,
                            desc: S.current.membership_detail,
                            avatar: S.current.detail.mediumText(
                              fontSize: fontXSm,
                              color: kAccentColor,
                            ),
                            detail: () {},
                          ),
                          SettingItem(
                            title: S.current.privacy_police,
                            desc: S.current.award_detail,
                            avatar: 'Detail'.mediumText(
                              fontSize: fontXSm,
                              color: kAccentColor,
                            ),
                            detail: () {},
                          ),
                          SettingItem(
                            title: S.current.guide_agreement,
                            desc: S.current.award_detail,
                            avatar: S.current.detail.mediumText(
                              fontSize: fontXSm,
                              color: kAccentColor,
                            ),
                            detail: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
