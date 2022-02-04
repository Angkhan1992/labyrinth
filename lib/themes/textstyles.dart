import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';

const kTextBold = TextStyle(
  fontFamily: kFontFamily,
  fontSize: fontSm,
  color: kSecondaryColor,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.7,
);

const kTextSemiBold = TextStyle(
  fontFamily: kFontFamily,
  fontSize: fontSm,
  color: kSecondaryColor,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.4,
);

const kTextMedium = TextStyle(
  fontFamily: kFontFamily,
  fontSize: fontSm,
  color: kSecondaryColor,
  fontWeight: FontWeight.w500,
  letterSpacing: 1.3,
);

const kTextRegular = TextStyle(
  fontFamily: kFontFamily,
  fontSize: fontSm,
  color: kSecondaryColor,
  fontWeight: FontWeight.w400,
  letterSpacing: 1.2,
);

const kTextThin = TextStyle(
  fontFamily: kFontFamily,
  fontSize: fontSm,
  color: kSecondaryColor,
  fontWeight: FontWeight.w300,
  letterSpacing: 1.1,
);

class CustomText {
  static TextStyle bold({double? fontSize, Color? color}) {
    return kTextBold.copyWith(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle semiBold({double? fontSize, Color? color}) {
    return kTextSemiBold.copyWith(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle medium({double? fontSize, Color? color}) {
    return kTextMedium.copyWith(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle regular({double? fontSize, Color? color}) {
    return kTextRegular.copyWith(
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle thin({double? fontSize, Color? color}) {
    return kTextThin.copyWith(
      fontSize: fontSize,
      color: color,
    );
  }
}
