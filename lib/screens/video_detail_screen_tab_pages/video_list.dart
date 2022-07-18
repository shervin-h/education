import 'package:education/services/education_api.dart';
import 'package:flutter/material.dart';
import 'package:education/models/video.dart';
import 'package:education/screens/video_detail_screen.dart';
import 'package:education/widgets/video_item_widget.dart';

class VideoList extends StatelessWidget {
  const VideoList({
    required this.videos,
    Key? key
  }) : super(key: key);

  final List<Video> videos;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width / 3.5 ;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: videos.length,
        itemBuilder: (context, index) {

          // String description = videos[index].description!;
          // int descriptionLength =  description.length;

          return InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return VideoDetailScreen(videoId: videos[index].id,);
                  },
                ),
              );
            },
            child: VideoItem(
              video: videos[index],
            ),
          );
        },
      ),
    );
  }
}