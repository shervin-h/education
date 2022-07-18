import 'package:education/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:education/models/video.dart';
import 'package:flutter/material.dart';

class VideoItem extends StatelessWidget {
  const VideoItem({required this.video, Key? key}) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double height = screenWidth / 3;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: height * 0.04, vertical: height * 0.2),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder_video.png',
                placeholderFit: BoxFit.scaleDown,
                image: video.cover,
                fit: BoxFit.cover,
                height: height,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder_video.png',
                    fit: BoxFit.scaleDown,
                    height: height,
                  );
                },
              ),
              // child: Image.network(videos[index].cover, fit: BoxFit.cover, width: 100, height: 120,),
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, height * 0.06, 0, height * 0.06),
                  child: (video.length != null)
                      ? Text(
                          '${video.length!.toString()} دقیقه',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey[500]),
                        )
                      : null,
                ),
                /*Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.heart_fill,
                            color: Colors.redAccent,
                            size: screenWidth * 0.054,
                          ),
                          Text(
                            ' 95% ',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              CupertinoIcons.hand_thumbsup,
                              size: screenWidth * 0.054,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              CupertinoIcons.hand_thumbsdown,
                              size: screenWidth * 0.054,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              CupertinoIcons.arrow_down_to_line,
                              size: screenWidth * 0.054,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.fromLTRB(0, height * 0.1, 0, 0),
                  child: Text(
                    'یه سری متن الکی ملکی برای توضیحات ویدیو ...',
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
