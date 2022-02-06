import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';

String kAppName = S.current.appName;
const kFontFamily = 'Poppins';

class Constants {
  static dynamic getCountryList(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/jsons/country.json");
    return jsonDecode(data);
  }
}
