import 'package:flutter/material.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String desc;
  final Widget? avatar;
  Function()? detail;

  SettingItem({
    Key? key,
    required this.title,
    required this.desc,
    this.avatar,
    this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: offsetSm),
      child: InkWell(
        onTap: detail,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title.mediumText(
                    fontSize: fontSm,
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  desc.thinText(
                    fontSize: fontXSm,
                  ),
                ],
              ),
            ),
            if (avatar != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(offsetXSm),
                child: avatar,
              ),
          ],
        ),
      ),
    );
  }
}
