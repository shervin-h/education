import 'package:education/models/video.dart';
import 'package:education/providers/videos_data.dart';
import 'package:education/screens/video_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education/widgets/video_grid_item_widget.dart';
import 'package:education/services/education_api.dart';
import 'package:provider/provider.dart';

class CategorizedVideos extends StatelessWidget {
  static const String routeName = 'CategorizedVideosScreen';

  const CategorizedVideos({Key? key}) : super(key: key);

  Future<List<Video>> fetchAndSetCategorizedVideos(
      BuildContext context, int categoryId) async {

    List<Video> categorizedVideos =
        await EducationApi.getCategoryVideos(categoryId: categoryId);

    Provider.of<VideosData>(context, listen: false)
        .addAllCategorizedVideos(categorizedVideos);

    return categorizedVideos;
  }

  @override
  Widget build(BuildContext context) {
    final categoryId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: FutureBuilder(
            future: fetchAndSetCategorizedVideos(context, categoryId),
            builder: (BuildContext context, AsyncSnapshot<List<Video>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CupertinoActivityIndicator(
                    color: Theme.of(context).primaryColor,
                    radius: 16,
                  ),
                );
              } else {
                // snapshot.connectionState == ConnectionState.done
                if (snapshot.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'اشکالی در گرفتن ویدیوهای این دسته پیش آمد !',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Theme.of(context).errorColor, height: 1.5),
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  List<Video> videos = snapshot.data!;
                  return (videos.isNotEmpty)
                      ? Consumer<VideosData>(
                    builder: (context, videosData, child) {
                      return GridView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 2.3 / 3),
                        itemCount: videosData.categorizedVideosCount,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VideoDetailScreen(
                                      videoId:
                                          videosData.categorizedVideos[index].id),
                                ),
                              );
                            },
                            child: VideoGridItemWidget(
                              video: videosData.categorizedVideos[index],
                            ),
                          );
                        },
                      );
                    },
                  )
                      : Center(
                         child: Text(
                           'در حال حاضر ویدیویی برای این دسته وجود ندارد!',
                           style: Theme.of(context)
                               .textTheme
                               .bodyText2!
                               .copyWith(color: Theme.of(context).errorColor),
                           maxLines: 2,
                           overflow: TextOverflow.ellipsis,
                           textAlign: TextAlign.center,
                         ),
                        );
                } else {
                  return Text(
                    '${snapshot.connectionState}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Theme.of(context).errorColor),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
