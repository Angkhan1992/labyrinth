import 'dart:async';

import 'package:flutter/material.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/biometric_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/providers/shared_provider.dart';
import 'package:labyrinth/screens/auth/login/biometric_screen.dart';
import 'package:labyrinth/screens/auth/register/individual_screen.dart';
import 'package:labyrinth/screens/auth/register/password_screen.dart';
import 'package:labyrinth/screens/auth/register/purpose_screen.dart';
import 'package:labyrinth/screens/main_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/gradients.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/appbar.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const ProfileScreen({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _event = ValueNotifier(0);

  var _isLoading = false;
  BiometricProvider? _biometricProvider;

  @override
  void initState() {
    super.initState();

    Timer.run(() => _initData());
  }

  void _initData() async {
    _biometricProvider = BiometricProvider.of();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kMainGradient,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: NoAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: offsetXMd,
          ),
          child: ValueListenableBuilder(
            valueListenable: _event,
            builder: (context, value, view) {
              var screens = [
                IndividualScreen(
                  userid: widget.userModel.id!,
                  next: () {
                    _event.value = 1;
                  },
                  progress: (isProgress) {
                    _isLoading = isProgress;
                  },
                ),
                PurposeScreen(
                  userid: widget.userModel.id!,
                  next: () {
                    _event.value = 2;
                  },
                  previous: () {
                    _event.value = 0;
                  },
                  progress: (isProgress) {
                    _isLoading = isProgress;
                  },
                ),
                PasswordScreen(
                  userid: widget.userModel.id!,
                  next: (pass) => _next(pass),
                  previous: () {
                    _event.value = 1;
                  },
                  progress: (isProgress) {
                    _isLoading = isProgress;
                  },
                ),
              ];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: offsetMd,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (_isLoading) return;
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: offsetXMd,
                            color: kAccentColor,
                          ),
                        ),
                        const SizedBox(
                          width: offsetBase,
                        ),
                        S.current.complete_profile
                            .semiBoldText(fontSize: fontXMd),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: offsetXMd,
                  ),
                  screens[_event.value],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _next(String pass) async {
    var _bioStatus = await _biometricProvider!.getState();
    if (_bioStatus == LocalAuthState.none) {
      NavigatorProvider.of(context).push(
        screen: BiometricScreen(
          localProvider: _biometricProvider!,
          password: pass,
          userModel: widget.userModel,
        ),
      );
      return;
    }
    if (_bioStatus == LocalAuthState.noauth) {
      var savedTime = await SharedProvider().getBioTime();
      var currentTime = DateTime.now();
      if (currentTime.isAfter(savedTime.add(const Duration(days: 3)))) {
        NavigatorProvider.of(context).push(
          screen: BiometricScreen(
            localProvider: _biometricProvider!,
            password: pass,
            userModel: widget.userModel,
          ),
        );
        return;
      }
    }
    NavigatorProvider.of(context).push(
      screen: MainScreen(userModel: widget.userModel),
    );
  }
}

enum ProfileEvent {
  none,
  complete,
}
