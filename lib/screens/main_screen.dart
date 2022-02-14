import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/providers/shared_provider.dart';
import 'package:labyrinth/screens/blog/blog_screen.dart';
import 'package:labyrinth/screens/home/home_screen.dart';
import 'package:labyrinth/screens/setting/setting_screen.dart';
import 'package:labyrinth/screens/world/world_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/appbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _event = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
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
}
