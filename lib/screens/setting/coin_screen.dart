import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:line_icons/line_icons.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/coin_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/loading_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/setting/profile_widget.dart';

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

  List<String> _productLists = [];
  final List<IAPItem> _items = [];
  LoadingProvider? _loadingProvider;

  @override
  void initState() {
    super.initState();
    _user = widget.userModel;

    Timer.run(() {
      _getCoinData();
    });
  }

  Future<void> _initialize() async {
    _productLists = _coins.map((e) => e.purchaseKey!).toList();
    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    if (kDebugMode) {
      print('[Coin Screen] result: $result');
    }
    if (!mounted) return;

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      if (kDebugMode) {
        print('[Coin Screen] consumeAllItems: $msg');
      }
    } catch (err) {
      if (kDebugMode) {
        print('[Coin Screen] consumeAllItems error: $err');
      }
    }

    await _getProduct();

    FlutterInappPurchase.connectionUpdated.listen((connected) {
      if (kDebugMode) {
        print('[Coin Screen] connected: $connected');
      }
    });

    FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      if (kDebugMode) {
        print('[Coin Screen] purchase-updated: $productItem');
      }
      _loadingProvider!.hide();
      if (Platform.isIOS) {
        if (productItem!.transactionStateIOS == TransactionState.purchased) {
          _buyCoins(productItem);
        }
      }
    });

    FlutterInappPurchase.purchaseError.listen((purchaseError) {
      if (kDebugMode) {
        print('[Coin Screen] purchase-error: $purchaseError');
      }
      _loadingProvider!.hide();
      DialogProvider.of(context).showSnackBar(
        'Purchase ${purchaseError!.message!}',
        type: SnackBarType.ERROR,
      );
    });

    _loadingProvider = LoadingProvider.of(context);

    setState(() {});
  }

  void _requestPurchase(String productID) {
    _loadingProvider!.show();
    FlutterInappPurchase.instance.requestPurchase(productID);
  }

  Future _getProduct() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      if (kDebugMode) {
        print(item.toString());
      }
      _items.add(item);
    }
  }

  void _buyCoins(PurchasedItem purchaseItem) async {}

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
        S.current.server_error,
        type: SnackBarType.ERROR,
      );
    }
    await _initialize();
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
                        size: 60.0,
                        color: kAccentColor,
                      ),
                      const SizedBox(
                        height: offsetSm,
                      ),
                      '${S.current.coins} : ${_user!.usrCoin!}'.mediumText(
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
                          title: S.current.send,
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
                          title: S.current.request,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      S.current.shop_of_coin.mediumText(),
                      const SizedBox(
                        height: offsetSm,
                      ),
                      for (var coin in _coins) ...{
                        coin.inAppWidget(
                          buy: () => _requestPurchase(coin.purchaseKey!),
                        ),
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
