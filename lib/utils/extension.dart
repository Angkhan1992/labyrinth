import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/textstyles.dart';
import 'package:labyrinth/widgets/button.dart';

extension StringExtension on String {
  DateTime get getFullDate => DateFormat('yyyy-MM-dd HH:mm:ss').parse(this);
  DateTime get getBirthDate => DateFormat('yyyy-MM-dd').parse(this);

  static const String emailRegx =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  String? get validateEmail => (trim().isEmpty)
      ? S.current.emailEmpty
      : (!RegExp(emailRegx).hasMatch(trim()))
          ? S.current.emailNotMatch
          : null;

  String? get validatePassword => trim().isEmpty
      ? S.current.passwordEmpty
      : trim().length < 8
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

  bool get hasLowercase {
    var characters = 'abcdefghijklmnopqrstuvwxyz';
    for (var c in this.characters) {
      if (characters.contains(c)) {
        return true;
      }
    }
    return false;
  }

  bool get hasUppercase {
    var characters = 'abcdefghijklmnopqrstuvwxyz'.toUpperCase();
    for (var c in this.characters) {
      if (characters.contains(c)) {
        return true;
      }
    }
    return false;
  }

  bool get hasNumber {
    var characters = '1234567890';
    for (var c in this.characters) {
      if (characters.contains(c)) {
        return true;
      }
    }
    return false;
  }

  bool get hasSpecial {
    var characters = '!@#\$&*~';
    for (var c in this.characters) {
      if (characters.contains(c)) {
        return true;
      }
    }
    return false;
  }

  Text thinText({
    double fontSize = fontBase,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    int? lines,
  }) {
    return Text(
      this,
      style: CustomText.thin(
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: lines,
    );
  }

  Text regularText({
    double fontSize = fontBase,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    int? lines,
  }) {
    return Text(
      this,
      style: CustomText.regular(
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: lines,
    );
  }

  Text mediumText({
    double fontSize = fontBase,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    int? lines,
  }) {
    return Text(
      this,
      style: CustomText.medium(
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: lines,
    );
  }

  Text semiBoldText({
    double fontSize = fontBase,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    int? lines,
  }) {
    return Text(
      this,
      style: CustomText.semiBold(
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: lines,
    );
  }

  Text boldText({
    double fontSize = fontBase,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    int? lines,
  }) {
    return Text(
      this,
      style: CustomText.bold(
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: lines,
    );
  }

  TextButton button({
    required Function() onPressed,
    double width = double.infinity,
    bool isLoading = false,
    Color color = kAccentColor,
    double radius = offsetSm,
    EdgeInsets? padding,
  }) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        padding: MaterialStateProperty.all<EdgeInsets>(
          padding ?? const EdgeInsets.all(offsetSm + offsetXSm),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: color),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Center(
        child: isLoading
            ? ProgressWidget(
                color: Colors.white,
              )
            : semiBoldText(
                fontSize: fontSm,
                color: color == Colors.white ? Colors.black : Colors.white,
              ),
      ),
    );
  }

  Widget tag({
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: offsetSm,
        vertical: offsetXSm,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(offsetBase),
      ),
      child: regularText(
        fontSize: fontXSm,
        color: Colors.white,
      ),
    );
  }

  String get roundValue {
    try {
      var value = int.parse(this);
      if (value > 9999999) return '10M+';
      if (value > 999999) return '1M+';
      if (value > 99999) return '100K+';
      if (value > 9999) return '10K+';
      if (value > 999) return '1K+';
      if (value > 99) return '100+';
      if (value > 9) return '10+';
      if (value > 0) return '1+';
      return '----';
    } catch (_) {
      return '----';
    }
  }

  String get formatDay {
    var dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    var date = dateFormatter.parse(this);
    var currentDate = DateTime.now();
    var diff = currentDate.difference(date).inSeconds;
    if (diff < 60) {
      return 'Less a min';
    } else if (diff < 60 * 60) {
      return 'Less an hr';
    } else if (diff < 60 * 60 * 24) {
      return 'In a day';
    }
    return 'Some days';
  }

  RoomStatus get roomStatus {
    for (var status in RoomStatus.values) {
      if (status.rawValue == this) {
        return status;
      }
    }
    return RoomStatus.waiting;
  }
}

extension DateTimeExtension on DateTime {
  String get getUTCFullTime =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(toUtc());
  String get getFullTime => DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  String get getBirthDate => DateFormat('yyyy-MM-dd').format(this);
}
