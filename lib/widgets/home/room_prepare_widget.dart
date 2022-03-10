import 'package:flutter/material.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:slide_countdown/slide_countdown.dart';

class RoomPrepareWidget extends StatelessWidget {
  final UserModel currentUser;

  const RoomPrepareWidget({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: offsetSm,
        vertical: offsetXMd,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              'Prepareing...'.mediumText(),
              const SizedBox(
                width: offsetSm,
              ),
              const SlideCountdown(
                duration: Duration(seconds: 30),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: offsetBase,
          ),
          'Please be ready for playing Labyrinth\nAfter down counter, Labyrinth will be start automatically.'
              .thinText(fontSize: fontSm),
        ],
      ),
    );
  }
}
