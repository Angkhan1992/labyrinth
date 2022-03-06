import 'package:flutter/cupertino.dart';
import 'package:labyrinth/themes/colors.dart';

BoxShadow kTopLeftShadow = BoxShadow(
  color: CustomColor.secondaryColor(opacity: 0.2),
  offset: const Offset(1, 1),
  blurRadius: 1.0,
  spreadRadius: 1.0,
);

BoxShadow kBottomRightShadow = BoxShadow(
  color: CustomColor.primaryColor(opacity: 0.2),
  offset: const Offset(-1, -1),
  blurRadius: 1.0,
  spreadRadius: 1.0,
);
