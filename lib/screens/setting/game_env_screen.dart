import 'dart:async';

import 'package:flutter/material.dart';
import 'package:labyrinth/models/block_model.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
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
  GameModel? _gameProvider;

  final _tileBack = ValueNotifier([0, 0]);

  final List<List<int>> _titleIndex = [
    [1, 0, 1],
    [1, 0, 0],
    [1, 0, 1],
  ];
  BlockModel? _blockModel;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      _gameProvider = Provider.of<GameModel>(context, listen: false);
      _blockModel = BlockModel.of(_gameProvider!, _titleIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: _gameProvider!.title.semiBoldText(
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
              ValueListenableBuilder(
                valueListenable: _tileBack,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      _blockModel!.tileWidget(),
                      Container(
                        margin: const EdgeInsets.only(top: offsetBase),
                        padding: const EdgeInsets.all(offsetBase),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(offsetSm),
                        ),
                        child: Column(
                          children: [
                            'Block Image'.mediumText(),
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
                                        for (var image in _gameProvider!
                                            .blockTypes[index]) ...{
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(offsetSm),
                                            child: InkWell(
                                              onTap: () async {
                                                if (index > 0) return;
                                                _gameProvider!.setTileBack([
                                                  index,
                                                  _gameProvider!
                                                      .blockTypes[index]
                                                      .indexOf(image)
                                                ]);
                                                _tileBack.value = [
                                                  index,
                                                  _gameProvider!
                                                      .blockTypes[index]
                                                      .indexOf(image)
                                                ];
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
                                                          _tileBack.value[0] &&
                                                      _gameProvider!
                                                              .blockTypes[index]
                                                              .indexOf(image) ==
                                                          _tileBack.value[1])
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
                  );
                },
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
                ),
                child: Column(
                  children: [
                    'Background Color'.mediumText(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                for (var i = 0; i < 3; i++) ...{
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(offsetSm),
                                    child: InkWell(
                                      onTap: () async {},
                                      child: Container(
                                        width: 60.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          color: _gameProvider!
                                              .backColors[index * 3 + i],
                                          border:
                                              Border.all(color: kAccentColor),
                                          borderRadius:
                                              BorderRadius.circular(offsetSm),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.check,
                                            color: kAccentColor,
                                          ),
                                        ),
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
                    'Hover Color'.mediumText(),
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
                              onTap: () async {},
                              child: Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: _gameProvider!.hoverColors[i],
                                  border: Border.all(color: kAccentColor),
                                  borderRadius: BorderRadius.circular(offsetSm),
                                ),
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
  }
}
