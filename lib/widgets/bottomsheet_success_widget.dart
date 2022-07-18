import 'package:flutter/material.dart';

class BottomSheetSuccessWidget extends StatelessWidget {
  const BottomSheetSuccessWidget(
      {required this.message, this.height = 0, Key? key})
      : super(key: key);

  final String message;
  final double height;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxHeight = screenHeight * 0.3;

    double bottomSheetHeight =
        (height < AppBar().preferredSize.height || height == 0)
            ? AppBar().preferredSize.height
            : height;
    return BottomSheet(
      builder: (context) {
        return Container(
          height: bottomSheetHeight,
          padding: EdgeInsets.all(bottomSheetHeight * 0.1),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
          child: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.green),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      },
      constraints: BoxConstraints(maxHeight: maxHeight),
      onClosing: () {},
    );
  }
}
