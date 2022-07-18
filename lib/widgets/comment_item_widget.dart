import 'package:education/ui/theme.dart';
import 'package:education/models/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:education/models/video.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({required this.comment, Key? key}) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'شروین ۱۴ اسفند ساعت ۶:۳۰',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          Text(
            comment.text,
            style:
                Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.4),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.hand_thumbsup, size: screenWidth * 0.05,),
              SizedBox(width: screenWidth * 0.04),
              Text(comment.like.toString()),
              SizedBox(width: screenWidth * 0.1),
              Icon(CupertinoIcons.hand_thumbsdown, size: screenWidth * 0.05,),
              SizedBox(width: screenWidth * 0.04),
              Text(comment.dislike.toString()),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
            child: const Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}


