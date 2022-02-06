import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/button.dart';
import 'package:labyrinth/widgets/textfield.dart';

class UserScreen extends StatefulWidget {
  final Function() next;

  const UserScreen({
    Key? key,
    required this.next,
  }) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  ValueNotifier<UserEvent>? _event;

  final _formKey = GlobalKey<FormState>();
  var _autoValidate = AutovalidateMode.disabled;

  var _fullName = '';
  var _userID = '';
  var _email = '';
  var _code = '';

  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _event = ValueNotifier(UserEvent.none);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
          valueListenable: _event!,
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
                        S.current.fullName.thinText(),
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
                        S.current.userID.thinText(),
                        const SizedBox(
                          height: offsetSm,
                        ),
                        CustomTextField(
                          hintText: S.current.userID,
                          prefixIcon: const Icon(LineIcons.identificationBadge),
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
                        S.current.email.thinText(),
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
                        S.current.verifyCode.thinText(),
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
                              isLoading: _event!.value == UserEvent.send,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: offsetBase,
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
                  child: S.current.next.button(
                    isLoading: _event!.value == UserEvent.next,
                    onPressed: () => _next(),
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

  void _sendCode() async {
    if (_event!.value != UserEvent.none) {
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

    _event!.value = UserEvent.send;
    await Future.delayed(const Duration(seconds: 3));
    _event!.value = UserEvent.none;
  }

  void _next() async {
    if (_event!.value != UserEvent.none) {
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

    _event!.value = UserEvent.next;
    await Future.delayed(const Duration(seconds: 3));
    _event!.value = UserEvent.none;
    widget.next();
  }
}

enum UserEvent {
  none,
  send,
  next,
}
