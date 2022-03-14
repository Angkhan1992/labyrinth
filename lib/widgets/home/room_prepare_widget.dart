import 'package:flutter/material.dart';
import 'package:labyrinth/providers/socket_provider.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class RoomPrepareWidget extends StatelessWidget {
  final UserModel currentUser;
  final RoomModel room;
  final Function()? onRun;

  const RoomPrepareWidget({
    Key? key,
    required this.currentUser,
    required this.room,
    this.onRun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: offsetBase,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: offsetBase,
          ),
          Row(
            children: [
              const Spacer(),
              'Prepareing...'.mediumText(),
              const SizedBox(
                width: offsetSm,
              ),
              SlideCountdown(
                duration: const Duration(seconds: 30),
                onDone: onRun,
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: offsetBase,
          ),
          'Please be ready for playing Labyrinth\nAfter down counter, Labyrinth will be start automatically.'
              .thinText(fontSize: fontSm),
          const SizedBox(
            height: offsetBase,
          ),
          'Players'.tag(background: Colors.lightGreen),
          const SizedBox(
            height: offsetSm,
          ),
          Row(
            children: room
                .getUsers()
                .map(
                  (user) => Row(
                    children: [
                      user.actionAvatar(),
                      const SizedBox(
                        width: offsetSm,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
