class Slide {
  Slide(this.id, this.title, this.banner, this.kind,
      {this.description, this.kindId, this.tag});

  int id;
  String title;
  String banner;
  String kind;
  String? description;
  int? kindId;
  bool? tag;
}
