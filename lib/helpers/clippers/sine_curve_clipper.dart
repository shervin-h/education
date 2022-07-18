import 'package:flutter/material.dart';

class SineCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 4/5 * size.height);

    Offset curvePoint1 = Offset(size.width / 4, size.height);
    Offset centerPoint = Offset(size.width / 2, 4/5 * size.height);
    path.quadraticBezierTo(
      curvePoint1.dx,
      curvePoint1.dy,
      centerPoint.dx,
      centerPoint.dy,
    );

    Offset curvePoint2 = Offset(3/4 * size.width, 3/5 * size.height);
    Offset endPoint = Offset(size.width, 4/5 * size.height);
    path.quadraticBezierTo(
      curvePoint2.dx,
      curvePoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
