import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/providers/dialog_provider.dart';
import 'package:labyrinth/providers/network_provider.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/shadows.dart';
import 'package:labyrinth/utils/constants.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/textfield.dart';

class UserScreen extends StatefulWidget {
  final Function(String) next;
  final Function(bool) progress;

  const UserScreen({
    Key? key,
    required this.progress,
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
                        S.current.join_to_labyrinth
                            .semiBoldText(fontSize: fontXMd),
                        const SizedBox(
                          height: offsetSm,
                        ),
                        S.current.join_to_detail.thinText(fontSize: fontSm),
                        const SizedBox(
                          height: offsetBase,
                        ),
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
    widget.progress(true);
    var resp = await NetworkProvider.of().post(
      kRegisterUser,
      {
        'email': _email,
        'usrid': _userID,
        'name': _fullName,
      },
    );
    if (resp != null) {
      if (resp['ret'] == 10000) {
        var user = resp['result']['usr_id'];
        if (kDebugMode) {
          print('[Register] user : $user');
        }
        widget.next(user);
      } else {
        DialogProvider.of(context).showSnackBar(
          resp['msg'],
          type: SnackBarType.ERROR,
        );
      }
    }
    _event!.value = UserEvent.none;
    widget.progress(false);
  }
}

enum UserEvent {
  none,
  next,
}
