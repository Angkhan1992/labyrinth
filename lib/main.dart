import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:labyrinth/providers/injector_provider.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/game_model.dart';
import 'package:labyrinth/models/room_model.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/screens/auth/splash_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/textstyles.dart';
import 'package:labyrinth/utils/constants.dart';

Injector? injector;

class AppInitializer {
  initialise(Injector? injector) async {}
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  InjectProvider().initialise(Injector());
  injector = Injector();
  await AppInitializer().initialise(injector!);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => GameModel()..init()),
        ChangeNotifierProvider(create: (context) => RoomModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Labyrinth',
      debugShowCheckedModeBanner: false,
      theme: getThemeData(),
      home: const SplashScreen(),
      // ignore: prefer_const_literals_to_create_immutables
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  getThemeData() {
    return ThemeData(
      fontFamily: kFontFamily,
      brightness: Brightness.light,
      primaryColor: kPrimaryColor,
      secondaryHeaderColor: kSecondaryColor,
      scaffoldBackgroundColor: kScaffoldColor,
      backgroundColor: kScaffoldColor,
      hintColor: kHintColor,
      focusColor: kAccentColor,
      textTheme: TextTheme(
        headline6: kTextBold,
        headline5: CustomText.bold(fontSize: fontMd),
        headline4: CustomText.bold(fontSize: fontXMd),
        headline3: CustomText.bold(fontSize: 20.0),
        headline2: CustomText.bold(fontSize: fontLg),
        headline1: CustomText.bold(fontSize: fontXLg),
        subtitle1: CustomText.semiBold(fontSize: fontMd),
        bodyText2: kTextMedium,
        bodyText1: CustomText.medium(fontSize: fontMd),
        caption: kTextRegular,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        iconTheme: IconThemeData(color: kAccentColor),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      dividerTheme: const DividerThemeData(
        color: kHintColor,
        thickness: 0.5,
      ),
    );
  }
}
