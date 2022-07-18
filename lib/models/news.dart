import 'package:education/models/source.dart';

class News {
  News(this.id, this.title, this.content, this.image, this.author,
      this.publishAt,
      {this.source});

  int id;
  String title;
  String content;
  String image;
  String author;
  Source? source;
  String publishAt;
}
