import 'dart:math';
import 'package:flutter/material.dart';

Color randomColorGenerator({double opacity = 1}){
  List<Color> colors = [
    Colors.red,
    Colors.redAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlueAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purple,
    Colors.purpleAccent,
  ];

  Random random = Random();
  int randomInt = random.nextInt(colors.length - 1);
  return colors[randomInt].withOpacity(opacity);
}



Widget _alertBottomSheet(String text) {
  return BottomSheet(
    onClosing: () {
      // Future.delayed(const Duration(seconds: 1),);
    },
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.redAccent,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
  );
}

SnackBar _alertSnackBar(BuildContext context, String text) {
  return SnackBar(
    backgroundColor: Colors.redAccent,
    elevation: 8,
    duration: const Duration(seconds: 3),
    content: Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.redAccent,
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(height: 1.5, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
