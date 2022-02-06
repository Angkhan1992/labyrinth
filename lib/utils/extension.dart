import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/themes/textstyles.dart';
import 'package:labyrinth/widgets/button.dart';

extension StringExtension on String {
  DateTime get getFullDate => DateFormat('yyyy-MM-dd HH:mm:ss').parse(this);

  static const String emailRegx =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  String? get validateEmail => (trim().isEmpty)
      ? S.current.emailEmpty
      : (!RegExp(emailRegx).hasMatch(trim()))
          ? S.current.emailNotMatch
          : null;

  String? get validatePassword => trim().isEmpty
      ? S.current.passwordEmpty
      : trim().length < 6
          ? S.current.passwordLess
          : null;

  String? get validateValue => trim().isEmpty ? S.current.emptyValue : null;

  String? get currentTime {
    if (isNotEmpty) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime dateTime = dateFormat.parse(this, true);
      DateTime localTime = dateTime.toLocal();

      final date2 = DateTime.now();
      final diffDay = date2.difference(localTime).inDays;
      if (diffDay > 7) return dateFormat.format(localTime).split(' ')[0];
      if (diffDay > 1) return DateFormat("EEEE").format(localTime);
      if (diffDay > 0) return 'Yesterday';

      final diffHour = date2.difference(dateTime).inHours;
      if (diffHour > 0) return '${diffHour}hr ago';

      final diffMin = date2.difference(dateTime).inMinutes;
      if (diffMin > 0) return '${diffMin}m ago';

      return 'less a min';
    } else {
      return null;
    }
  }

  Text thinText({
    double fontSize = fontBase,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Text(
      this,
      style: CustomText.thin(
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
    );
  }

  Text regularText({
    double fontSize = fontBase,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Text(
      this,
      style: CustomText.regular(
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
    );
  }

  Text mediumText({
    double fontSize = fontBase,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Text(
      this,
      style: CustomText.medium(
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
    );
  }

  Text semiBoldText({
    double fontSize = fontBase,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Text(
      this,
      style: CustomText.semiBold(
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
    );
  }

  Text boldText({
    double fontSize = fontBase,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
  }) {
    return Text(
      this,
      style: CustomText.bold(
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
    );
  }

  TextButton button({
    required Function() onPressed,
    double borderWidth = 0.0,
    double width = double.infinity,
    double height = kButtonHeight,
    bool isLoading = false,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: borderWidth == 0.0 ? kAccentColor : Colors.white,
          borderRadius: BorderRadius.circular(offsetSm),
          border: Border.all(
            width: borderWidth,
            color: kAccentColor,
          ),
          boxShadow: [
            kTopLeftShadow,
            kBottomRightShadow,
          ],
        ),
        child: Center(
          child: isLoading
              ? ProgressWidget(
                  color: borderWidth == 0 ? Colors.white : kAccentColor,
                )
              : semiBoldText(
                  fontSize: fontSm,
                  color: borderWidth > 0.0 ? kAccentColor : Colors.white,
                ),
        ),
      ),
    );
  }
}
