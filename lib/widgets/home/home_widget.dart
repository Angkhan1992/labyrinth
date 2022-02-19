import 'dart:math';

import 'package:flutter/material.dart';
import 'package:labyrinth/themes/colors.dart';
import 'package:labyrinth/themes/dimens.dart';
import 'package:labyrinth/utils/extension.dart';

class CreateRoomWidget extends StatelessWidget {
  final Widget icon;
  final String title;
  final Color color;
  final Function()? onClick;

  const CreateRoomWidget({
    Key? key,
    required this.icon,
    this.color = kAccentColor,
    required this.title,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 7.0, top: 7.0),
            child: CustomPaint(
              painter: RoomShadowPainter(),
              child: ClipPath(
                clipper: RoomClipper(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(offsetBase),
                  color: Colors.white,
                  child: InkWell(
                    onTap: onClick,
                    child: Column(
                      children: [
                        // icon,
                        const SizedBox(
                          height: offsetSm,
                        ),
                        title.mediumText(
                          fontSize: fontSm,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: icon,
            ),
          ),
        ],
      ),
    );
  }
}

Path roomPath({
  required Size size,
}) {
  const radius = 8.0;
  const iconLg = 52.0;
  const iconSm = 36.0;

  var path = Path();
  path.moveTo(iconSm, 0);
  path.arcToPoint(
    const Offset(0, iconSm),
    radius: const Radius.circular(iconLg * 0.5),
    rotation: pi / 2,
    clockwise: true,
  );
  path.lineTo(0, size.height - radius);
  path.quadraticBezierTo(
    0,
    size.height,
    radius,
    size.height,
  );
  path.lineTo(size.width - radius, size.height);
  path.quadraticBezierTo(
      size.width, size.height, size.width, size.height - radius);
  path.lineTo(size.width, radius);
  path.quadraticBezierTo(size.width, 0, size.width - radius, 0);
  path.lineTo(iconSm, 0);
  path.close();

  return path;
}

class RoomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = roomPath(size: size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class RoomShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = roomPath(size: size);
    canvas.drawShadow(path, Colors.white, 2.0, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
