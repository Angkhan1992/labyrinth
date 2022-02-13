import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class GameEnvScreen extends StatefulWidget {
  const GameEnvScreen({Key? key}) : super(key: key);

  @override
  _GameEnvScreenState createState() => _GameEnvScreenState();
}

class _GameEnvScreenState extends State<GameEnvScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: S.current.setting.semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
      ),
    );
  }
}
