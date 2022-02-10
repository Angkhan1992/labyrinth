import 'package:flutter/material.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/widgets/appbar.dart';

class MainScreen extends StatefulWidget {
  final UserModel userModel;
  const MainScreen({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NoAppBar(),
    );
  }
}
