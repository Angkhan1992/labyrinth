import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
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
    return Scaffold(
      appBar: NoAppBar(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    var bottomBarTitles = [
      S.current.home,
      S.current.world,
      S.current.blog,
      S.current.profile,
    ];
    var bottomItemImages = [
      Icons.home_outlined,
      Icons.language_outlined,
      Icons.category_outlined,
      Icons.account_circle_outlined,
    ];
    return CustomBottomBar(
      backgroundColor: Colors.white,
      children: [
        for (var i = 0; i < bottomItemImages.length; i++)
          CustomBottomNavigationItem(
            icon: Icon(
              bottomItemImages[i],
              color: _event.value == i ? Colors.white : kAccentColor,
              size: 22.0,
            ),
            label: bottomBarTitles[i].mediumText(
              fontSize: fontSm,
              color: _event.value == i ? Colors.white : kAccentColor,
            ),
          ),
      ],
    );
  }
}
