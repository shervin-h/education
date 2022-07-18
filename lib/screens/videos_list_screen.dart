import 'package:education/helpers/helper_enums.dart';
import 'package:education/models/video.dart';
import 'package:education/providers/videos_data.dart';
import 'package:education/screens/video_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:education/widgets/video_grid_item_widget.dart';
import 'package:education/services/education_api.dart';
import 'package:provider/provider.dart';

class Videos extends StatelessWidget {
  static const String routeName = 'VideosScreen';

  const Videos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type =
        ModalRoute.of(context)!.settings.arguments as ListType;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Consumer<VideosData>(
            builder: (context, videosData, child) {
              List<Video> videosList = [];
              int count = 0;
              switch(type) {
                case ListType.newest: {
                  videosList = videosData.videos;
                  count = videosData.videosCount;
                }
                break;

                case ListType.mostVisited: {
                  videosList = videosData.mostVisitedVideos;
                  count = videosData.mostVisitedVideosCount;
                }
                break;

                case ListType.tagged: {
                  videosList = videosData.taggedVideos;
                  count = videosData.taggedVideosCount;
                }
                break;

                case ListType.bySource: {
                  videosList = videosData.sourceVideos;
                  count = videosData.sourceVideosCount;
                }
                break;

                case ListType.byCourse: {
                  videosList = videosData.courseVideos;
                  count = videosData.courseVideosCount;
                }
                break;

                default: {
                  //statements;
                }
                break;
              }
              return GridView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.3 / 3),
                itemCount: count,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VideoDetailScreen(videoId:videosList[index].id),
                        ),
                      );
                    },
                    child: VideoGridItemWidget(
                      video: videosList[index],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
