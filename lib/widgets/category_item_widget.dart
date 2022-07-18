import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education/helpers/helper_functions.dart';
import 'package:education/helpers/constants.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.title,
    required this.image,
    Key? key
  }) : super(key: key);

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/placeholder_video.png',
              placeholderFit: BoxFit.scaleDown,
              image: image,
              fit: BoxFit.cover,
              height: 200,
              imageErrorBuilder: (context, error, stackTrace) {
                return Icon(
                  CupertinoIcons.tv,
                  color: Colors.grey[700],
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent,
                  randomColorGenerator(opacity: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(4)
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6!
                .copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }


}
