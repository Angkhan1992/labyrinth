import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

// ignore: must_be_immutable
class GenderWidget extends StatelessWidget {
  ValueNotifier<int> notifier;
  Function() event;
  String title;
  bool isSelected;

  GenderWidget({
    Key? key,
    required this.notifier,
    required this.event,
    required this.title,
    this.isSelected = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: event,
      child: Container(
        width: 90.0,
        height: 36.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(offsetBase),
          color: isSelected ? kAccentColor : Colors.white,
        ),
        child: Center(
          child: title.regularText(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class RegisterStepWidget extends StatelessWidget {
  final int step;
  const RegisterStepWidget({
    Key? key,
    required this.step,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: offsetXMd,
          height: offsetXMd,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: step == 0 ? Colors.blue : Colors.green,
            ),
          ),
          child: '1'.regularText(
            color: step == 0 ? Colors.blue : Colors.green,
          ),
        ),
        for (var i = 2; i < 5; i++) ...{
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: offsetXSm),
              height: 1,
              color: (step + 1) == i
                  ? Colors.blue
                  : i < (step + 1)
                      ? Colors.green
                      : Colors.black,
            ),
          ),
          Container(
            width: offsetXMd,
            height: offsetXMd,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: (step + 1) == i
                    ? Colors.blue
                    : i < (step + 1)
                        ? Colors.green
                        : Colors.black,
              ),
            ),
            child: i.toString().regularText(
                  color: (step + 1) == i
                      ? Colors.blue
                      : i < (step + 1)
                          ? Colors.green
                          : Colors.black,
                ),
          ),
        },
      ],
    );
  }
}
