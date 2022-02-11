import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/screens/blog/blog_screen.dart';
import 'package:labyrinth/screens/home/home_screen.dart';
import 'package:labyrinth/screens/setting/setting_screen.dart';
import 'package:labyrinth/screens/world/world_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/widgets/appbar.dart';
import 'package:labyrinth/utils/extension.dart';

class MainScreen extends StatefulWidget {
  final UserModel userModel;
  const MainScreen({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _event = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    var screens = [
      HomeScreen(
        userModel: widget.userModel,
      ),
      WorldScreen(
        userModel: widget.userModel,
      ),
      BlogScreen(
        userModel: widget.userModel,
      ),
      SettingScreen(
        userModel: widget.userModel,
      ),
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
            icon: Icon(
              bottomItemImages[i],
              color: _event.value == i ? Colors.white : kAccentColor,
              size: offsetXMd,
            ),
            label: bottomBarTitles[i].regularText(
              fontSize: fontXSm,
              color: _event.value == i ? Colors.white : kAccentColor,
            ),
          ),
      ],
    );
  }
}
