import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'package:labyrinth/models/block_model.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/widgets/home/free_card_widget.dart';

class RoomPlayWidget extends StatelessWidget {
  final RoomModel room;
  const RoomPlayWidget({
    Key? key,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          const SizedBox(
            height: offsetBase,
          ),
          _controlPanel(context),
        ],
      ),
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
                AnimatedPositioned(
                  duration: const Duration(milliseconds: kAnimationDuring),
                  top: (j > 0 && j < 8 && i == room.getMoveIndex() * 2)
                      ? (j + 1) * (size + 1)
                      : (j > 0 && j < 8 && i == (room.getMoveIndex() - 3) * 2)
                          ? (j - 1) * (size + 1)
                          : j * (size + 1),
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
                    child: getChild(context, _game, i, j),
                  ),
                  onEnd: () {
                    room.setMoveIndex(-1);
                  },
                ),
              },
            },
          ],
        ),
      ),
    );
  }

  Widget getChild(BuildContext context, GameModel game, int i, int j) {
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
          isSelected:
              heroIndex == (room.getPlayCounter() % int.parse(room.amount)),
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
        ).body(
          onTap: (val) {
            room.setMoveIndex(val + 1);
          },
        );
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

    var currentUser = Provider.of<UserModel>(
      context,
      listen: false,
    );
    var heroColor = heroColors[room.getUserIndex(currentUser)];

    for (var position in room.startPositions()) {
      if (index == position) {
        var posIndex = room.startPositions().indexOf(position);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(offsetXSm),
            border: Border.all(
              color: heroColor,
              width: 1,
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
              color: heroColor,
              width: 1,
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
              color: heroColor,
              width: 1,
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
        Container(
          width: kCardWidth,
          height: kCardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(offsetSm),
            color: heroColor,
          ),
        ),
      ],
    );
  }

  Widget _controlPanel(BuildContext context) {
    var currentUser = Provider.of<UserModel>(
      context,
      listen: false,
    );
    var heroColor = heroColors[room.getUserIndex(currentUser)];
    var _game = Provider.of<GameModel>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: offsetXMd,
        vertical: offsetSm,
      ),
      width: double.infinity,
      height: 120.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(offsetSm),
        color: Colors.white,
        boxShadow: [
          kTopLeftShadow,
          kBottomRightShadow,
        ],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: offsetMd,
          ),
          FreeCardWidget(
            gameModel: _game,
            heroColor: heroColor,
            rotate: () {
              Future.delayed(
                const Duration(milliseconds: kAnimationDuring),
                () {
                  if (kDebugMode) {
                    print('[Animation] rotated');
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
