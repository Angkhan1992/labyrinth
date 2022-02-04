import 'package:flutter/material.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/screens/auth/login_screen.dart';
import 'package:labyrinth/widgets/appbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () => NavigatorProvider.of(context).push(screen: const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NoAppBar(),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 200.0,
          height: 200.0,
        ),
      ),
    );
  }
}
