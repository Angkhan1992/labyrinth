import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';

class RoomPlayWidget extends StatelessWidget {
  final RoomModel room;
  const RoomPlayWidget({
    Key? key,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _statusWidget(),
        const SizedBox(
          height: offsetBase,
        ),
        _boardWidget(context),
        const SizedBox(
          height: offsetBase,
        ),
        _cardWdiget(context),
      ],
    );
  }

  Widget _statusWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: offsetXMd),
      child: Row(
        children: [
          const Icon(
            Icons.alarm,
            color: kAccentColor,
          ),
          const SizedBox(
            width: offsetSm,
          ),
          SlideCountdown(
            duration: const Duration(seconds: 59 * 60 + 59),
            countUp: true,
            decoration: BoxDecoration(
              color: kAccentColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            onDone: () {},
          ),
          const Spacer(),
          const Icon(
            Icons.alarm,
            color: Colors.red,
          ),
          const SizedBox(
            width: offsetSm,
          ),
          SlideCountdown(
            duration: const Duration(seconds: 59),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4.0),
            ),
            onDone: () {},
          ),
        ],
      ),
    );
  }

  Widget _boardWidget(BuildContext context) {
    var size =
        (MediaQuery.of(context).size.width - kBorderPadding * 2 - 8) / 9.0;
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(kBorderPadding),
        child: Stack(
          children: [
            for (var j = 0; j < 9; j++) ...{
              for (var i = 0; i < 9; i++) ...{
                Positioned(
                  top: j * (size + 1),
                  left: i * (size + 1),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(offsetXSm),
                      color: kAccentColor,
                    ),
                  ),
                ),
              },
            },
            // GridView.builder(
            //   physics: const NeverScrollableScrollPhysics(),
            //   controller: _scrollController,
            //   shrinkWrap: true,
            //   padding: const EdgeInsets.symmetric(vertical: offsetSm),
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 9,
            //     childAspectRatio: 1,
            //     crossAxisSpacing: 1,
            //     mainAxisSpacing: 1,
            //   ),
            //   itemBuilder: (context, index) {
            //     var _game = Provider.of<GameModel>(context, listen: false);
            //     for (var position in room.heroPlayPositions()) {
            //       if (index == position) {
            //         var posIndex = room.heroPlayPositions().indexOf(position);
            //         return Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(offsetXSm),
            //             color: heroColors[posIndex],
            //           ),
            //           alignment: Alignment.center,
            //           child: room.getUser(posIndex) == null
            //               ? const Icon(
            //                   Icons.help_outline,
            //                   size: 24.0,
            //                   color: Colors.white,
            //                 )
            //               : room.getUser(posIndex)!.circleAvatar(),
            //         );
            //       }
            //     }
            //     for (var position in room.heroLeftPositions()) {
            //       if (index == position) {
            //         return ArrowWidget(direction: ArrowDirection.right);
            //       }
            //     }
            //     for (var position in room.heroRightPositions()) {
            //       if (index == position) {
            //         return ArrowWidget(direction: ArrowDirection.left);
            //       }
            //     }
            //     for (var position in room.heroTopPositions()) {
            //       if (index == position) {
            //         return ArrowWidget(direction: ArrowDirection.down);
            //       }
            //     }
            //     for (var position in room.heroBottomPositions()) {
            //       if (index == position) {
            //         return ArrowWidget(direction: ArrowDirection.top);
            //       }
            //     }
            //     for (var position in room.heroEmptyPositions()) {
            //       if (index == position) {
            //         return Container();
            //       }
            //     }
            //     return index % 2 == 0
            //         ? BlockModel.getFillModel(_game, _scrollController)
            //         : Container(
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(offsetXSm),
            //               color: Colors.white,
            //             ),
            //           );
            //   },
            //   itemCount: 81,
            // )
          ],
        ),
      ),
    );
  }

  Widget _cardWdiget(BuildContext context) {
    var currentUser = Provider.of<UserModel>(
      context,
      listen: false,
    );
    var heroColor = heroColors[room.getUserIndex(currentUser)];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: kCardWidth,
          height: kCardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(offsetSm),
            border: Border.all(color: heroColor),
          ),
        ),
        Container(
          width: kCardWidth,
          height: kCardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(offsetSm),
            color: heroColor,
          ),
        ),
        Container(
          width: kCardWidth,
          height: kCardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(offsetSm),
            border: Border.all(color: heroColor),
          ),
        ),
      ],
    );
  }
}
