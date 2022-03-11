import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/utils/constants.dart';

class ArrowWidget extends Container {
  ArrowWidget({
    Key? key,
    required ArrowDirection direction,
    Function()? onTap,
  }) : super(
          key: key,
          alignment: Alignment.center,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: kAccentColor,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                direction == ArrowDirection.down
                    ? Icons.arrow_downward
                    : direction == ArrowDirection.top
                        ? Icons.arrow_upward
                        : direction == ArrowDirection.left
                            ? Icons.arrow_back
                            : Icons.arrow_forward,
                color: kAccentColor,
                size: 14.0,
              ),
            ),
          ),
        );
}
