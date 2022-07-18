import 'package:flutter/material.dart';

class BottomSheetAlertWidget extends StatelessWidget {
  const BottomSheetAlertWidget(
      {required this.message, this.height = 0, Key? key})
      : super(key: key);

  final String message;
  final double height;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxHeight = screenHeight * 0.3;
    double appBarHeight = AppBar().preferredSize.height;

    double bottomSheetHeight =
        (height < appBarHeight || height == 0)
            ? appBarHeight
            : height;
    return BottomSheet(
      builder: (context) {
        return Container(
          height: bottomSheetHeight,
          padding: EdgeInsets.all(bottomSheetHeight * 0.1),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Theme.of(context).errorColor),
          child: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: (bottomSheetHeight == appBarHeight ) ? 1 : 2 ,
          ),
        );
      },
      constraints: BoxConstraints(maxHeight: maxHeight),
      onClosing: () {},
    );
  }
}
