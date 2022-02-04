import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';

OutlineInputBorder textFieldOutBorder = const OutlineInputBorder(
  borderSide: BorderSide(color: kSecondaryColor, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
);

OutlineInputBorder textFieldErrorOutBorder = const OutlineInputBorder(
  borderSide: BorderSide(color: kErrorColor, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(offsetSm)),
);