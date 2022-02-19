import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';

class PurposeScreen extends StatefulWidget {
  final String userid;
  final Function() next;
  final Function() previous;
  final Function(bool) progress;

  const PurposeScreen({
    Key? key,
    required this.userid,
    required this.next,
    required this.previous,
    required this.progress,
  }) : super(key: key);

  @override
  _PurposeScreenState createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen> {
  ValueNotifier<int>? _eventPurpose;
  ValueNotifier<int>? _eventExperience;

  var isLoading = false;

  @override
  void initState() {
    super.initState();

    _eventPurpose = ValueNotifier(0);
    _eventExperience = ValueNotifier(0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: offsetBase),
            padding: const EdgeInsets.all(offsetBase),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(offsetBase),
              boxShadow: [
                kTopLeftShadow,
                kBottomRightShadow,
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                S.current.purpose.semiBoldText(fontSize: fontXMd),
                const SizedBox(
                  height: offsetBase,
                ),
                S.current.why_to_join_labyrinth.thinText(),
                const SizedBox(
                  height: offsetSm,
                ),
                ValueListenableBuilder(
                  valueListenable: _eventPurpose!,
                  builder: (context, value, view) {
                    var purposes = [
                      S.current.intelligence,
                      S.current.interesting,
                      S.current.gaming,
                      S.current.meet_friend,
                      S.current.other,
                    ];
                    return Wrap(
                      children: [
                        for (var i = 0; i < purposes.length; i++) ...{
                          InkWell(
                            onTap: () => _eventPurpose!.value = i,
                            child: Container(
                              margin: const EdgeInsets.all(offsetXSm),
                              padding: const EdgeInsets.symmetric(
                                vertical: offsetSm,
                                horizontal: offsetBase,
                              ),
                              decoration: BoxDecoration(
                                color: i == _eventPurpose!.value
                                    ? kAccentColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(offsetXMd),
                                border: Border.all(
                                  color: kAccentColor,
                                  width: 1,
                                ),
                              ),
                              child: purposes[i].mediumText(
                                fontSize: fontXSm,
                                color: i == _eventPurpose!.value
                                    ? Colors.white
                                    : kAccentColor,
                              ),
                            ),
                          ),
                        },
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: offsetBase,
                ),
                S.current.what_level.thinText(),
                const SizedBox(
                  height: offsetSm,
                ),
                ValueListenableBuilder(
                  valueListenable: _eventExperience!,
                  builder: (context, value, view) {
                    var purposes = [
                      S.current.beginner,
                      S.current.medium,
                      S.current.senior,
                      S.current.expert,
                      S.current.other,
                    ];
                    return Wrap(
                      children: [
                        for (var i = 0; i < purposes.length; i++) ...{
                          InkWell(
                            onTap: () => _eventExperience!.value = i,
                            child: Container(
                              margin: const EdgeInsets.all(offsetXSm),
                              padding: const EdgeInsets.symmetric(
                                vertical: offsetSm,
                                horizontal: offsetBase,
                              ),
                              decoration: BoxDecoration(
                                color: i == _eventExperience!.value
                                    ? kAccentColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(offsetXMd),
                                border: Border.all(
                                  color: kAccentColor,
                                  width: 1,
                                ),
                              ),
                              child: purposes[i].mediumText(
                                fontSize: fontXSm,
                                color: i == _eventExperience!.value
                                    ? Colors.white
                                    : kAccentColor,
                              ),
                            ),
                          ),
                        },
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: offsetBase,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: offsetBase),
            child: Row(
              children: [
                Expanded(
                  child: S.current.previous.button(
                    color: Colors.white,
                    onPressed: () => _previous(),
                  ),
                ),
                Expanded(
                  child: S.current.next.button(
                    isLoading: isLoading,
                    onPressed: () => _next(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: offsetXMd,
          ),
        ],
      ),
    );
  }

  void _next() async {
    if (isLoading) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }

    setState(() {
      isLoading = true;
    });
    widget.progress(true);

    var resp = await NetworkProvider.of().post(
      kAddPurpose,
      {
        'purpose': _eventPurpose!.value.toString(),
        'experience': _eventExperience!.value.toString(),
        'userid': widget.userid,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var user = resp['result']['updated'];
        if (kDebugMode) {
          print('[Purpose] user : $user');
        }
        widget.next();
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    }
    setState(() {
      isLoading = false;
    });
    widget.progress(false);
  }

  void _previous() async {
    if (isLoading) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    widget.previous();
  }
}
