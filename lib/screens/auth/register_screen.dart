import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/gradients.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/themes/textstyles.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/appbar.dart';
import 'package:labyrinth/widgets/button.dart';
import 'package:labyrinth/widgets/textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ValueNotifier<RegisterEvent>? _event;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  var _isSecurity = true;

  var _fullName = '';
  var _userID = '';
  var _email = '';
  var _code = '';
  var _gender = '';
  var _birth = '';
  var _country = '';
  var _pass = '';
  var _repass = '';

  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _event = ValueNotifier(RegisterEvent.NONE);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _autoValidate = AutovalidateMode.always;
      },
      child: Scaffold(
        appBar: NoAppBar(),
        body: ValueListenableBuilder<RegisterEvent>(
          valueListenable: _event!,
          builder: (context, event, view) {
            return Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: kMainGradient,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomButton(
                      margin: const EdgeInsets.only(
                        left: offsetBase,
                        top: offsetXMd,
                      ),
                      width: kButtonHeight,
                      child: const Icon(
                        LineIcons.backward,
                        color: kPrimaryColor,
                        size: 16.0,
                      ),
                      onPressed: () {
                        if (_event!.value != RegisterEvent.NONE) {
                          DialogProvider.of(context).kShowProcessingDialog();
                          return;
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      height: offsetXMd,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: _autoValidate,
                      child: Container(
                        margin: const EdgeInsets.all(offsetBase),
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
                              S.current.fullName,
                              style: kTextThin,
                            ),
                            const SizedBox(
                              height: offsetSm,
                            ),
                            CustomTextField(
                              hintText: S.current.fullName,
                              prefixIcon: const Icon(LineIcons.user),
                              validator: (name) {
                                return name!.validateValue;
                              },
                              onSaved: (name) {
                                _fullName = name!;
                              },
                            ),
                            const SizedBox(
                              height: offsetBase,
                            ),
                            Text(
                              S.current.userID,
                              style: kTextThin,
                            ),
                            const SizedBox(
                              height: offsetSm,
                            ),
                            CustomTextField(
                              hintText: S.current.userID,
                              prefixIcon:
                                  const Icon(LineIcons.identificationBadge),
                              validator: (userID) {
                                return userID!.validateValue;
                              },
                              onSaved: (userID) {
                                _userID = userID!;
                              },
                            ),
                            const SizedBox(
                              height: offsetBase,
                            ),
                            Text(
                              S.current.email,
                              style: kTextThin,
                            ),
                            const SizedBox(
                              height: offsetSm,
                            ),
                            CustomTextField(
                              hintText: S.current.email,
                              controller: _emailController,
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
                              S.current.verifyCode,
                              style: kTextThin,
                            ),
                            const SizedBox(
                              height: offsetSm,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    hintText: S.current.verifyCode,
                                    prefixIcon: const Icon(LineIcons.code),
                                    validator: (code) {
                                      return code!.validateValue;
                                    },
                                    onSaved: (code) {
                                      _code = code!;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: offsetBase,
                                ),
                                CustomButton(
                                  width: 100,
                                  btnText: S.current.send,
                                  onPressed: () => _sendCode(),
                                  isLoading:
                                      _event!.value == RegisterEvent.SEND,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: offsetBase,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.current.gender,
                                        style: kTextThin,
                                      ),
                                      const SizedBox(
                                        height: offsetSm,
                                      ),
                                      CustomTextField(
                                        hintText: S.current.gender,
                                        prefixIcon:
                                            const Icon(LineIcons.genderless),
                                        suffixIcon:
                                            const Icon(Icons.arrow_drop_down),
                                        readOnly: true,
                                        validator: (gender) {
                                          return gender!.validateValue;
                                        },
                                        onSaved: (gender) {
                                          _gender = gender!;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: offsetSm,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.current.birth,
                                        style: kTextThin,
                                      ),
                                      const SizedBox(
                                        height: offsetSm,
                                      ),
                                      CustomTextField(
                                        hintText: S.current.birth,
                                        prefixIcon:
                                            const Icon(LineIcons.birthdayCake),
                                        suffixIcon:
                                            const Icon(Icons.arrow_drop_down),
                                        readOnly: true,
                                        validator: (birth) {
                                          return birth!.validateValue;
                                        },
                                        onSaved: (birth) {
                                          _birth = birth!;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: offsetBase,
                            ),
                            Text(
                              S.current.country,
                              style: kTextThin,
                            ),
                            const SizedBox(
                              height: offsetSm,
                            ),
                            CustomTextField(
                              hintText: S.current.country,
                              prefixIcon: const Icon(LineIcons.language),
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                              readOnly: true,
                              validator: (country) {
                                return country!.validateValue;
                              },
                              onSaved: (country) {
                                _country = country!;
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
                              height: offsetBase,
                            ),
                            Text(
                              S.current.rePassword,
                              style: kTextThin,
                            ),
                            const SizedBox(
                              height: offsetSm,
                            ),
                            CustomTextField(
                              hintText: S.current.rePassword,
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
                                _repass = pass!;
                              },
                            ),
                            const SizedBox(
                              height: offsetBase,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: offsetXLg,
                    ),
                    Center(
                      child: CustomButton(
                        width: 280.0,
                        btnText: S.current.register,
                        onPressed: () => _register(),
                        isLoading: _event!.value == RegisterEvent.REGISTER,
                      ),
                    ),
                    const SizedBox(
                      height: offsetXMd,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _sendCode() async {
    if (_event!.value != RegisterEvent.NONE) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }

    var email = _emailController.text;
    if (email.validateEmail != null) {
      DialogProvider.of(context).showSnackBar(
        email.validateEmail!,
        type: SnackBarType.ERROR,
      );
      return;
    }

    _event!.value = RegisterEvent.SEND;
    Future.delayed(
        const Duration(seconds: 3), () => _event!.value = RegisterEvent.NONE);
  }

  void _register() async {
    if (_event!.value != RegisterEvent.NONE) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    _event!.value = RegisterEvent.REGISTER;
    Future.delayed(
        const Duration(seconds: 3), () => _event!.value = RegisterEvent.NONE);
  }
}

enum RegisterEvent {
  NONE,
  SEND,
  REGISTER,
}
