import 'dart:async';

import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/block_model.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:provider/provider.dart';

class GameEnvScreen extends StatefulWidget {
  const GameEnvScreen({
    Key? key,
  }) : super(key: key);

  @override
  _GameEnvScreenState createState() => _GameEnvScreenState();
}

class _GameEnvScreenState extends State<GameEnvScreen> {
  BlockModel? _blockModel;

  final List<List<int>> _titleIndex = [
    [1, 0, 1],
    [1, 0, 0],
    [1, 0, 1],
  ];

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Timer.run(() => _initData());
  }

  void _initData() async {
    var gameProvider = Provider.of<GameModel>(context, listen: false);
    await gameProvider.init();
    _blockModel = BlockModel.of(gameProvider, _titleIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameModel>(
      builder: (context, game, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: game.title.semiBoldText(
              fontSize: fontXMd,
              color: kAccentColor,
            ),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: offsetSm,
                vertical: offsetXMd,
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      if (_blockModel != null) _blockModel!.tileWidget(),
                      Container(
                        margin: const EdgeInsets.only(top: offsetBase),
                        padding: const EdgeInsets.all(offsetBase),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(offsetSm),
                          boxShadow: [
                            kTopLeftShadow,
                            kBottomRightShadow,
                          ],
                        ),
                        child: Column(
                          children: [
                            S.current.block_image.mediumText(),
                            const SizedBox(
                              height: offsetBase,
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        for (var image
                                            in game.blockTypes[index]) ...{
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(offsetSm),
                                            child: InkWell(
                                              onTap: () {
                                                if (index > 0) return;
                                                game.setTileBack([
                                                  index,
                                                  game.blockTypes[index]
                                                      .indexOf(image)
                                                ]);
                                              },
                                              child: Stack(
                                                children: [
                                                  Image.asset(
                                                    image,
                                                    width: 60.0,
                                                    height: 60.0,
                                                  ),
                                                  if (index > 0)
                                                    Positioned.fill(
                                                      child: Container(
                                                        color: Colors.black54,
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.lock,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (index ==
                                                          game.getTileBack()[
                                                              0] &&
                                                      game.blockTypes[index]
                                                              .indexOf(image) ==
                                                          game.getTileBack()[1])
                                                    const Positioned.fill(
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        },
                                      ],
                                    ),
                                  ],
                                );
                              },
                              itemCount: 5,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Container(height: offsetSm);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: offsetBase,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: offsetBase,
                      vertical: offsetBase,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(offsetSm),
                      boxShadow: [
                        kTopLeftShadow,
                        kBottomRightShadow,
                      ],
                    ),
                    child: Column(
                      children: [
                        S.current.background_color.mediumText(),
                        const SizedBox(
                          height: offsetBase,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    for (var i = 0; i < 3; i++) ...{
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(offsetSm),
                                        child: InkWell(
                                          onTap: () =>
                                              game.setBackColor(index * 3 + i),
                                          child: Container(
                                            width: 60.0,
                                            height: 60.0,
                                            decoration: BoxDecoration(
                                              color: game
                                                  .backColors[index * 3 + i],
                                              border: Border.all(
                                                  color: kAccentColor),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      offsetSm),
                                            ),
                                            child: (index * 3 + i ==
                                                    game.getBackIndex())
                                                ? const Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                        ),
                                      ),
                                    },
                                  ],
                                ),
                              ],
                            );
                          },
                          itemCount: 2,
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(height: offsetSm);
                          },
                        ),
                        const SizedBox(
                          height: offsetBase,
                        ),
                        S.current.hover_color.mediumText(),
                        const SizedBox(
                          height: offsetBase,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (var i = 0; i < 3; i++) ...{
                              ClipRRect(
                                borderRadius: BorderRadius.circular(offsetSm),
                                child: InkWell(
                                  onTap: () => game.setHoverColor(i),
                                  child: Container(
                                    width: 60.0,
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                      color: game.hoverColors[i],
                                      border: Border.all(color: kAccentColor),
                                      borderRadius:
                                          BorderRadius.circular(offsetSm),
                                    ),
                                    child: (i == game.getHoverIndex())
                                        ? const Center(
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.black,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            },
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
