import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/themes/colors.dart';

String kAppName = S.current.appName;
const kFontFamily = 'Poppins';

// const kSocketUrl = 'ws://51.89.17.207:52525';
const kSocketUrl = 'ws://192.168.1.5:52525';
const kBaseUrl = 'https://labyrinth.laodev.info/';
const kPackageName = 'com.laodev.labyrinth';

const kAuth = kBaseUrl + 'Auth/';
const kRegisterUser = kAuth + 'register_user';
const kAddIndividual = kAuth + 'add_individual';
const kAddPurpose = kAuth + 'add_purpose';
const kAddPassword = kAuth + 'add_password';
const kNormalLogin = kAuth + 'login_normal';
const kResendCode = kAuth + 'resend_code';
const kSubmitCode = kAuth + 'submit_code';
const kLoginBio = kAuth + 'login_bio';

const kSetting = kBaseUrl + 'Setting/';
const kUpdateUser = kSetting + 'update_user';
const kGetCoins = kSetting + 'get_coins';
const kUpdateEmail = kSetting + 'update_email';
const kUpdatePass = kSetting + 'update_pass';

const kRootAvatar = 'avatar';

class Constants {
  static dynamic getCountryList(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/jsons/country.json");
    return jsonDecode(data);
  }
}

const kEmptyAvatar = Icon(
  Icons.account_circle,
  size: 80.0,
  color: kAccentColor,
);
