import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:labyrinth/generated/l10n.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/themes/textstyles.dart';
import 'package:line_icons/line_icons.dart';

class DialogProvider {
  final BuildContext context;

  DialogProvider(this.context);

  factory DialogProvider.of(BuildContext context) {
    return DialogProvider(context);
  }

  Future<dynamic> bubbleDialog({
    required Widget child,
    required List<Widget> actions,
    String iconUrl = 'assets/images/logo.png',
    double iconBorderWidth = 2.0,
    EdgeInsets childPadding = const EdgeInsets.all(offsetXMd),
    Color background = Colors.white,
    double borderRadius = offsetBase,
    Color borderColor = kAccentColor,
    double borderWidth = 2.0,
    double bubbleSize = 80.0,
    double sigmaSize = 5.0,
    bool isCancelable = false,
  }) async {
    return await showDialog<dynamic>(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          if (isCancelable) Navigator.of(context).pop();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigmaSize, sigmaY: sigmaSize),
            child: Padding(
              padding: const EdgeInsets.all(offsetBase),
              child: Center(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: bubbleSize / 2),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius:
                                BorderRadius.all(Radius.circular(borderRadius)),
                            border: Border.all(
                              color: borderColor,
                              width: borderWidth,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: offsetLg),
                              Padding(
                                padding: childPadding,
                                child: child,
                              ),
                              Row(
                                children: [
                                  for (var action in actions)
                                    Expanded(child: action),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          width: bubbleSize,
                          height: bubbleSize,
                          decoration: BoxDecoration(
                            color: background,
                            border: Border.all(
                              color: borderColor,
                              width: iconBorderWidth,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(bubbleSize / 2.0),
                            child: Image.asset(iconUrl),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(
    String content, {
    SnackBarType type = SnackBarType.SUCCESS,
  }) async {
    var backgroundColor = Colors.white;
    var icons = LineIcons.check;
    var title = S.current.success;
    switch (type) {
      case SnackBarType.SUCCESS:
        backgroundColor = Colors.green;
        icons = Icons.check_circle_outline;
        title = S.current.success;
        break;
      case SnackBarType.WARING:
        backgroundColor = Colors.orange;
        icons = Icons.warning_amber_outlined;
        title = S.current.waring;
        break;
      case SnackBarType.INFO:
        backgroundColor = Colors.blueGrey;
        icons = Icons.info_outline;
        title = S.current.information;
        break;
      case SnackBarType.ERROR:
        backgroundColor = Colors.red;
        icons = Icons.cancel_outlined;
        title = S.current.error;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Stack(
          children: [
            Positioned(
              top: 3,
              left: 3,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [kPrimaryColor, backgroundColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icons,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
            ),
            CustomPaint(
              painter: DialogBackPainter(),
              child: ClipPath(
                clipper: DialogBackClipper(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(offsetBase),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [backgroundColor, kHintColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: offsetXLg),
                        child: Text(
                          title,
                          style: CustomText.bold(
                              fontSize: fontMd, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: offsetSm),
                      Text(
                        content,
                        style: CustomText.medium(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(milliseconds: 3000),
      ),
    );
  }

  void showBottomSheet(Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(offsetBase),
          topLeft: Radius.circular(offsetBase),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (_) => Container(
        padding: const EdgeInsets.all(offsetBase),
        child: child,
      ),
    );
  }

  void kShowProcessingDialog() {
    showSnackBar(
      S.current.processingWaring,
      type: SnackBarType.WARING,
    );
  }
}

enum SnackBarType { SUCCESS, WARING, INFO, ERROR }

Path snakeBarPath({
  required Size size,
}) {
  var radius = 16.0;
  var tapRadius = 24.0;

  var path = Path();
  path.moveTo(tapRadius, 0);
  path.lineTo(size.width - radius, 0);
  path.quadraticBezierTo(size.width, 0, size.width, radius);
  path.lineTo(size.width, size.height - radius);
  path.quadraticBezierTo(
      size.width, size.height, size.width - radius, size.height);
  path.lineTo(radius, size.height);
  path.quadraticBezierTo(0, size.height, 0, size.height - radius);
  path.lineTo(0, tapRadius);
  path.arcToPoint(
    Offset(
      tapRadius,
      0,
    ),
    radius: Radius.circular(tapRadius - 2),
    clockwise: false,
    rotation: pi * 3 / 2,
    largeArc: true,
  );
  path.close();

  return path;
}

class DialogBackClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = snakeBarPath(size: size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class DialogBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = snakeBarPath(size: size);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
