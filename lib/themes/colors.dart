import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xffffffff);
const kSecondaryColor = Color(0xff000000);
const kScaffoldColor = Color(0xfff8f8f8);
const kAccentColor = Color(0xff3377C7);
const kHintColor = Color(0xffAAB2BA);
const kErrorColor = Color(0xffff0000);

const kTextBlackColor = Color(0xff202020);

class CustomColor {
  static Color primaryColor({required double opacity}) {
    if (opacity < 0) return kPrimaryColor.withOpacity(0);
    if (opacity > 1) return kPrimaryColor;
    return kPrimaryColor.withOpacity(opacity);
  }

  static Color secondaryColor({required double opacity}) {
    if (opacity < 0) return kSecondaryColor.withOpacity(0);
    if (opacity > 1) return kSecondaryColor;
    return kSecondaryColor.withOpacity(opacity);
  }

  static Color accentColor({required double opacity}) {
    if (opacity < 0) return kAccentColor.withOpacity(0);
    if (opacity > 1) return kAccentColor;
    return kAccentColor.withOpacity(opacity);
  }
}
