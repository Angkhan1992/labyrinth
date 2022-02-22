import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class UserIntroItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData iconData;

  const UserIntroItem({
    Key? key,
    required this.title,
    required this.value,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetSm),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: offsetSm,
          vertical: offsetBase,
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  iconData,
                  color: kAccentColor,
                  size: 18.0,
                ),
                const SizedBox(
                  width: offsetXSm,
                ),
                value.mediumText(
                  color: kAccentColor,
                ),
              ],
            ),
            const SizedBox(
              height: offsetXSm,
            ),
            title.thinText(
              color: kAccentColor,
              fontSize: fontXSm,
            ),
          ],
        ),
      ),
    );
  }
}
