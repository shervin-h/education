import 'package:education/services/education_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education/models/video.dart';
import 'package:education/screens/video_detail_screen.dart';
import 'package:education/ui/theme.dart';
import 'package:education/screens/videos_list_screen.dart';
import 'package:education/helpers/helper_enums.dart';

class HorizontalListVideoCards extends StatelessWidget {
  const HorizontalListVideoCards(
      {required this.topic, required this.videos, required this.type, Key? key})
      : super(key: key);

  final String topic;
  final List<Video> videos;
  final ListType type;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    double radius = 6;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '  $topic  ',
                  style: Theme.of(context).textTheme.headline6,
                ),
                IconButton(
                  onPressed: (){
                    Navigator.of(context).pushNamed(Videos.routeName, arguments: type);
                  },
                  highlightColor: Colors.transparent,
                  padding: const EdgeInsets.all(4),
                  iconSize: screenWidth * 0.06,
                  icon: const Icon(CupertinoIcons.chevron_back),
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth,
            height: screenWidth * 0.6,
            alignment: Alignment.center,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return VideoDetailScreen(
                            videoId: videos[index].id,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: radius),
                    width: screenWidth * 0.32,
                    height: screenWidth * 0.58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // color: materialGrey,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/placeholder_video.png',
                              placeholderFit: BoxFit.scaleDown,
                              image: videos[index].cover,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  CupertinoIcons.tv,
                                  color: Colors.grey[700],
                                );
                              },
                            ),
                            /*child: Image.network(
                              videos[index].cover,
                              fit: BoxFit.cover,
                              // width: 100,
                              // height: 120,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  CupertinoIcons.tv,
                                  color: Colors.grey[700],
                                );
                              },
                            ),*/
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                videos[index].title,
                                style: Theme.of(context).textTheme.caption!
                                    .copyWith(textBaseline: TextBaseline.ideographic),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    CupertinoIcons.eye,
                                    size: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    videos[index].visit.toString(),
                                    style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
