import 'package:education/helpers/db_helper.dart';
import 'package:education/models/news.dart';
import 'package:flutter/material.dart';
import 'package:education/models/category.dart';
import 'package:education/models/slide.dart';
import 'package:education/models/video.dart';

class VideosData extends ChangeNotifier {
  List<Video> _videos = [];
  List<Video> _mostVisitedVideos = [];
  List<Video> _taggedVideos = [];
  List<News>  _news = [];
  List<Video> _searchedVideos = [];
  List<Video> _categorizedVideos = [];
  List<Video> _sourceVideos = [];
  List<Video> _courseVideos = [];
  List<Slide> _slides = [];
  List<Category> _categories = [];
  List<Video> _bookmarkedVideos = [];
  List<Video> _consideredVideos = [];

  List<Video> get videos {
    return [..._videos];
  }

  List<Video> get mostVisitedVideos {
    return [..._mostVisitedVideos];
  }

  List<Video> get taggedVideos {
    return [..._taggedVideos];
  }

  List<News> get news {
    return [..._news];
  }

  List<Video> get searchedVideos {
    return [..._searchedVideos];
  }

  List<Video> get categorizedVideos {
    return [..._categorizedVideos];
  }

  List<Video> get sourceVideos {
    return [..._sourceVideos];
  }

  List<Video> get courseVideos {
    return [..._courseVideos];
  }

  List<Slide> get slides {
    return [..._slides];
  }

  List<Category> get categories {
    return [..._categories];
  }

  List<Video> get bookmarkedVideos {
    return [..._bookmarkedVideos];
  }

  List<Video> get consideredVideos {
    return [..._consideredVideos];
  }

  int get videosCount {
    return _videos.length;
  }

  int get mostVisitedVideosCount {
    return _mostVisitedVideos.length;
  }

  int get taggedVideosCount {
    return _taggedVideos.length;
  }

  int get newsCount {
    return _news.length;
  }

  int get slidesCount {
    return _slides.length;
  }

  int get categoriesCount {
    return _categories.length;
  }

  int get categorizedVideosCount {
    return _categorizedVideos.length;
  }

  int get sourceVideosCount {
    return _sourceVideos.length;
  }

  int get courseVideosCount {
    return _courseVideos.length;
  }

  int get bookmarkedVideosCount {
    return _bookmarkedVideos.length;
  }

  int get consideredVideosCount {
    return _consideredVideos.length;
  }

  // Video section
  void addVideo(Video video) {
    _videos.add(video);
    notifyListeners();
  }

  void addAllVideos(List<Video> videoList) {
    _videos.addAll(videoList);
    notifyListeners();
  }

  // // Most visited videos section
  void addMostVisitedVideos(Video video) {
    _mostVisitedVideos.add(video);
    notifyListeners();
  }

  void addAllMostVisitedVideos(List<Video> videoList) {
    _mostVisitedVideos.addAll(videoList);
    notifyListeners();
  }

  // // Tagged videos section
  void addAllTaggedVideos(List<Video> videoList) {
    _taggedVideos.addAll(videoList);
    notifyListeners();
  }

  // // News section
  void addAllNews(List<News> newsList) {
    _news.addAll(newsList);
    notifyListeners();
  }

  // // Bookmarked section
  void addBookmarkedVideo(Video video) {
    _bookmarkedVideos.add(video);
    notifyListeners();
  }

  // // Considered section
  void addConsideredVideo(Video video) {
    _consideredVideos.add(video);
    notifyListeners();
  }

  // Categorized videos section
  void addAllCategorizedVideos(List<Video> videoList) {
    _categorizedVideos.clear();
    _categorizedVideos.addAll(videoList);
    notifyListeners();
  }

  // Source videos section
  void addAllSourceVideos(List<Video> videoList) {
    _sourceVideos.clear();
    _sourceVideos.addAll(videoList);
    notifyListeners();
  }

  // Course videos section
  void addAllCourseVideos(List<Video> videoList) {
    _courseVideos.clear();
    _courseVideos.addAll(videoList);
    notifyListeners();
  }

  // Slide section
  void addSlide(Slide slide) {
    _slides.add(slide);
    notifyListeners();
  }

  void addAllSlides(List<Slide> slideList) {
    _slides.addAll(slideList);
    notifyListeners();
  }

  // Category section
  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void addAllCategory(List<Category> categoryList) {
    _categories.addAll(categoryList);
    notifyListeners();
  }

  // Search section
  void addAllSearchedVideos(List<Video> videoList) {
    _searchedVideos.addAll(videoList);
    notifyListeners();
  }

  void clearSearchedVideos() {
    _searchedVideos.clear();
    notifyListeners();
  }

  void removeSearchedItem(int videoId) {
    _searchedVideos.removeWhere((element) => element.id == videoId);
    notifyListeners();
  }

  void removeBookmarkedItem(int videoId) {
    _bookmarkedVideos.removeWhere((element) => element.id == videoId);
    notifyListeners();
  }

  void removeConsideredItem(int videoId) {
    _consideredVideos.removeWhere((element) => element.id == videoId);
    notifyListeners();
  }


  // Bookmarked videos
  Future<void> fetchAndSetBookmarkedVideos() async {
    final List<Map<String, dynamic>> dataList =
        await DBHelper.getData('bookmarked_videos');
    _bookmarkedVideos = dataList
        .map((row) => Video(
              row['video_id'],
              row['title'],
              row['cover'],
              row['visit'],
              url: row['url'],
              description: row['description'],
              banner: row['banner'],
              wallpaper: row['wallpaper'],
            ))
        .toList();

    notifyListeners();
  }

  // Considered videos
  Future<void> fetchAndSetConsideredVideos() async {
    final List<Map<String, dynamic>> dataList =
        await DBHelper.getData('considered_videos');
    _consideredVideos = dataList
        .map((row) => Video(
              row['video_id'],
              row['title'],
              row['cover'],
              row['visit'],
              url: row['url'],
              description: row['description'],
              banner: row['banner'],
              wallpaper: row['wallpaper'],
              rate: row['rating'],
            ))
        .toList();

    notifyListeners();
  }


  // Download section
  bool _isDownloading = false;
  String _progress = '0';

  bool get isDownloading {
    return _isDownloading;
  }

  String get progress {
    return _progress;
  }

  void setProgress(String progress){
    _progress = progress;
    notifyListeners();
  }

  void setIsDownloadingTrue() {
    _isDownloading = true;
    notifyListeners();
  }

  void setIsDownloadingFalse() {
    _isDownloading = false;
    notifyListeners();
  }
}
