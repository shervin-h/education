import 'package:flutter/material.dart';
import 'package:education/models/video.dart';
import '../../widgets/horizontal_list_video_cards_widget.dart';
import 'package:education/helpers/helper_enums.dart';

class SimilarVideosTabPage extends StatelessWidget {
  const SimilarVideosTabPage({required this.similarVideos, Key? key})
      : super(key: key);

  final List<Video> similarVideos;

  @override
  Widget build(BuildContext context) {
    return (similarVideos.isNotEmpty)
        ? HorizontalListVideoCards(
            topic: 'ویدیو های مشابه',
            videos: similarVideos,
            type: ListType.none,
          )
        : const SizedBox();
  }
}
