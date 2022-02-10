import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';

import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/models/user_model.dart';
import 'package:labyrinth/providers/biometric_provider.dart';
import 'package:labyrinth/providers/navigator_provider.dart';
import 'package:labyrinth/providers/shared_provider.dart';
import 'package:labyrinth/screens/main_screen.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';
import 'package:labyrinth/widgets/appbar.dart';

class BiometricScreen extends StatefulWidget {
  final BiometricProvider localProvider;
  final UserModel userModel;
  final String password;

  const BiometricScreen({
    Key? key,
    required this.localProvider,
    required this.password,
    required this.userModel,
  }) : super(key: key);

  @override
  _BiometricScreenState createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: NoAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(offsetXMd),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      widget.localProvider.availableType() == BiometricType.face
                          ? 'assets/icons/ic_face_id.svg'
                          : 'assets/icons/ic_touch_id.svg',
                      width: 90.0,
                      height: 90.0,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: offsetXLg,
                    ),
                    (widget.localProvider.availableType() == BiometricType.face
                            ? S.current.enableFaceID
                            : S.current.enableTouchID)
                        .semiBoldText(fontSize: fontMd),
                    const SizedBox(
                      height: offsetSm,
                    ),
                    (widget.localProvider.availableType() == BiometricType.face
                            ? S.current.signEasyFace
                            : S.current.signEasyTouch)
                        .regularText(fontSize: fontSm),
                    const SizedBox(
                      height: offsetXLg,
                    ),
                    (widget.localProvider.availableType() == BiometricType.face
                            ? S.current.setFaceID
                            : S.current.setTouchID)
                        .button(
                      onPressed: () => _onClickEnable(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: offsetXLg,
            ),
            InkWell(
              onTap: () => _onClickNotNow(),
              child: S.current.notNow.mediumText(),
            ),
            const SizedBox(
              height: offsetXLg,
            ),
          ],
        ),
      ),
    );
  }

  void _onClickEnable() async {
    var res = await widget.localProvider.authenticateWithBiometrics();
    if (res != null) {
      await SharedProvider().setBioAuth(true);
      await SharedProvider().setEmail(widget.userModel.usrEmail!);
      await SharedProvider().setPass(widget.password);
    } else {
      await SharedProvider().setBioAuth(false);
      await SharedProvider().setBioTime(DateTime.now());
    }
    _next();
  }

  void _onClickNotNow() async {
    await SharedProvider().setBioAuth(false);
    await SharedProvider().setBioTime(DateTime.now());
    _next();
  }

  void _next() {
    NavigatorProvider.of(context).push(
      screen: MainScreen(userModel: widget.userModel),
      replace: true,
    );
  }
}
