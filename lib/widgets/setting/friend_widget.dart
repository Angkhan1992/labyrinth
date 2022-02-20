import 'package:flutter/material.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class FriendTab extends Tab {
  FriendTab({
    Key? key,
    required IconData iconData,
    required String title,
    required int count,
  }) : super(
          key: key,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 18.0,
              ),
              const SizedBox(
                width: offsetSm,
              ),
              title.thinText(),
              if (count > 0)
                Row(
                  children: [
                    const SizedBox(
                      width: offsetSm,
                    ),
                    Container(
                      width: 18.0,
                      height: 18.0,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: '1'.mediumText(
                          color: Colors.white,
                          fontSize: fontXSm,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
}

class AvatarCardItem extends StatelessWidget {
  final IconData iconData;
  final String value;

  const AvatarCardItem({
    Key? key,
    required this.iconData,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: offsetBase,
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(offsetXSm),
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                size: 14.0,
              ),
            ),
            const SizedBox(
              width: offsetSm,
            ),
            value.regularText(
              fontSize: fontSm,
            ),
          ],
        ),
      ],
    );
  }
}
