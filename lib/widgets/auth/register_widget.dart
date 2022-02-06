import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class GenderWidget extends StatelessWidget {
  ValueNotifier<int> notifier;
  Function() event;
  String title;
  bool isSelected;

  GenderWidget({
    Key? key,
    required this.notifier,
    required this.event,
    required this.title,
    this.isSelected = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: event,
      child: Container(
        width: 90.0,
        height: 36.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(offsetBase),
          color: isSelected ? kAccentColor : Colors.white,
        ),
        child: Center(
          child: title.regularText(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
