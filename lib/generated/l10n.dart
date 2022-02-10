// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Labyrinth`
  String get appName {
    return Intl.message(
      'Labyrinth',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `The email is empty`
  String get emailEmpty {
    return Intl.message(
      'The email is empty',
      name: 'emailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `The email is not match`
  String get emailNotMatch {
    return Intl.message(
      'The email is not match',
      name: 'emailNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `The password is empty`
  String get passwordEmpty {
    return Intl.message(
      'The password is empty',
      name: 'passwordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `The password length should be over 6 characters`
  String get passwordLess {
    return Intl.message(
      'The password length should be over 6 characters',
      name: 'passwordLess',
      desc: '',
      args: [],
    );
  }

  /// `The content is empty`
  String get emptyValue {
    return Intl.message(
      'The content is empty',
      name: 'emptyValue',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `If you have not account yet?`
  String get notAccount {
    return Intl.message(
      'If you have not account yet?',
      name: 'notAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Waring`
  String get waring {
    return Intl.message(
      'Waring',
      name: 'waring',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get information {
    return Intl.message(
      'Information',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Processing now...`
  String get processingWaring {
    return Intl.message(
      'Processing now...',
      name: 'processingWaring',
      desc: '',
      args: [],
    );
  }

  /// `Verify Code`
  String get verifyCode {
    return Intl.message(
      'Verify Code',
      name: 'verifyCode',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `DOB`
  String get birth {
    return Intl.message(
      'DOB',
      name: 'birth',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Re-Password`
  String get rePassword {
    return Intl.message(
      'Re-Password',
      name: 'rePassword',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `User ID`
  String get userID {
    return Intl.message(
      'User ID',
      name: 'userID',
      desc: '',
      args: [],
    );
  }

  /// `Choose Gender`
  String get choose_gender {
    return Intl.message(
      'Choose Gender',
      name: 'choose_gender',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields`
  String get not_complete_field {
    return Intl.message(
      'Please fill all fields',
      name: 'not_complete_field',
      desc: '',
      args: [],
    );
  }

  /// `Join to Labyrinth`
  String get join_to_labyrinth {
    return Intl.message(
      'Join to Labyrinth',
      name: 'join_to_labyrinth',
      desc: '',
      args: [],
    );
  }

  /// `This data will be used for app auth`
  String get join_to_detail {
    return Intl.message(
      'This data will be used for app auth',
      name: 'join_to_detail',
      desc: '',
      args: [],
    );
  }

  /// `Add Personal Data`
  String get add_user_data {
    return Intl.message(
      'Add Personal Data',
      name: 'add_user_data',
      desc: '',
      args: [],
    );
  }

  /// `We will not share that information`
  String get add_user_detail {
    return Intl.message(
      'We will not share that information',
      name: 'add_user_detail',
      desc: '',
      args: [],
    );
  }

  /// `Purpose`
  String get purpose {
    return Intl.message(
      'Purpose',
      name: 'purpose',
      desc: '',
      args: [],
    );
  }

  /// `Why to Join to Labyrinth?`
  String get why_to_join_labyrinth {
    return Intl.message(
      'Why to Join to Labyrinth?',
      name: 'why_to_join_labyrinth',
      desc: '',
      args: [],
    );
  }

  /// `Choose Country`
  String get choose_country {
    return Intl.message(
      'Choose Country',
      name: 'choose_country',
      desc: '',
      args: [],
    );
  }

  /// `Intelligence`
  String get intelligence {
    return Intl.message(
      'Intelligence',
      name: 'intelligence',
      desc: '',
      args: [],
    );
  }

  /// `Interesting`
  String get interesting {
    return Intl.message(
      'Interesting',
      name: 'interesting',
      desc: '',
      args: [],
    );
  }

  /// `Gaming`
  String get gaming {
    return Intl.message(
      'Gaming',
      name: 'gaming',
      desc: '',
      args: [],
    );
  }

  /// `Meet Friend`
  String get meet_friend {
    return Intl.message(
      'Meet Friend',
      name: 'meet_friend',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Experience of Labyrinth?`
  String get what_level {
    return Intl.message(
      'Experience of Labyrinth?',
      name: 'what_level',
      desc: '',
      args: [],
    );
  }

  /// `Beginner`
  String get beginner {
    return Intl.message(
      'Beginner',
      name: 'beginner',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get medium {
    return Intl.message(
      'Medium',
      name: 'medium',
      desc: '',
      args: [],
    );
  }

  /// `Senior`
  String get senior {
    return Intl.message(
      'Senior',
      name: 'senior',
      desc: '',
      args: [],
    );
  }

  /// `Expert`
  String get expert {
    return Intl.message(
      'Expert',
      name: 'expert',
      desc: '',
      args: [],
    );
  }

  /// `Almost Done`
  String get almost_done {
    return Intl.message(
      'Almost Done',
      name: 'almost_done',
      desc: '',
      args: [],
    );
  }

  /// `You can choose Labyrinth Password`
  String get password_detail {
    return Intl.message(
      'You can choose Labyrinth Password',
      name: 'password_detail',
      desc: '',
      args: [],
    );
  }

  /// `· Lowercase at least one`
  String get has_lowcase {
    return Intl.message(
      '· Lowercase at least one',
      name: 'has_lowcase',
      desc: '',
      args: [],
    );
  }

  /// `· Uppercase at least one`
  String get has_upcase {
    return Intl.message(
      '· Uppercase at least one',
      name: 'has_upcase',
      desc: '',
      args: [],
    );
  }

  /// `· Special char at least one`
  String get has_special {
    return Intl.message(
      '· Special char at least one',
      name: 'has_special',
      desc: '',
      args: [],
    );
  }

  /// `· Number at least one`
  String get has_number {
    return Intl.message(
      '· Number at least one',
      name: 'has_number',
      desc: '',
      args: [],
    );
  }

  /// `· At least 8 characters`
  String get has_length {
    return Intl.message(
      '· At least 8 characters',
      name: 'has_length',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get repass {
    return Intl.message(
      'Confirm Password',
      name: 'repass',
      desc: '',
      args: [],
    );
  }

  /// `Not match password`
  String get not_match_pwd {
    return Intl.message(
      'Not match password',
      name: 'not_match_pwd',
      desc: '',
      args: [],
    );
  }

  /// `Successfully register to Labyrinth`
  String get success_register {
    return Intl.message(
      'Successfully register to Labyrinth',
      name: 'success_register',
      desc: '',
      args: [],
    );
  }

  /// `You can try to login and join to Labyrinth`
  String get success_register_detail {
    return Intl.message(
      'You can try to login and join to Labyrinth',
      name: 'success_register_detail',
      desc: '',
      args: [],
    );
  }

  /// `We just sent a verification code to your email`
  String get verify_detail {
    return Intl.message(
      'We just sent a verification code to your email',
      name: 'verify_detail',
      desc: '',
      args: [],
    );
  }

  /// `If you have not got a code?`
  String get not_get_code {
    return Intl.message(
      'If you have not got a code?',
      name: 'not_get_code',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resend_code {
    return Intl.message(
      'Resend Code',
      name: 'resend_code',
      desc: '',
      args: [],
    );
  }

  /// `Server Error!`
  String get server_error {
    return Intl.message(
      'Server Error!',
      name: 'server_error',
      desc: '',
      args: [],
    );
  }

  /// `Enable Face ID`
  String get enableFaceID {
    return Intl.message(
      'Enable Face ID',
      name: 'enableFaceID',
      desc: '',
      args: [],
    );
  }

  /// `Enable Touch ID`
  String get enableTouchID {
    return Intl.message(
      'Enable Touch ID',
      name: 'enableTouchID',
      desc: '',
      args: [],
    );
  }

  /// `SignIn more easily after Face ID register`
  String get signEasyFace {
    return Intl.message(
      'SignIn more easily after Face ID register',
      name: 'signEasyFace',
      desc: '',
      args: [],
    );
  }

  /// `SignIn more easily after Touch ID register`
  String get signEasyTouch {
    return Intl.message(
      'SignIn more easily after Touch ID register',
      name: 'signEasyTouch',
      desc: '',
      args: [],
    );
  }

  /// `Set Face ID`
  String get setFaceID {
    return Intl.message(
      'Set Face ID',
      name: 'setFaceID',
      desc: '',
      args: [],
    );
  }

  /// `Set Touch ID`
  String get setTouchID {
    return Intl.message(
      'Set Touch ID',
      name: 'setTouchID',
      desc: '',
      args: [],
    );
  }

  /// `Not now`
  String get notNow {
    return Intl.message(
      'Not now',
      name: 'notNow',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `World`
  String get world {
    return Intl.message(
      'World',
      name: 'world',
      desc: '',
      args: [],
    );
  }

  /// `Blog`
  String get blog {
    return Intl.message(
      'Blog',
      name: 'blog',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Complete Profile`
  String get complete_profile {
    return Intl.message(
      'Complete Profile',
      name: 'complete_profile',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
