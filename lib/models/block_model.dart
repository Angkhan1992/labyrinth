import 'package:flutter/material.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';

class BlockModel {
  GameModel provider;
  List<List<int>> titleIndexs;

  List<int> _tileType = [];

  BlockModel({
    required this.provider,
    required this.titleIndexs,
  });

  factory BlockModel.of(GameModel provider, List<List<int>> titleIndex) {
    return BlockModel(
      provider: provider,
      titleIndexs: titleIndex,
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
}
