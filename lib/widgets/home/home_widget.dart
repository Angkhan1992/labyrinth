import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/extension.dart';

class CreateRoomWidget extends StatelessWidget {
  final Widget icon;
  final String title;
  final Function()? onClick;

  const CreateRoomWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(offsetBase),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(offsetSm),
          boxShadow: [
            kTopLeftShadow,
            kBottomRightShadow,
          ],
        ),
        child: InkWell(
          onTap: onClick,
          child: Column(
            children: [
              icon,
              const SizedBox(
                height: offsetSm,
              ),
              title.mediumText(fontSize: fontSm, color: kAccentColor),
            ],
          ),
        ),
      ),
    );
  }
}
