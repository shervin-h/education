import 'package:education/helpers/db_helper.dart';
import 'package:education/providers/videos_data.dart';
import 'package:education/widgets/user_page_video_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:education/screens/video_detail_screen.dart';
import 'package:education/helpers/helper_enums.dart';
import 'package:education/models/video.dart';

class Videos extends StatelessWidget {
  const Videos({Key? key}) : super(key: key);

  static const String routeName = 'UserVideosScreen';

  Future<void> _dismissVideo(ListType type, VideosData videosData,int videoId) async {
   if (type == ListType.bookmarked) {
     await DBHelper.deleteBookmarkedVideo(videoId);
     videosData.removeBookmarkedItem(videoId);
   } else if (type == ListType.considered) {
     await DBHelper.deleteConsideredVideo(videoId);
     videosData.removeConsideredItem(videoId);
   }
  }

  @override
  Widget build(BuildContext context) {
    final type = ModalRoute.of(context)!.settings.arguments as ListType;

    return Scaffold(
      body: SafeArea(
        child: Consumer<VideosData>(
          builder: (context, videosData, child) {
            List<Video> videosList = [];
            int count = 0;

            switch (type) {
              case ListType.bookmarked:
                {
                  videosList = videosData.bookmarkedVideos;
                  count = videosData.bookmarkedVideosCount;
                }
                break;

              case ListType.considered:
                {
                  videosList = videosData.consideredVideos;
                  count = videosData.consideredVideosCount;
                }
                break;

              default:
                {
                  //statements;
                }
                break;
            }

            return (videosList.isEmpty)
                ? Center(
                    child: Text(
                      'در حال حاضر خالیست!',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    // padding: const EdgeInsets.symmetric(horizontal: 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: count,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VideoDetailScreen(
                                  videoId: videosList[index].id),
                            ),
                          );
                        },
                        child: VideoItem(
                          video: videosList[index],
                          onDismissed: (direction) {
                            _dismissVideo(type, videosData, videosList[index].id);
                          }
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
