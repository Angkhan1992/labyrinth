import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/biometric_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/providers/shared_provider.dart';
import 'package:labyrinth/screens/auth/login/biometric_screen.dart';
import 'package:labyrinth/screens/auth/login/verify_screen.dart';
import 'package:labyrinth/screens/main_screen.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:line_icons/line_icons.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/screens/auth/register_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/gradients.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/themes/textstyles.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/appbar.dart';
import 'package:labyrinth/widgets/button.dart';
import 'package:labyrinth/widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ValueNotifier<LoginEvent>? _event;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  var _isSecurity = true;

  var _email = '';
  var _pass = '';

  BiometricProvider? _biometricProvider;

  @override
  void initState() {
    super.initState();
    _event = ValueNotifier(LoginEvent.none);

    Timer.run(() => _initData());
  }

  void _initData() async {
    _biometricProvider = BiometricProvider.of(
      init: () => _initBiometric(),
    );
  }

  void _initBiometric() async {
    var bioAuth = await _biometricProvider!.getState();
    if (bioAuth == LocalAuthState.auth) {
      _email = (await SharedProvider().getEmail())!;
      _pass = (await SharedProvider().getPass())!;
      _loginBiometric();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _autoValidate = AutovalidateMode.always;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: NoAppBar(),
        body: ValueListenableBuilder<LoginEvent>(
          valueListenable: _event!,
          builder: (context, event, view) {
            return Container(
              padding: const EdgeInsets.all(offsetXMd),
              decoration: BoxDecoration(
                gradient: kMainGradient,
              ),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(offsetLg),
                      boxShadow: [
                        kTopLeftShadow,
                        kBottomRightShadow,
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 120.0,
                      height: 120.0,
                    ),
                  ),
                  const Spacer(),
                  Form(
                    key: _formKey,
                    autovalidateMode: _autoValidate,
                    child: Container(
                      padding: const EdgeInsets.all(offsetBase),
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(offsetBase),
                          boxShadow: [
                            kTopLeftShadow,
                            kBottomRightShadow,
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          S.current.email.thinText(),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          CustomTextField(
                            hintText: S.current.email,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(LineIcons.mailBulk),
                            validator: (email) {
                              return email!.validateEmail;
                            },
                            onSaved: (email) {
                              _email = email!;
                            },
                          ),
                          const SizedBox(
                            height: offsetBase,
                          ),
                          S.current.password.thinText(),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          CustomTextField(
                            hintText: S.current.password,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            obscureText: _isSecurity,
                            prefixIcon: const Icon(LineIcons.lock),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _isSecurity = !_isSecurity;
                                });
                              },
                              child: _isSecurity
                                  ? const Icon(LineIcons.eye)
                                  : const Icon(LineIcons.eyeSlash),
                            ),
                            validator: (pass) {
                              return pass!.validatePassword;
                            },
                            onSaved: (pass) {
                              _pass = pass!;
                            },
                          ),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              Text(
                                S.current.forgotPassword,
                                style: CustomText.regular(
                                  color: kAccentColor,
                                  fontSize: fontSm,
                                ).copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: offsetXMd,
                  ),
                  CustomButton(
                    width: 280.0,
                    btnText: S.current.login,
                    isLoading: _event!.value == LoginEvent.login,
                    onPressed: () => _login(),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => _googleLogin(),
                        child: GoogleButton(
                          isLoading: _event!.value == LoginEvent.google,
                        ),
                      ),
                      const SizedBox(
                        width: offsetXMd,
                      ),
                      InkWell(
                        onTap: () => _appleLogin(),
                        child: AppleButton(
                          isLoading: _event!.value == LoginEvent.apple,
                        ),
                      ),
                      const SizedBox(
                        width: offsetXMd,
                      ),
                      InkWell(
                        onTap: () => _facebookLogin(),
                        child: FacebookButton(
                          isLoading: _event!.value == LoginEvent.facebook,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.current.notAccount,
                        style: kTextRegular,
                      ),
                      const SizedBox(
                        width: offsetSm,
                      ),
                      InkWell(
                        onTap: () => NavigatorProvider.of(context).push(
                          screen: const RegisterScreen(),
                        ),
                        child: Text(
                          S.current.register,
                          style: CustomText.regular(
                            color: kAccentColor,
                          ).copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: offsetBase,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _googleLogin() async {
    if (_event!.value != LoginEvent.none) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    _event!.value = LoginEvent.google;
    await Future.delayed(const Duration(seconds: 3));
    _event!.value = LoginEvent.none;
  }

  void _appleLogin() async {
    if (_event!.value != LoginEvent.none) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    _event!.value = LoginEvent.apple;
    await Future.delayed(const Duration(seconds: 3));
    _event!.value = LoginEvent.none;
  }

  void _facebookLogin() async {
    if (_event!.value != LoginEvent.none) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    _event!.value = LoginEvent.facebook;
    await Future.delayed(const Duration(seconds: 3));
    _event!.value = LoginEvent.none;
  }

  void _login() async {
    if (_event!.value != LoginEvent.none) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _event!.value = LoginEvent.login;
    var resp = await NetworkProvider.of().post(
      kNormalLogin,
      {
        'email': _email,
        'pass': _pass,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var userJson = resp['result'];
        var usrModel = UserModel.fromJson(userJson);
        if (kDebugMode) {
          print('[Login] user : ${usrModel.toJson()}');
        }
        _nextScreen(usrModel);
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    }
    _event!.value = LoginEvent.none;
  }

  void _nextScreen(UserModel usrModel) async {
    if (usrModel.usrCountry == null) {
      NavigatorProvider.of(context).push(
        screen: VerifyScreen(
          userModel: usrModel,
        ),
      );
      return;
    }
    var _bioStatus = await _biometricProvider!.getState();
    if (_bioStatus == LocalAuthState.none) {
      NavigatorProvider.of(context).push(
        screen: BiometricScreen(
          localProvider: _biometricProvider!,
          password: _pass,
          userModel: usrModel,
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
            password: _pass,
            userModel: usrModel,
          ),
        );
        return;
      }
    }
    NavigatorProvider.of(context).push(
      screen: MainScreen(userModel: usrModel),
    );
  }

  void _loginBiometric() async {
    _event!.value = LoginEvent.login;
    var resp = await NetworkProvider.of().post(
      kLoginBio,
      {
        'email': _email,
        'pass': _pass,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var userJson = resp['result'];
        var usrModel = UserModel.fromJson(userJson);
        NavigatorProvider.of(context).push(
          screen: MainScreen(userModel: usrModel),
        );
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    }
    _event!.value = LoginEvent.none;
  }
}

enum LoginEvent {
  none,
  login,
  google,
  apple,
  facebook,
}
