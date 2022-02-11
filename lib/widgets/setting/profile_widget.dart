import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class ProfileItemWidget extends StatelessWidget {
  final String title;
  final String content;
  final Function()? edit;
  const ProfileItemWidget({
    Key? key,
    required this.title,
    required this.content,
    this.edit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.thinText(fontSize: fontSm),
        Row(
          children: [
            content.mediumText(),
            const Spacer(),
            if (edit != null)
              InkWell(
                onTap: edit,
                child: Container(
                  padding: const EdgeInsets.all(offsetXSm),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: kScaffoldColor,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: kAccentColor,
                    size: 12.0,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final Function()? onClick;
  const ProfileCard({
    Key? key,
    required this.icon,
    required this.title,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetSm),
      ),
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              icon,
              const SizedBox(
                height: offsetXSm,
              ),
              title.regularText(
                color: kAccentColor,
                fontSize: fontSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
