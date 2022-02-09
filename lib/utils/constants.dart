import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';

String kAppName = S.current.appName;
const kFontFamily = 'Poppins';

const kBaseUrl = 'https://labyrinth.laodev.info/';

const kAuth = kBaseUrl + 'Auth/';
const kRegisterUser = kAuth + 'register_user';
const kAddIndividual = kAuth + 'add_individual';
const kAddPurpose = kAuth + 'add_purpose';
const kAddPassword = kAuth + 'add_password';
const kNormalLogin = kAuth + 'login_normal';

class Constants {
  static dynamic getCountryList(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/jsons/country.json");
    return jsonDecode(data);
  }
}
