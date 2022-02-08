import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/screens/auth/complete_screen.dart';
import 'package:labyrinth/screens/auth/register/individual_screen.dart';
import 'package:labyrinth/screens/auth/register/password_screen.dart';
import 'package:labyrinth/screens/auth/register/purpose_screen.dart';
import 'package:labyrinth/screens/auth/register/user_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/gradients.dart';
import 'package:labyrinth/widgets/appbar.dart';
import 'package:labyrinth/widgets/button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ValueNotifier<int>? _pageEvent;

  var userid = '';
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageEvent = ValueNotifier(0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NoAppBar(),
      body: ValueListenableBuilder<int>(
        valueListenable: _pageEvent!,
        builder: (context, value, view) {
          List<Widget> contentWidgets = [
            UserScreen(
              next: (userid) {
                this.userid = userid;
                _pageEvent!.value = 1;
              },
              progress: (progress) => isLoading = progress,
            ),
            IndividualScreen(
              userid: userid,
              next: () => _pageEvent!.value = 2,
              previous: () => _pageEvent!.value = 0,
              progress: (progress) => isLoading = progress,
            ),
            PurposeScreen(
              userid: userid,
              next: () => _pageEvent!.value = 3,
              previous: () => _pageEvent!.value = 1,
              progress: (progress) => isLoading = progress,
            ),
            PasswordScreen(
              next: () => NavigatorProvider.of(context).push(
                screen: const CompleteScreen(),
                replace: true,
              ),
              previous: () => _pageEvent!.value = 2,
            ),
          ];
          return Container(
            decoration: BoxDecoration(
              gradient: kMainGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButton(
                  margin: const EdgeInsets.only(
                    left: offsetBase,
                    top: offsetBase,
                  ),
                  width: kButtonHeight,
                  child: const Icon(
                    LineIcons.backward,
                    color: kPrimaryColor,
                    size: 16.0,
                  ),
                  onPressed: () {
                    if (isLoading) {
                      DialogProvider.of(context).kShowProcessingDialog();
                      return;
                    }
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  height: offsetBase,
                ),
                Expanded(child: contentWidgets[value]),
              ],
            ),
          );
        },
      ),
    );
  }
}
