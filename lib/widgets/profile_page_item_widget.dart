import 'package:flutter/material.dart';

class ProfilePageItemWidget extends StatelessWidget {
  const ProfilePageItemWidget(
      {required this.iconData,
        required this.title,
        required this.onTap,
        this.iconColor,
        Key? key})
      : super(key: key);

  final IconData iconData;
  final Color? iconColor;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(iconData, color: iconColor,),
        title: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}