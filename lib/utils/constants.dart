import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/themes/colors.dart';

String kAppName = S.current.appName;
const kFontFamily = 'Poppins';

// const kSocketUrl = 'ws://51.89.17.207:52525';
const kSocketUrl = 'ws://192.168.1.201:52525';
// const kBaseUrl = 'https://labyrinth.laodev.info/';
const kBaseUrl = 'http://192.168.1.201/';
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
const kContactUser = kSetting + 'contact_user';
const kGetContact = kSetting + 'get_contact';
const kSendRequest = kSetting + 'send_request';
const kDeclineRequest = kSetting + 'decline_request';
const kAcceptRequest = kSetting + 'accept_request';
const kGetUser = kSetting + 'get_user';
const kGetRelation = kSetting + 'get_relation';
const kReport = kSetting + 'report';
const kAddFollow = kSetting + 'add_follow';

const kHome = kBaseUrl + 'Home/';
const kCreateRoom = kHome + 'create_room';
const kJoinRoom = kHome + 'join_room';
const kLeaveUser = kHome + 'leave_user';
const kGetRooms = kHome + 'get_rooms';
const kGetRoom = kHome + 'get_room';

const kRootAvatar = 'avatar';

const kUserColors = [
  Colors.blue,
  Colors.red,
  Colors.teal,
  Colors.deepPurple,
];

class Constants {
  static dynamic getCountryList(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/jsons/country.json");
    return jsonDecode(data);
  }
}

const kEmptyAvatarLg = Icon(
  Icons.account_circle,
  size: 80.0,
  color: kAccentColor,
);

const kEmptyAvatarMd = Icon(
  Icons.account_circle,
  size: 44.0,
  color: kAccentColor,
);
