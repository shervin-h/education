import 'package:education/models/video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoGridItemWidget extends StatelessWidget {
  const VideoGridItemWidget({required this.video, Key? key}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: NetworkImage(
                video.cover,
              ),
              fit: BoxFit.cover,
            ),
          ),
          /*child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/play_button.png',
              placeholderFit: BoxFit.scaleDown,
              image: video.cover,
              fit: BoxFit.cover,
              // height: cardHeight,
            ),
            // child: Image.network(videos[index].cover, fit: BoxFit.cover, width: 100, height: 120,),
          ),*/
        ),
        Container(
          padding: const EdgeInsets.all(4),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Theme.of(context).backgroundColor.withOpacity(0.90),
                Theme.of(context).backgroundColor.withOpacity(0.65),
                // Colors.transparent,
                Colors.transparent,
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                video.title,
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    CupertinoIcons.eye_fill,
                    size: 15,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  Text(
                    video.visit.toString(),
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
