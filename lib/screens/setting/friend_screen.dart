import 'package:flutter/material.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class FriendScreen extends StatefulWidget {
  final UserModel userModel;
  const FriendScreen({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: 'Friends'.semiBoldText(
          fontSize: fontXMd,
          color: kAccentColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.qr_code_scanner,
              color: kAccentColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
