import 'package:education/providers/theme_info.dart';
import 'package:education/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class SearchBar extends StatelessWidget {
  SearchBar(
      {required this.isWriting,
      required this.controller,
      required this.onSubmitted,
      Key? key})
      : super(key: key);

  final bool isWriting;
  final TextEditingController controller;
  void Function(String)? onSubmitted;

  final double appBarHeight = AppBar().preferredSize.height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      // padding: EdgeInsets.symmetric(horizontal: appBarHeight * 0.1),
      width: double.infinity,
      height: appBarHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF757575).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: (isWriting)
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    CupertinoIcons.xmark_circle,
                    size: appBarHeight * 0.4,
                    color: Colors.grey[500],
                  ),
                )
              : Container(
                  width: appBarHeight * 0.9,
                  alignment: Alignment.center,
                  child: Text(
                    'Edu',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Provider.of<ThemeInfo>(context).isDark ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
          suffixIcon: IconButton(
            onPressed: () {
              onSubmitted!('');
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(
              CupertinoIcons.search,
              size: appBarHeight * 0.4,
              color: Colors.white,
            ),
          ),
          fillColor: Colors.transparent,
          hintText: 'عنوان ، توضیح ، دسته‌بندی ، مدرس ، منبع',
          hintStyle: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.grey[500]),
        ),
        autofocus: false,
        cursorColor: Provider.of<ThemeInfo>(context).isDark ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
        controller: controller,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
