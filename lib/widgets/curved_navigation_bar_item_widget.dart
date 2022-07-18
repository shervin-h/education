import 'package:flutter/material.dart';

class CurvedNavigationBarItemWidget extends StatelessWidget {
  const CurvedNavigationBarItemWidget({
    required this.iconData,
    required this.activeColor,
    required this.inactiveColor,
    required this.isActive,
    Key? key
  }) : super(key: key);

  final IconData iconData;
  final Color activeColor;
  final Color inactiveColor;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isActive ? const EdgeInsets.all(15) : const EdgeInsets.all(0),
      decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: isActive ? activeColor.withOpacity(0.8) : inactiveColor.withOpacity(0.8),
                blurRadius: isActive ? 8 : 0,
            )
          ]
      ),
      child: Icon(
        iconData,
        color: isActive ? activeColor : Colors.white,
      ),
    );
  }
}
