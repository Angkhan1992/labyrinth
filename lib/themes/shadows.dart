import 'package:flutter/cupertino.dart';
import 'package:labyrinth/themes/colors.dart';

BoxShadow kTopLeftShadow = BoxShadow(
  color: CustomColor.secondaryColor(opacity: 0.2),
  offset: const Offset(2, 2),
  blurRadius: 2.0,
  spreadRadius: 1.0,
);

BoxShadow kBottomRightShadow = BoxShadow(
  color: CustomColor.primaryColor(opacity: 0.3),
  offset: const Offset(-2, -2),
  blurRadius: 2.0,
  spreadRadius: 1.0,
);