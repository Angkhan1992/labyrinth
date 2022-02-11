import 'dart:async';

import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/coin_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/setting/profile_widget.dart';
import 'package:line_icons/line_icons.dart';

class CoinScreen extends StatefulWidget {
  final UserModel userModel;
  final Function(int)? updateCoin;

  const CoinScreen({
    Key? key,
    required this.userModel,
    required this.updateCoin,
  }) : super(key: key);

  @override
  _CoinScreenState createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  final _event = ValueNotifier(CoinEvent.none);

  List<CoinModel> _coins = [];

  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _user = widget.userModel;

    Timer.run(() => _getCoinData());
  }

  void _getCoinData() async {
    _event.value = CoinEvent.init;
    var resp = await NetworkProvider.of().post(kGetCoins, {});
    if (resp != null) {
      if (resp['ret'] == 10000) {
        _coins =
            (resp['result'] as List).map((e) => CoinModel.fromJson(e)).toList();
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    } else {
      DialogProvider.of(context).showSnackBar(
        'Server Error!',
        type: SnackBarType.ERROR,
      );
    }
    _event.value = CoinEvent.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: S.current.coins.semiBoldText(
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
          child: ValueListenableBuilder(
            valueListenable: _event,
            builder: (context, value, view) {
              return Column(
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 80.0,
                        color: kAccentColor,
                      ),
                      const SizedBox(
                        height: offsetSm,
                      ),
                      'My Coins : ${_user!.usrCoin!}'.mediumText(
                        color: kAccentColor,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: offsetBase,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ProfileCard(
                          title: 'Send',
                          icon: const Icon(
                            LineIcons.coins,
                            color: kAccentColor,
                            size: 28.0,
                          ),
                          onClick: () {},
                        ),
                      ),
                      Expanded(
                        child: ProfileCard(
                          title: 'Request',
                          icon: const Icon(
                            LineIcons.wallet,
                            color: kAccentColor,
                            size: 28.0,
                          ),
                          onClick: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: offsetBase,
                  ),
                  'Shop of Coins'.mediumText(),
                  const SizedBox(
                    height: offsetSm,
                  ),
                  Column(
                    children: [
                      for (var coin in _coins) ...{
                        coin.inAppWidget(),
                      }
                    ],
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

enum CoinEvent {
  none,
  init,
  request,
  send,
  buy,
}
