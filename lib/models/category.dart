class Category {
  Category({required this.id, required this.title, required this.image, this.parent});

  int id;
  String title;
  String image;
  int? parent;
}