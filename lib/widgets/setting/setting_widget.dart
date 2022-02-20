import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String desc;
  final Widget? avatar;
  final Function()? detail;

  const SettingItem({
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

class LabyrinthAvatar extends StatelessWidget {
  final String url;
  final AvatarSize avatarSize;

  const LabyrinthAvatar({
    Key? key,
    required this.url,
    this.avatarSize = AvatarSize.lg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emptyAvatar =
        avatarSize == AvatarSize.lg ? kEmptyAvatarLg : kEmptyAvatarMd;
    var size = avatarSize == AvatarSize.lg ? 80.0 : 44.0;
    return url.isEmpty
        ? emptyAvatar
        : ClipRRect(
            borderRadius: BorderRadius.circular(size / 2.0),
            child: CachedNetworkImage(
              width: size,
              height: size,
              imageUrl: url,
              placeholder: (context, url) => Stack(
                children: [
                  emptyAvatar,
                  const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ],
              ),
              errorWidget: (context, url, error) => kEmptyAvatarLg,
              fit: BoxFit.cover,
            ),
          );
  }
}

enum AvatarSize {
  sm,
  md,
  lg,
}
