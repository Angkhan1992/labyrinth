import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/gradients.dart';
import 'package:labyrinth/themes/textstyles.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/appbar.dart';
import 'package:labyrinth/widgets/textfield.dart';
import 'package:line_icons/line_icons.dart';

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
                        const Icon(
                          Icons.arrow_back_ios,
                          size: offsetXMd,
                          color: kAccentColor,
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
                      child: S.current.next.button(
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
                    Text(
                      S.current.resend_code,
                      style: kTextMedium.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _send() async {}
}

enum VerifyEvent {
  none,
  send,
}
