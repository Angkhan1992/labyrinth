import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/widgets/home/room_widget.dart';

class BlockModel {
  GameModel provider;
  List<List<int>> titleIndexs;
  BlockType type;
  int index;
  bool isSelected;

  List<int> _tileType = [];

  BlockModel({
    required this.provider,
    required this.titleIndexs,
    required this.type,
    required this.index,
    required this.isSelected,
  });

  factory BlockModel.of(
    GameModel provider, {
    required List<List<int>> titleIndex,
    BlockType type = BlockType.empty,
    int index = 0,
    bool isSelected = false,
  }) {
    return BlockModel(
      provider: provider,
      titleIndexs: titleIndex,
      type: type,
      index: index,
      isSelected: isSelected,
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
        color: provider.backgroundColor(),
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
            return _tileType[index] == 1 ? provider.tileWidget() : Container();
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
              endRadius: 40.0,
              glowColor: kAccentColor,
              child: Material(
                elevation: 2.0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image.asset(
                    'assets/icons/ic_face_id.svg',
                    height: 24,
                    width: 24,
                  ),
                  radius: 24.0,
                ),
              ),
            )
          : CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Image.asset(
                'assets/icons/ic_face_id.svg',
                height: 24,
                width: 24,
              ),
              radius: 24.0,
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
      direction: ArrowDirection.down,
      onTap: () => onTap!(index),
    );
  }

  Widget _navUpCard({
    Function(int)? onTap,
  }) {
    return ArrowWidget(
      direction: ArrowDirection.top,
      onTap: () => onTap!(index),
    );
  }

  Widget _navLeftCard({
    Function(int)? onTap,
  }) {
    return ArrowWidget(
      direction: ArrowDirection.left,
      onTap: () => onTap!(index),
    );
  }

  Widget _navRightCard({
    Function(int)? onTap,
  }) {
    return ArrowWidget(
      direction: ArrowDirection.right,
      onTap: () => onTap!(index),
    );
  }

  Widget _startCard() {
    return Container();
  }

  Widget _fixedCard() {
    return Container();
  }

  Widget _flexibleCard() {
    return Container();
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
