import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class WorldScreen extends StatefulWidget {
  const WorldScreen({
    Key? key,
  }) : super(key: key);

  @override
  _WorldScreenState createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: S.current.world.semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
        leading: Container(),
      ),
    );
  }
}
