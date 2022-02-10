import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/textfield.dart';
import 'package:line_icons/line_icons.dart';

class PasswordScreen extends StatefulWidget {
  final String userid;
  final Function(String) next;
  final Function() previous;
  final Function(bool) progress;

  const PasswordScreen({
    Key? key,
    required this.userid,
    required this.next,
    required this.previous,
    required this.progress,
  }) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _event = ValueNotifier(PasswordEvent.none);

  final _formKey = GlobalKey<FormState>();
  var _autoValidate = AutovalidateMode.disabled;

  var _isPassword = true;
  var _isRePassword = true;

  var _hasLowercase = false;
  var _hasUppercase = false;
  var _hasSpecial = false;
  var _hasNumber = false;
  var _hasLength = false;

  var _pass = '';
  var _repass = '';

  final _passController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _autoValidate = AutovalidateMode.always;
      },
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: _event,
          builder: (context, value, view) {
            return Column(
              children: [
                Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: offsetBase),
                    padding: const EdgeInsets.all(offsetBase),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(offsetBase),
                      boxShadow: [
                        kTopLeftShadow,
                        kBottomRightShadow,
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        S.current.almost_done.semiBoldText(fontSize: fontXMd),
                        const SizedBox(
                          width: double.infinity,
                          height: offsetSm,
                        ),
                        S.current.password_detail.thinText(fontSize: fontSm),
                        const SizedBox(
                          height: offsetBase,
                        ),
                        S.current.password.thinText(),
                        const SizedBox(
                          height: offsetSm,
                        ),
                        CustomTextField(
                          controller: _passController,
                          hintText: S.current.password,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _isPassword,
                          prefixIcon: const Icon(LineIcons.lock),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _isPassword = !_isPassword;
                              });
                            },
                            child: _isPassword
                                ? const Icon(LineIcons.eye)
                                : const Icon(LineIcons.eyeSlash),
                          ),
                          onSaved: (pass) {
                            _pass = pass!;
                          },
                        ),
                        const SizedBox(
                          height: offsetBase,
                        ),
                        S.current.repass.thinText(),
                        const SizedBox(
                          height: offsetSm,
                        ),
                        CustomTextField(
                          hintText: S.current.repass,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _isRePassword,
                          prefixIcon: const Icon(LineIcons.lock),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _isRePassword = !_isRePassword;
                              });
                            },
                            child: _isRePassword
                                ? const Icon(LineIcons.eye)
                                : const Icon(LineIcons.eyeSlash),
                          ),
                          onSaved: (repass) {
                            _repass = repass!;
                          },
                        ),
                        const SizedBox(
                          height: offsetBase,
                        ),
                        S.current.has_lowcase.thinText(
                          fontSize: fontXSm,
                          color: _hasLowercase ? Colors.green : Colors.black,
                        ),
                        const SizedBox(
                          height: offsetXSm,
                        ),
                        S.current.has_upcase.thinText(
                          fontSize: fontXSm,
                          color: _hasUppercase ? Colors.green : Colors.black,
                        ),
                        const SizedBox(
                          height: offsetXSm,
                        ),
                        S.current.has_special.thinText(
                          fontSize: fontXSm,
                          color: _hasSpecial ? Colors.green : Colors.black,
                        ),
                        const SizedBox(
                          height: offsetXSm,
                        ),
                        S.current.has_number.thinText(
                          fontSize: fontXSm,
                          color: _hasNumber ? Colors.green : Colors.black,
                        ),
                        const SizedBox(
                          height: offsetXSm,
                        ),
                        S.current.has_length.thinText(
                          fontSize: fontXSm,
                          color: _hasLength ? Colors.green : Colors.black,
                        ),
                        const SizedBox(
                          height: offsetSm,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: offsetBase,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: offsetBase),
                  child: Row(
                    children: [
                      Expanded(
                        child: S.current.previous.button(
                          borderWidth: 2.0,
                          onPressed: () => _previous(),
                        ),
                      ),
                      Expanded(
                        child: S.current.next.button(
                          isLoading: _event.value == PasswordEvent.next,
                          onPressed: () => _next(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: offsetXMd,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _previous() async {
    if (_event.value != PasswordEvent.none) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }
    widget.previous();
  }

  void _next() async {
    if (_event.value != PasswordEvent.none) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }

    _autoValidate = AutovalidateMode.always;
    if (!_checkPasswordValid()) {
      DialogProvider.of(context).showSnackBar(
        S.current.not_complete_field,
        type: SnackBarType.ERROR,
      );
      return;
    }
    _formKey.currentState!.save();
    if (_pass != _repass) {
      DialogProvider.of(context).showSnackBar(
        S.current.not_match_pwd,
        type: SnackBarType.ERROR,
      );
      return;
    }

    _event.value = PasswordEvent.next;
    widget.progress(true);
    var resp = await NetworkProvider.of().post(
      kAddPassword,
      {
        'password': _pass,
        'userid': widget.userid,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var user = resp['result']['updated'];
        if (kDebugMode) {
          print('[Individual] user : $user');
        }
        widget.next(_pass);
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    }
    _event.value = PasswordEvent.none;
    widget.progress(false);
  }

  bool _checkPasswordValid() {
    return _hasLength &&
        _hasNumber &&
        _hasSpecial &&
        _hasUppercase &&
        _hasLowercase;
  }
}

enum PasswordEvent {
  none,
  next,
}
