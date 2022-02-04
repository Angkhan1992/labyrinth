import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';

LinearGradient kMainGradient = LinearGradient(
  colors: [
    kScaffoldColor,
    CustomColor.accentColor(opacity: 0.3),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
