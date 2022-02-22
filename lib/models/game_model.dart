import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/providers/shared_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/setting/setting_widget.dart';

List<Color> heroColors = [
  Colors.blue,
  Colors.red,
  Colors.brown,
  Colors.deepPurple,
];

class GameModel extends ChangeNotifier {
  List<List<String>> blockTypes = [
    [
      'assets/images/brick_01.png',
      'assets/images/brick_02.png',
      'assets/images/brick_03.png',
    ],
    [
      'assets/images/granitic_01.png',
      'assets/images/granitic_02.png',
      'assets/images/granitic_03.png',
    ],
    [
      'assets/images/rock_01.png',
      'assets/images/rock_02.png',
      'assets/images/rock_03.png',
    ],
    [
      'assets/images/stone_01.png',
      'assets/images/stone_02.png',
      'assets/images/stone_03.png',
    ],
    [
      'assets/images/wood_01.png',
      'assets/images/wood_02.png',
      'assets/images/wood_03.png',
    ],
  ];
  List<String> blockNames = [
    'Brick',
    'Granitic',
    'Rock',
    'Stone',
    'Wood',
  ];
  List<Color> backColors = [
    Colors.white,
    Colors.lightBlueAccent,
    Colors.yellowAccent,
    Colors.lightGreenAccent,
    Colors.orangeAccent,
    Colors.tealAccent,
  ];
  List<Color> hoverColors = [
    CustomColor.accentColor(opacity: 0.3),
    CustomColor.secondaryColor(opacity: 0.3),
    CustomColor.primaryColor(opacity: 0.3),
  ];

  String title = S.current.game_env;

  List<Map<String, dynamic>> _setting = [];
  String _tileIndex = '';
  int _backIndex = 0;
  int _hoverIndex = 0;

  GameModel();

  Future<void> init() async {
    _tileIndex = await SharedProvider().getSettingTile();
    _backIndex = await SharedProvider().getBackColor();
    _hoverIndex = await SharedProvider().getHoverColor();

    _setting = [
      {
        'title': S.current.type_block_title,
        'desc': S.current.type_block_desc,
        'avatar': blockTypes[int.parse(_tileIndex.split(',')[0])]
            [int.parse(_tileIndex.split(',')[1])],
      },
      {
        'title': S.current.back_color_title,
        'desc': S.current.back_color_desc,
        'color': backColors[_backIndex],
      },
      {
        'title': S.current.hover_color_title,
        'desc': S.current.hover_color_desc,
        'color': hoverColors[_hoverIndex],
      },
      {
        'title': S.current.option_time_title,
        'desc': S.current.option_time_desc,
      },
      {
        'title': S.current.option_bot_title,
        'desc': S.current.option_bot_desc,
      },
    ];

    notifyListeners();
  }

  Future<void> setTileBack(List<int> index) async {
    await SharedProvider().setSettingTile(index.join(','));
    _tileIndex = index.join(',');
    _setting[0] = {
      'title': S.current.type_block_title,
      'desc': S.current.type_block_desc,
      'avatar': blockTypes[index[0]][index[1]],
    };
    notifyListeners();
  }

  Future<void> setBackColor(int backColor) async {
    await SharedProvider().setBackColor(backColor);
    _backIndex = backColor;
    _setting[1] = {
      'title': S.current.back_color_title,
      'desc': S.current.back_color_desc,
      'color': backColors[_backIndex],
    };
    notifyListeners();
  }

  Future<void> setHoverColor(int hoverColor) async {
    await SharedProvider().setHoverColor(hoverColor);
    _hoverIndex = hoverColor;
    _setting[2] = {
      'title': S.current.hover_color_title,
      'desc': S.current.hover_color_desc,
      'color': hoverColors[_hoverIndex],
    };
    notifyListeners();
  }

  List<int> getTileBack() {
    if (_tileIndex.isEmpty) return [0, 0];
    return _tileIndex.split(',').map((e) => int.parse(e)).toList();
  }

  int getBackIndex() {
    return _backIndex;
  }

  int getHoverIndex() {
    return _hoverIndex;
  }

  Widget getSettingWidget({
    Function()? detail,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(offsetSm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: offsetBase,
          vertical: offsetBase,
        ),
        child: InkWell(
          onTap: detail,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title.semiBoldText(fontSize: fontMd),
                  const Icon(Icons.arrow_right),
                ],
              ),
              const SizedBox(
                height: offsetSm,
              ),
              for (var item in _setting) ...{
                SettingItem(
                  title: item['title'],
                  desc: item['desc'],
                  avatar: item['avatar'] != null
                      ? Image.asset(
                          item['avatar'],
                          width: offsetXMd,
                          height: offsetXMd,
                        )
                      : item['color'] != null
                          ? Container(
                              width: offsetXMd,
                              height: offsetXMd,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(offsetXSm),
                                border: Border.all(
                                  color: kAccentColor,
                                ),
                                color: item['color'],
                              ),
                            )
                          : null,
                ),
              },
            ],
          ),
        ),
      ),
    );
  }

  Widget tileWidget() {
    return Image.asset(
      _setting[0]['avatar'],
      width: offsetXMd,
      height: offsetXMd,
    );
  }

  Color backgroundColor() {
    return _setting[1]['color'];
  }

  Color hoverColor() {
    return _setting[2]['color'];
  }
}
