import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoAppBar extends AppBar {
  NoAppBar({Key? key})
      : super(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        );
}
