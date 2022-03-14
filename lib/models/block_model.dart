import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/home/room_widget.dart';

class BlockModel {
  GameModel game;
  RoomModel room;
  List<List<int>> titleIndexs;
  BlockType type;
  int index;
  bool isSelected;
  String? icon;

  List<int> _tileType = [];

  BlockModel({
    required this.game,
    required this.room,
    required this.titleIndexs,
    required this.type,
    required this.index,
    required this.isSelected,
    this.icon,
  });

  factory BlockModel.of(
    GameModel game,
    RoomModel room, {
    required List<List<int>> titleIndex,
    BlockType type = BlockType.empty,
    int index = 0,
    bool isSelected = false,
    String? icon,
  }) {
    return BlockModel(
      game: game,
      room: room,
      titleIndexs: titleIndex,
      type: type,
      index: index,
      isSelected: isSelected,
      icon: icon,
    )..init();
  }

  void init() {
    _tileType = [];
    for (var row in titleIndexs) {
      _tileType.addAll(row);
    }
  }

  Widget tileWidget({
    double size = 80.0,
    double radius = offsetSm,
    Color borderColor = kAccentColor,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: game.backgroundColor(),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return _tileType[index] == 1 ? game.tileWidget() : Container();
          },
          itemCount: 9,
        ),
      ),
    );
  }

  static Widget getFillModel(
    GameModel provider,
    ScrollController controller,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(offsetXSm),
      child: GridView.builder(
        controller: controller,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemBuilder: (context, index) {
          return provider.tileWidget();
        },
        itemCount: 9,
      ),
    );
  }

  Widget body({
    Function(int)? onTap,
  }) {
    switch (type) {
      case BlockType.hero:
        return _heroCard();
      case BlockType.empty:
        return _emptyCard();
      case BlockType.navDown:
        return _navDownCard(onTap: onTap);
      case BlockType.navUp:
        return _navUpCard(onTap: onTap);
      case BlockType.navLeft:
        return _navLeftCard(onTap: onTap);
      case BlockType.navRight:
        return _navRightCard(onTap: onTap);
      case BlockType.start:
        return _startCard();
      case BlockType.fixed:
        return _fixedCard();
      case BlockType.flexible:
        return _flexibleCard();
    }
  }

  Widget _heroCard() {
    return Center(
      child: isSelected
          ? AvatarGlow(
              endRadius: 20.0,
              glowColor: Colors.red,
              child: Material(
                elevation: 5.0,
                shape: const CircleBorder(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Image.network(
                    icon!,
                    height: 24,
                    width: 24,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Opacity(
                opacity: 0.5,
                child: Image.network(
                  icon!,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }

  Widget _emptyCard() {
    return Container();
  }

  Widget _navDownCard({
    Function(int)? onTap,
  }) {
    return ArrowWidget(
      direction: ArrowDirection.top,
      onTap: () => onTap!(index),
    );
  }

  Widget _navUpCard({
    Function(int)? onTap,
  }) {
    return ArrowWidget(
      direction: ArrowDirection.down,
      onTap: () => onTap!(index),
    );
  }

  Widget _navLeftCard({
    Function(int)? onTap,
  }) {
    return ArrowWidget(
      direction: ArrowDirection.right,
      onTap: () => onTap!(index),
    );
  }

  Widget _navRightCard({
    Function(int)? onTap,
  }) {
    return ArrowWidget(
      direction: ArrowDirection.left,
      onTap: () => onTap!(index),
    );
  }

  Widget _startCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(offsetXSm),
      child: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemBuilder: (context, index) {
              int i = index ~/ 3;
              var j = index % 3;
              var value = titleIndexs[i][j];
              return value == 1 ? game.tileWidget() : Container();
            },
            itemCount: 9,
          ),
          if (room.amount == '4') ...{
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 14.0,
                  height: 14.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kUserColors[index],
                  ),
                ),
              ),
            ),
          } else ...{
            if (index % 2 == 0) ...{
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kUserColors[index ~/ 2],
                    ),
                  ),
                ),
              ),
            }
          },
        ],
      ),
    );
  }

  Widget _fixedCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(offsetXSm),
      child: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemBuilder: (context, index) {
              int i = index ~/ 3;
              var j = index % 3;
              var value = titleIndexs[i][j];
              return value == 1 ? game.tileWidget() : Container();
            },
            itemCount: 9,
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red),
                ),
                child: '${index + 1}'.mediumText(
                  fontSize: fontXSm,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _flexibleCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(offsetXSm),
      child: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemBuilder: (context, index) {
              int i = index ~/ 3;
              var j = index % 3;
              var value = titleIndexs[i][j];
              return value == 1 ? game.tileWidget() : Container();
            },
            itemCount: 9,
          ),
        ],
      ),
    );
  }
}

enum BlockType {
  hero,
  empty,
  navDown,
  navUp,
  navLeft,
  navRight,
  start,
  fixed,
  flexible,
}
