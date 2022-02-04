import 'package:flutter/material.dart';
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  var _isSecurity = true;

  var _email = '';
  var _pass = '';

  @override
  void initState() {
    super.initState();
    _event = ValueNotifier(LoginEvent.NONE);
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
                        ]),
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
                          Text(
                            S.current.email,
                            style: kTextThin,
                          ),
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
                          Text(
                            S.current.password,
                            style: kTextThin,
                          ),
                          const SizedBox(
                            height: offsetSm,
                          ),
                          CustomTextField(
                            hintText: S.current.password,
                            keyboardType: TextInputType.visiblePassword,
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
                    isLoading: _event!.value == LoginEvent.LOGIN,
                    onPressed: () => _login(),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => _googleLogin(),
                        child: GoogleButton(
                          isLoading: _event!.value == LoginEvent.GOOGLE,
                        ),
                      ),
                      const SizedBox(
                        width: offsetXMd,
                      ),
                      InkWell(
                        onTap: () => _appleLogin(),
                        child: AppleButton(
                          isLoading: _event!.value == LoginEvent.APPLE,
                        ),
                      ),
                      const SizedBox(
                        width: offsetXMd,
                      ),
                      InkWell(
                        onTap: () => _facebookLogin(),
                        child: FacebookButton(
                          isLoading: _event!.value == LoginEvent.FACEBOOK,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _googleLogin() async {
    if (_event!.value != LoginEvent.NONE) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    _event!.value = LoginEvent.GOOGLE;
    Future.delayed(
        const Duration(seconds: 3), () => _event!.value = LoginEvent.NONE);
  }

  void _appleLogin() async {
    if (_event!.value != LoginEvent.NONE) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    _event!.value = LoginEvent.APPLE;
    Future.delayed(
        const Duration(seconds: 3), () => _event!.value = LoginEvent.NONE);
  }

  void _facebookLogin() async {
    if (_event!.value != LoginEvent.NONE) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    _event!.value = LoginEvent.FACEBOOK;
    Future.delayed(
        const Duration(seconds: 3), () => _event!.value = LoginEvent.NONE);
  }

  void _login() async {
    if (_event!.value != LoginEvent.NONE) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    _event!.value = LoginEvent.LOGIN;
    Future.delayed(
        const Duration(seconds: 3), () => _event!.value = LoginEvent.NONE);
  }
}

enum LoginEvent {
  NONE,
  LOGIN,
  GOOGLE,
  APPLE,
  FACEBOOK,
}
