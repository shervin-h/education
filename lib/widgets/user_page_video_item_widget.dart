import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education/models/video.dart';

class VideoItem extends StatelessWidget {
  const VideoItem({
    required this.video,
    required this.onDismissed,
    Key? key
  }) : super(key: key);

  final Video video;
  final Function(DismissDirection)? onDismissed;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Dismissible(
      key: ValueKey(video.id),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            CupertinoIcons.delete,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: ListTile(
          title: Text(
            video.title,
            style: Theme.of(context).textTheme.subtitle1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            video.description!,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Colors.grey[500]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/placeholder_video.png',
              placeholderFit: BoxFit.scaleDown,
              image: video.cover,
              fit: BoxFit.cover,
              width: screenWidth * 0.16,
            ),
            // child: Image.network(videos[index].cover, fit: BoxFit.cover, width: 100, height: 120,),
          ),
        ),
      ),
    );
  }
}
