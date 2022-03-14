import 'package:animated_rotation/animated_rotation.dart' as animation;
import 'package:flutter/material.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/models/block_model.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/themes/dimens.dart';

class FreeCardWidget extends StatefulWidget {
  final GameModel gameModel;
  final Color heroColor;
  final Function() rotate;

  const FreeCardWidget({
    Key? key,
    required this.gameModel,
    required this.heroColor,
    required this.rotate,
  }) : super(key: key);

  @override
  State<FreeCardWidget> createState() => _FreeCardWidgetState();
}

class _FreeCardWidgetState extends State<FreeCardWidget> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<UserModel>(context, listen: false);
    return Consumer<RoomModel>(
      builder: (context, room, child) {
        return SizedBox(
          width: 75.0,
          height: 75.0,
          child: Stack(
            children: [
              animation.AnimatedRotation(
                angle: _counter * 90,
                duration: const Duration(milliseconds: kAnimationDuring),
                child: Opacity(
                  opacity: room.getUser(0)!.id! == currentUser.id! ? 1.0 : 0.5,
                  child: BlockModel(
                    game: widget.gameModel,
                    room: room,
                    titleIndexs: room.getFreeCard(),
                    type: BlockType.flexible,
                    index: 0,
                    isSelected: false,
                  ).body(),
                ),
              ),
              if (room.getUser(0)!.id! == currentUser.id!)
                InkWell(
                  onTap: () {
                    setState(() {
                      _counter++;
                    });
                    widget.rotate();
                  },
                  child: Center(
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      padding: const EdgeInsets.all(offsetSm),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black45,
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 28.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
