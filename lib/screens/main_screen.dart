import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/main.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/notification_provider.dart';
import 'package:labyrinth/providers/shared_provider.dart';
import 'package:labyrinth/providers/socket_provider.dart';
import 'package:labyrinth/screens/blog/blog_screen.dart';
import 'package:labyrinth/screens/home/home_screen.dart';
import 'package:labyrinth/screens/setting/setting_screen.dart';
import 'package:labyrinth/screens/world/world_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/appbar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final _event = ValueNotifier(0);
  SocketProvider? _socketProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    Timer.run(() => _initData());
  }

  void _initData() async {
    var user = Provider.of<UserModel>(context, listen: false);
    socketService = injector!.get<SocketProvider>();
    socketService!.init(user);
    NotificationProvider.of(context).init();
  }

  @override
  Widget build(BuildContext context) {
    var screens = [
      const HomeScreen(),
      const WorldScreen(),
      const BlogScreen(),
      const SettingScreen(),
    ];
    return WillPopScope(
      onWillPop: () async => false,
      child: ValueListenableBuilder(
        valueListenable: _event,
        builder: (context, value, view) {
          return Scaffold(
            bottomNavigationBar: _buildBottomNavigationBar(),
            body: screens[_event.value],
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    var bottomBarTitles = [
      S.current.home,
      S.current.world,
      S.current.blog,
      S.current.setting,
    ];
    var bottomItemImages = [
      Icons.home,
      Icons.language,
      Icons.category,
      Icons.settings,
    ];
    return CustomBottomBar(
      backgroundColor: Colors.white,
      currentIndex: _event.value,
      onChange: (index) {
        _event.value = index;
      },
      children: [
        for (var i = 0; i < bottomItemImages.length; i++)
          CustomBottomNavigationItem(
            icon: FutureBuilder<int>(
              future: _getBadge(i),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Icon(
                    bottomItemImages[i],
                    color: _event.value == i ? Colors.white : kAccentColor,
                    size: offsetXMd,
                  );
                }
                return snapshot.data == 0
                    ? Icon(
                        bottomItemImages[i],
                        color: _event.value == i ? Colors.white : kAccentColor,
                        size: offsetXMd,
                      )
                    : Badge(
                        position: BadgePosition.topEnd(top: 10, end: 10),
                        badgeContent: null,
                        child: Icon(
                          bottomItemImages[i],
                          color:
                              _event.value == i ? Colors.white : kAccentColor,
                          size: offsetXMd,
                        ),
                      );
              },
            ),
            label: bottomBarTitles[i].regularText(
              fontSize: fontXSm,
              color: _event.value == i ? Colors.white : kAccentColor,
            ),
          ),
      ],
    );
  }

  Future<int> _getBadge(int index) async {
    if (index == 3) {
      return await SharedProvider().getBlogUnread();
    }
    if (index == 4) {
      return await SharedProvider().getNotiUnread();
    }
    return 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (kDebugMode) {
          print("-----\napp in resumed-------");
        }
        _enterApp();
        break;
      case AppLifecycleState.inactive:
        if (kDebugMode) {
          print("-----\napp in inactive-----");
        }
        _leaveApp();
        break;
      case AppLifecycleState.paused:
        if (kDebugMode) {
          print("-----\napp in paused-----");
        }
        _pauseApp();
        break;
      case AppLifecycleState.detached:
        if (kDebugMode) {
          print("-----\napp in detached-----");
        }
        break;
    }
  }

  void _enterApp() async {
    // initBadge();
  }

  void _leaveApp() async {
    // socketService!.leaveRoom(_currentUser);
  }

  void _pauseApp() async {
    // socketService!.leaveRoom(_currentUser);
  }
}
