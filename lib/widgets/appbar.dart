import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';

class NoAppBar extends AppBar {
  NoAppBar({Key? key})
      : super(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        );
}

class CustomBottomNavigationItem {
  final Widget icon;
  final Widget label;
  final Color? color;

  CustomBottomNavigationItem({
    required this.icon,
    required this.label,
    this.color,
  });
}

class CustomBottomBar extends StatelessWidget {
  final Color backgroundColor;
  final Color itemColor;
  final List<CustomBottomNavigationItem>? children;
  final Function(int)? onChange;
  final int currentIndex;

  const CustomBottomBar({
    Key? key,
    this.backgroundColor = kAccentColor,
    this.itemColor = Colors.black,
    this.children,
    this.onChange,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 1),
            blurRadius: 1.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: offsetSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children!.map((item) {
              Widget icon = item.icon;
              Widget label = item.label;
              int index = children!.indexOf(item);
              return GestureDetector(
                onTap: () => onChange!(index),
                child: Container(
                  width: 64,
                  height: 60,
                  padding: const EdgeInsets.only(
                      left: offsetXSm, right: offsetXSm, top: offsetXSm),
                  margin:
                      const EdgeInsets.only(top: offsetXSm, bottom: offsetXSm),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? kAccentColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(offsetSm),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      icon,
                      const SizedBox(
                        height: offsetXSm,
                      ),
                      label
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
