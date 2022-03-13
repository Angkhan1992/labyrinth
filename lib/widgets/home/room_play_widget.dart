import 'package:flutter/material.dart';
import 'package:labyrinth/models/block_model.dart';
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
    var _game = Provider.of<GameModel>(context, listen: false);
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
                      color: _game.backgroundColor(),
                      borderRadius: BorderRadius.circular(
                        offsetXSm,
                      ),
                    ),
                    child: getChild(_game, i, j),
                  ),
                ),
              },
            },
          ],
        ),
      ),
    );
  }

  Widget getChild(GameModel game, int i, int j) {
    int index = i + j * 9;
    for (var position in room.heroPlayPositions()) {
      if (index == position) {
        var heroIndex = room.heroPlayPositions().indexOf(position);
        return BlockModel(
          game: game,
          room: room,
          titleIndexs: [],
          type: BlockType.hero,
          index: index,
          isSelected: true,
          icon: room.getUser(heroIndex)!.usrAvatar!,
        ).body();
      }
    }
    for (var position in room.navLeftPositions()) {
      if (index == position) {
        return BlockModel(
          game: game,
          room: room,
          titleIndexs: [],
          type: BlockType.navLeft,
          index: index,
          isSelected: false,
        ).body();
      }
    }
    for (var position in room.navRightPositions()) {
      if (index == position) {
        return BlockModel(
          game: game,
          room: room,
          titleIndexs: [],
          type: BlockType.navRight,
          index: index,
          isSelected: false,
        ).body();
      }
    }
    for (var position in room.navTopPositions()) {
      if (index == position) {
        return BlockModel(
          game: game,
          room: room,
          titleIndexs: [],
          type: BlockType.navUp,
          index: index,
          isSelected: false,
        ).body();
      }
    }
    for (var position in room.navBottomPositions()) {
      if (index == position) {
        return BlockModel(
          game: game,
          room: room,
          titleIndexs: [],
          type: BlockType.navDown,
          index: index,
          isSelected: false,
        ).body();
      }
    }

    for (var position in room.startPositions()) {
      if (index == position) {
        var posIndex = room.startPositions().indexOf(position);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(offsetXSm),
            border: Border.all(
              color: kAccentColor,
              width: 0.5,
            ),
          ),
          child: BlockModel(
            game: game,
            room: room,
            titleIndexs: kCard22Type[posIndex],
            type: BlockType.start,
            index: posIndex,
            isSelected: false,
          ).body(),
        );
      }
    }

    for (var position in room.fixedPositions()) {
      if (index == position) {
        var posIndex = room.fixedPositions().indexOf(position);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(offsetXSm),
            border: Border.all(
              color: kAccentColor,
              width: 0.5,
            ),
          ),
          child: BlockModel(
            game: game,
            room: room,
            titleIndexs: fixedCardIndex[posIndex],
            type: BlockType.fixed,
            index: posIndex,
            isSelected: false,
          ).body(),
        );
      }
    }

    for (var position in room.flexiblePositions()) {
      if (index == position) {
        var posIndex = room.flexiblePositions().indexOf(position);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(offsetXSm),
            border: Border.all(
              color: kAccentColor,
              width: 0.5,
            ),
          ),
          child: BlockModel(
            game: game,
            room: room,
            titleIndexs: room.getBoardData()[posIndex],
            type: BlockType.flexible,
            index: posIndex,
            isSelected: false,
          ).body(),
        );
      }
    }

    return Container();
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
