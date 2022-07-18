import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class UserTextFieldWidget extends StatelessWidget {
  UserTextFieldWidget(
      {required this.hintText,
      required this.iconData,
      this.width,
      this.height,
      this.isSecure = false,
      this.keyboardType,
      this.textInputAction,
      this.maxLines,
      this.minLines,
      this.maxLength,
      this.controller,
      this.validator,
      this.onSaved,
      Key? key})
      : super(key: key);

  final double? width;
  final double? height;
  final String hintText;
  final IconData iconData;
  final bool isSecure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  final TextEditingController? controller;
  String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      width: (width == null) ? double.infinity : width,
      // height: (height == null) ? AppBar().preferredSize.height : height,
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconData,
            size: 28,
          ),
          // suffixIcon: (isSecure)
          //     ? IconButton(
          //         onPressed: () {}, icon: const Icon(CupertinoIcons.eye))
          //     : IconButton(
          //         onPressed: () {}, icon: const Icon(CupertinoIcons.eye_slash)),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: 'BYekan',
            fontWeight: FontWeight.bold,
          ),
        ),
        autofocus: false,
        obscureText: isSecure,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        cursorColor: Theme.of(context).primaryColor,
        controller: controller,
      ),
    );
  }
}
