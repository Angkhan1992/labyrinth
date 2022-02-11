import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';

bool isShowing = false;

class LoadingProvider {
  final BuildContext? context;

  LoadingProvider(this.context);

  factory LoadingProvider.of(context) {
    return LoadingProvider(context);
  }

  bool hide() {
    if (context == null) {
      return true;
    }
    isShowing = false;
    Navigator.of(context!).pop(true);
    return true;
  }

  bool show() {
    if (context == null) {
      return true;
    }
    isShowing = true;
    showDialog<dynamic>(
        context: context!,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                kAccentColor,
              ),
            ),
          );
        },
        useRootNavigator: false);
    return true;
  }
}
