import 'package:education/services/education_api.dart';
import 'package:flutter/material.dart';
import 'package:education/models/comment.dart';
import 'package:education/screens/video_detail_screen.dart';
import 'package:education/widgets/comment_item_widget.dart';

class CommentList extends StatelessWidget {
  const CommentList({
    required this.comments,
    Key? key
  }) : super(key: key);

  final List<Comment> comments;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return CommentItem(
            comment: comments[index],
          );
        },
      ),
    );
  }
}