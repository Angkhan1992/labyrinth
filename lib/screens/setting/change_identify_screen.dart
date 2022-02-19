import 'dart:async';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/textfield.dart';

class ChangeIdentifyScreen extends StatefulWidget {
  final bool isEmail;

  const ChangeIdentifyScreen({
    Key? key,
    required this.isEmail,
  }) : super(key: key);

  @override
  _ChangeIdentifyScreenState createState() => _ChangeIdentifyScreenState();
}

class _ChangeIdentifyScreenState extends State<ChangeIdentifyScreen> {
  final _event = ValueNotifier(ChangeIdentifyEvent.none);

  UserModel? _user;

  String _email = '';
  String _code = '';

  String _passwrd = '';
  var _isSecurity = true;
  final _passController = TextEditingController();
  var _hasLowercase = false;
  var _hasUppercase = false;
  var _hasSpecial = false;
  var _hasNumber = false;
  var _hasLength = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();

    _passController.addListener(() {
      var pwd = _passController.text;

      _hasLowercase = pwd.hasLowercase;
      _hasUppercase = pwd.hasUppercase;
      _hasSpecial = pwd.hasSpecial;
      _hasNumber = pwd.hasNumber;
      _hasLength = pwd.length > 7;

      setState(() {});
    });

    Timer.run(() {
      _user = Provider.of<UserModel>(context, listen: false);
    });
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
        appBar: AppBar(
          elevation: 1,
          title: (widget.isEmail
                  ? S.current.change_email
                  : S.current.change_password)
              .semiBoldText(
            fontSize: fontXMd,
            color: kAccentColor,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: offsetBase,
            vertical: offsetXMd,
          ),
          child: ValueListenableBuilder(
            valueListenable: _event,
            builder: (context, value, view) {
              return _event.value != ChangeIdentifyEvent.success
                  ? Form(
                      key: _formKey,
                      autovalidateMode: _autoValidate,
                      child: Column(
                        children: [
                          Icon(
                            widget.isEmail
                                ? Icons.attach_email_outlined
                                : Icons.vpn_key_outlined,
                            size: 60.0,
                          ),
                          const SizedBox(
                            height: offsetBase,
                          ),
                          S.current.verify_detail.regularText(fontSize: fontSm),
                          const SizedBox(
                            height: offsetXMd,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              S.current.verifyCode.mediumText(),
                              const SizedBox(
                                height: offsetSm,
                              ),
                              CustomTextField(
                                hintText: S.current.verifyCode,
                                prefixIcon: const Icon(LineIcons.code),
                                validator: (code) {
                                  return code!.validateValue;
                                },
                                onSaved: (code) {
                                  _code = code!;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: offsetBase,
                          ),
                          widget.isEmail
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    S.current.new_email.mediumText(),
                                    const SizedBox(
                                      height: offsetSm,
                                    ),
                                    CustomTextField(
                                      hintText: S.current.email,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.emailAddress,
                                      prefixIcon:
                                          const Icon(LineIcons.mailBulk),
                                      validator: (email) {
                                        return email!.validateEmail;
                                      },
                                      onSaved: (email) {
                                        _email = email!;
                                      },
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    S.current.new_password.mediumText(),
                                    const SizedBox(
                                      height: offsetSm,
                                    ),
                                    CustomTextField(
                                      controller: _passController,
                                      hintText: S.current.new_password,
                                      textInputAction: TextInputAction.done,
                                      keyboardType:
                                          TextInputType.visiblePassword,
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
                                        _passwrd = pass!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: offsetBase,
                                    ),
                                    S.current.has_lowcase.thinText(
                                      fontSize: fontXSm,
                                      color: _hasLowercase
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    const SizedBox(
                                      height: offsetXSm,
                                    ),
                                    S.current.has_upcase.thinText(
                                      fontSize: fontXSm,
                                      color: _hasUppercase
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    const SizedBox(
                                      height: offsetXSm,
                                    ),
                                    S.current.has_special.thinText(
                                      fontSize: fontXSm,
                                      color: _hasSpecial
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    const SizedBox(
                                      height: offsetXSm,
                                    ),
                                    S.current.has_number.thinText(
                                      fontSize: fontXSm,
                                      color: _hasNumber
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                    const SizedBox(
                                      height: offsetXSm,
                                    ),
                                    S.current.has_length.thinText(
                                      fontSize: fontXSm,
                                      color: _hasLength
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: offsetXMd,
                          ),
                          widget.isEmail
                              ? S.current.update_email.button(
                                  isLoading:
                                      _event.value != ChangeIdentifyEvent.none,
                                  onPressed: () => _updateEmail(),
                                )
                              : S.current.update_password.button(
                                  isLoading:
                                      _event.value != ChangeIdentifyEvent.none,
                                  onPressed: () => _updatePass(),
                                ),
                        ],
                      ),
                    )
                  : _successWidget();
            },
          ),
        ),
      ),
    );
  }

  void _updateEmail() async {
    _event.value = ChangeIdentifyEvent.update;
    _autoValidate = AutovalidateMode.always;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    var resp = await NetworkProvider.of().post(
      kUpdateEmail,
      {
        'new_email': _email,
        'old_email': _user!.usrEmail!,
        'code': _code,
      },
    );
    if (resp != null && resp['ret'] == 10000) {
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.error,
      );
    }
    _event.value = ChangeIdentifyEvent.none;
  }

  void _updatePass() async {
    if (!_checkPasswordValid()) {
      DialogProvider.of(context).showSnackBar(
        S.current.not_match_pwd,
        type: SnackBarType.error,
      );
      return;
    }
    _autoValidate = AutovalidateMode.always;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    _event.value = ChangeIdentifyEvent.update;
    var resp = await NetworkProvider.of().post(
      kUpdatePass,
      {
        'id': _user!.id!,
        'code': _code,
        'pass': _passwrd,
      },
    );
    if (resp != null && resp['ret'] == 10000) {
      _event.value = ChangeIdentifyEvent.success;
      _user!.setFromJson(resp['result']);
      Future.delayed(
          const Duration(seconds: 3), () => Navigator.of(context).pop());
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.error,
      );
      _event.value = ChangeIdentifyEvent.none;
    }
  }

  bool _checkPasswordValid() {
    return _hasLength &&
        _hasNumber &&
        _hasSpecial &&
        _hasUppercase &&
        _hasLowercase;
  }

  Widget _successWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 90.0,
            color: Colors.green,
          ),
          const SizedBox(
            height: offsetXMd,
          ),
          'Success update profile'.semiBoldText(
            color: Colors.green,
            fontSize: fontXMd,
          ),
          const SizedBox(
            height: offsetXMd,
          ),
          'If you use a local auth feature, that will be removed automatically, You need to reset that again when login'
              .thinText(fontSize: fontSm),
          const SizedBox(
            height: offsetXMd,
          ),
        ],
      ),
    );
  }
}

enum ChangeIdentifyEvent {
  none,
  update,
  success,
}
