import 'package:education/models/video.dart';
import 'package:flutter/material.dart';
import '../../widgets/horizontal_list_video_cards_widget.dart';
import 'package:education/helpers/helper_enums.dart';

class RelatedVideosTabPage extends StatelessWidget {
  const RelatedVideosTabPage({required this.relatedVideos, Key? key})
      : super(key: key);

  final List<Video> relatedVideos;

  @override
  Widget build(BuildContext context) {
    return (relatedVideos.isNotEmpty)
        ? HorizontalListVideoCards(
            topic: 'سایر قسمت های این دوره آموزشی',
            videos: relatedVideos,
            type: ListType.none,
          )
        : const SizedBox();
  }
}
