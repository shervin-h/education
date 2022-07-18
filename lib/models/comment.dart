import 'package:education/models/user.dart';
import 'package:education/models/video.dart';

class Comment {
  Comment(
    this.id,
    this.text,

    {
    this.like = 0,
    this.dislike = 0,
    this.user,
    this.comments,
    this.video,}
  );

  int id;
  String text;
  int like = 0;
  int dislike = 0;
  User? user;
  List<Comment>? comments;
  Video? video;
}
