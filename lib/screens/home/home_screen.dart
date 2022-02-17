import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/home/home_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: S.current.home.semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
        leading: Container(),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: offsetBase,
            vertical: offsetXMd,
          ),
          child: Column(
            children: [
              _createWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createWidget() {
    return Column(
      children: [
        Row(
          children: [
            'Create Match'.regularText(color: kAccentColor),
            const Spacer(),
            const Icon(
              Icons.help_outline,
              color: kAccentColor,
              size: 18.0,
            ),
          ],
        ),
        const SizedBox(
          height: offsetSm,
        ),
        Row(
          children: [
            CreateRoomWidget(
              icon: const Icon(
                Icons.looks_two_outlined,
                color: kAccentColor,
                size: 32.0,
              ),
              title: '2 ${S.current.match_game}',
              onClick: () {},
            ),
            const SizedBox(
              width: offsetBase,
            ),
            CreateRoomWidget(
              icon: const Icon(
                Icons.looks_4_outlined,
                color: kAccentColor,
                size: 32.0,
              ),
              title: '4 ${S.current.match_game}',
              onClick: () {},
            ),
          ],
        ),
      ],
    );
  }
}
