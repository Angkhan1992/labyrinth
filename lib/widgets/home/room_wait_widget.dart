import 'package:flutter/material.dart';
import 'package:labyrinth/models/block_model.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/screens/home/room_screen.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:provider/provider.dart';

class RoomWaitWidget extends StatelessWidget {
  final UserModel currentUser;
  final RoomModel room;
  final RoomScreenStatus status;
  final Function()? joinUser;

  RoomWaitWidget({
    Key? key,
    required this.currentUser,
    required this.room,
    required this.status,
    this.joinUser,
  }) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: offsetBase,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _scrollController,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: offsetSm),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemBuilder: (context, index) {
                var _game = Provider.of<GameModel>(context, listen: false);
                for (var position in room.heroPositions()) {
                  if (index == position) {
                    var posIndex = room.heroPositions().indexOf(position);
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(offsetXSm),
                        color: heroColors[posIndex],
                      ),
                      alignment: Alignment.center,
                      child: room.getUser(posIndex) == null
                          ? const Icon(
                              Icons.help_outline,
                              size: 24.0,
                              color: Colors.white,
                            )
                          : room.getUser(posIndex)!.circleAvatar(),
                    );
                  }
                }
                return index % 2 == 0
                    ? BlockModel.getFillModel(_game, _scrollController)
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(offsetXSm),
                          color: Colors.white,
                        ),
                      );
              },
              itemCount: 49,
            ),
            const SizedBox(
              height: offsetBase,
            ),
            'Players'.tag(background: Colors.lightGreen),
            const SizedBox(
              height: offsetSm,
            ),
            Row(
              children: room
                  .getUsers()
                  .map(
                    (user) => Row(
                      children: [
                        user.actionAvatar(),
                        const SizedBox(
                          width: offsetSm,
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: offsetBase,
            ),
            'Tours'.tag(background: Colors.deepPurpleAccent),
            const SizedBox(
              height: offsetSm,
            ),
            Row(
              children: [
                if (room.getTours().isNotEmpty) ...{
                  room.getTourUser(0).circleAvatar(),
                  const SizedBox(
                    width: offsetXSm,
                  ),
                  '+ ${room.getTours().length}'.mediumText(fontSize: fontSm),
                },
              ],
            ),
            if (!room.isContainedByUser(currentUser)) ...{
              const SizedBox(
                height: offsetXMd,
              ),
              Row(
                children: [
                  if (room.getStatus().isWaiting) ...{
                    const SizedBox(
                      width: offsetSm,
                    ),
                    Expanded(
                      child: 'Join to Player'.button(
                        isLoading: status == RoomScreenStatus.joinUser,
                        onPressed: joinUser!,
                      ),
                    ),
                  },
                  const SizedBox(
                    width: offsetSm,
                  ),
                  if (!room.isContainedByTour(currentUser)) ...{
                    Expanded(
                      child: 'Join to Tour'.button(
                        isLoading: status == RoomScreenStatus.joinTour,
                        color: Colors.deepPurpleAccent,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(
                      width: offsetSm,
                    ),
                  },
                ],
              ),
            },
            const SizedBox(
              height: offsetXMd,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: offsetSm),
              child: 'Leave Room'.button(
                color: Colors.redAccent,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
