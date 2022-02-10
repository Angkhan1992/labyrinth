import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/screens/auth/login/profile_screen.dart';
import 'package:labyrinth/screens/main_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/gradients.dart';
import 'package:labyrinth/themes/textstyles.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/appbar.dart';
import 'package:labyrinth/widgets/textfield.dart';

class VerifyScreen extends StatefulWidget {
  final UserModel userModel;

  const VerifyScreen({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _event = ValueNotifier(VerifyEvent.none);

  final _formKey = GlobalKey<FormState>();
  var _autoValidate = AutovalidateMode.disabled;

  var _code = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kMainGradient,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: NoAppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: offsetMd,
              vertical: offsetXMd,
            ),
            child: ValueListenableBuilder(
              valueListenable: _event,
              builder: (context, value, view) {
                return Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: offsetXMd,
                              color: kAccentColor,
                            ),
                          ),
                          const SizedBox(
                            width: offsetBase,
                          ),
                          S.current.verifyCode.semiBoldText(fontSize: fontXMd),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: offsetXMd,
                      ),
                      S.current.verify_detail.regularText(
                        fontSize: fontSm,
                      ),
                      const SizedBox(
                        height: offsetSm,
                      ),
                      widget.userModel.usrEmail!.mediumText(),
                      const SizedBox(
                        height: offsetXMd,
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
                      const SizedBox(
                        height: offsetBase,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: offsetBase),
                        child: S.current.send.button(
                          isLoading: _event.value == VerifyEvent.send,
                          onPressed: () => _send(),
                        ),
                      ),
                      const SizedBox(
                        height: offsetXMd,
                      ),
                      S.current.not_get_code.regularText(
                        fontSize: fontSm,
                      ),
                      const SizedBox(
                        height: offsetSm,
                      ),
                      InkWell(
                        onTap: () => _resend(),
                        child: Text(
                          S.current.resend_code,
                          style: kTextMedium.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _send() async {
    if (_event.value != VerifyEvent.none) {
      DialogProvider.of(context).kShowProcessingDialog();
      return;
    }

    _autoValidate = AutovalidateMode.always;
    if (!_formKey.currentState!.validate()) {
      DialogProvider.of(context).showSnackBar(
        S.current.not_complete_field,
        type: SnackBarType.ERROR,
      );
      return;
    }
    _formKey.currentState!.save();
    _event.value = VerifyEvent.send;
    var resp = await NetworkProvider.of().post(
      kSubmitCode,
      {
        'email': widget.userModel.usrEmail!,
        'other': _code,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var user = resp['result'];
        if (kDebugMode) {
          print('[Verify Code] user : $user');
        }
        if (widget.userModel.usrCountry!.isEmpty) {
          NavigatorProvider.of(context).push(
            screen: ProfileScreen(
              userModel: widget.userModel,
            ),
            replace: true,
          );
        } else {
          NavigatorProvider.of(context).push(
            screen: MainScreen(
              userModel: widget.userModel,
            ),
            replace: true,
          );
        }
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    }
    _event.value = VerifyEvent.none;
  }

  void _resend() async {
    var resp = await NetworkProvider.of().post(
      kResendCode,
      {
        'email': widget.userModel.usrEmail!,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
        );
      } else {
        DialogProvider.of(context).showSnackBar(
          S.current.server_error,
          type: SnackBarType.ERROR,
        );
      }
    } else {
      DialogProvider.of(context).showSnackBar(
        S.current.server_error,
        type: SnackBarType.ERROR,
      );
    }
  }
}

enum VerifyEvent {
  none,
  send,
}
