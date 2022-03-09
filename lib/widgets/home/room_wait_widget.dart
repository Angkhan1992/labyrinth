import 'package:flutter/material.dart';
import 'package:labyrinth/models/block_model.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:provider/provider.dart';

class RoomWaitWidget extends StatelessWidget {
  final UserModel currentUser;
  final RoomModel room;
  final Function()? joinUser;

  const RoomWaitWidget({
    Key? key,
    required this.currentUser,
    required this.room,
    this.joinUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: offsetBase,
          vertical: offsetXMd,
        ),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent:
                    (MediaQuery.of(context).size.width - offsetBase * 2 - 6) /
                        7,
                childAspectRatio: 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemBuilder: (context, index) {
                var width =
                    (MediaQuery.of(context).size.width - offsetBase * 2 - 6) /
                        7;
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
                    ? BlockModel.getFillModel(width, _game)
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
              height: offsetXMd,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: offsetSm,
                    vertical: offsetXSm,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(offsetBase),
                    color: kAccentColor,
                  ),
                  child:
                      'Players'.thinText(fontSize: fontSm, color: Colors.white),
                ),
                const SizedBox(
                  width: offsetBase,
                ),
                for (var user in room.getUsers()) ...{
                  user.circleAvatar(),
                  const SizedBox(
                    width: offsetXSm,
                  ),
                },
              ],
            ),
            const SizedBox(
              height: offsetBase,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: offsetSm,
                    vertical: offsetXSm,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(offsetBase),
                    color: Colors.deepPurpleAccent,
                  ),
                  child:
                      'Tours'.thinText(fontSize: fontSm, color: Colors.white),
                ),
                const SizedBox(
                  width: offsetBase,
                ),
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
