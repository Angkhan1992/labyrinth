import 'dart:async';

import 'package:flutter/material.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:provider/provider.dart';

class RoomDetailScreen extends StatefulWidget {
  final RoomModel roomModel;

  const RoomDetailScreen({
    Key? key,
    required this.roomModel,
  }) : super(key: key);

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  RoomModel? currentRoom;

  @override
  void initState() {
    super.initState();

    Timer.run(() {
      currentRoom = Provider.of<RoomModel>(context, listen: false);
      currentRoom = widget.roomModel;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: (currentRoom == null ? 'Room' : currentRoom!.name).semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: offsetSm,
            vertical: offsetXMd,
          ),
          child: Column(
            children: [
              'Join to Room'.button(
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
