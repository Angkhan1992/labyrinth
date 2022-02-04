import 'package:flutter/material.dart';

class NoAppBar extends AppBar {
  NoAppBar({Key? key})
      : super(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
        );
}
