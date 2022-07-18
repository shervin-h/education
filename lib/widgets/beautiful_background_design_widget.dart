import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BeautifulBackgroundDesignWidget extends StatelessWidget {

  final IconData iconData;
  final Color color;
  final double degree, size, opacity;
  final int duration;
  final AlignmentGeometry alignment;
  final double paddingLeft, paddingRight;

  const BeautifulBackgroundDesignWidget(
      {Key? key,
        required this.iconData,
        required this.color,
        required this.degree,
        required this.size,
        required this.opacity,
        required this.duration,
        required this.alignment,
        required this.paddingLeft,
        required this.paddingRight,
      }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: color.withOpacity(0.4),
      highlightColor: color,
      period: Duration(milliseconds: duration),
      child: Container(
        margin: EdgeInsets.fromLTRB(paddingLeft, 16, paddingRight, 16),
        width: double.infinity,
        alignment: alignment,
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(degree / 360),
          child: Icon(
            iconData,
            size: size,
          ),
        ),
      ),
    );
  }
}