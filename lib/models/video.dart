import 'package:education/models/category.dart';
import 'package:education/models/source.dart';
import 'package:education/models/teacher.dart';
import 'package:education/models/course.dart';

class Video {
  Video(
      this.id, this.title, this.cover, this.visit,

      {this.description,
      this.url,
      this.category,
      this.teacher,
      this.source,
      this.course,
      this.banner,
      this.wallpaper,
      this.length,
      this.rate,
      this.like = 0,
      this.dislike = 0,
      this.tag});

  int id;
  String title;
  String? description;
  String? url;
  Category? category;
  Teacher? teacher;
  Source? source;
  Course? course;
  String cover;
  String? banner;
  String? wallpaper;
  int? length;
  int visit;
  double? rate;
  int like = 0;
  int dislike = 0;
  bool? tag;
}