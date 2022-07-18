import 'dart:convert';
import 'dart:io';

import 'package:education/helpers/preferences.dart';
import 'package:education/models/comment.dart';
import 'package:education/models/news.dart';
import 'package:education/models/user.dart';
import 'package:education/providers/user_data.dart';
import 'package:education/providers/videos_data.dart';
import 'package:education/services/networking.dart';
import 'package:education/models/slide.dart';
import 'package:education/models/video.dart';
import 'package:education/models/category.dart';
import 'package:education/models/teacher.dart';
import 'package:education/models/source.dart';
import 'package:education/models/course.dart';
import 'package:flutter/material.dart';
import 'package:education/screens/my_home_page_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EducationApi {
  EducationApi();

  static const String host = 'http://192.168.1.103:8000';

  static Future<Map<String, dynamic>> getHomePageData(
      {required BuildContext context}) async {
    Map<String, dynamic> data;
    List<Video> videos = await EducationApi.getVideoList();
    List<Slide> slides = await EducationApi.getSlideList();
    List<Category> categories = await EducationApi.getCategoryList();
    List<News> newsList = await EducationApi.getNewsList();

    List<Video> mostVisitedVideos = videos;
    mostVisitedVideos.sort((a, b) => a.visit.compareTo(b.visit));
    mostVisitedVideos = mostVisitedVideos.reversed.toList();

    List<Video> taggedVideos = [];
    videos.forEach((video) {
      bool isTagged = video.tag ?? false;
      if (isTagged) {
        taggedVideos.add(video);
      }
    });

    data = {
      'slideList': slides,
      'videoList': videos,
      'mostVisitedVideos': mostVisitedVideos,
      'taggedVideos': taggedVideos,
      'categoryList': categories,
      'news': newsList,
    };

    return data;

    // Navigator.of(context).pushReplacementNamed(
    //   MyHomePageScreen.routeName,
    //   arguments: data
    // );
  }

  static Future<List<Video>> getVideoList() async {
    NetworkHelper networkHelper = NetworkHelper('$host/training/video/list/');
    try {
      List listOfJsonObjectVideos = await networkHelper.getData();
      List<Video> videos = [];
      for (var item in listOfJsonObjectVideos) {
        Video video = Video(
            item['id'], item['title'], item['cover'], item['visit'],
            tag: item['tag']);
        videos.add(video);
      }
      return videos;
    } catch (e) {
      throw '😦';
    }
  }

  static Future<List<Slide>> getSlideList() async {
    NetworkHelper networkHelper = NetworkHelper('$host/training/slide/list/');
    try {
      List<Slide> slides = [];
      List listOfJsonObjectSlides = await networkHelper.getData();
      for (var item in listOfJsonObjectSlides) {
        Slide slide = Slide(item['id'], item['title'], item['banner'], item['kind'], description: item['description'], kindId: item['kind_id'], tag: item['tag']);
        slides.add(slide);
      }
      return slides;
    } catch (e) {
      throw '😦';
    }
  }

  static Future<List<Category>> getCategoryList() async {
    NetworkHelper networkHelper =
        NetworkHelper('$host/training/category/list/');
    try {
      List<Category> categories = [];
      List listOfJsonObjectCategories = await networkHelper.getData();
      for (var item in listOfJsonObjectCategories) {
        Category category = Category(
            id: item['id'], title: item['title'], image: item['image'], parent: item['parent']);

        categories.add(category);
      }
      return categories;
    } catch (e) {
      throw '😦';
    }
  }

  static Future<Video> getVideoDetailObject({required int id}) async {
    NetworkHelper networkHelper =
        NetworkHelper('$host/training/video/detail/$id/');
    try {
      var videoDetailAsJsonObject = await networkHelper.getData();

      int id = videoDetailAsJsonObject['id'];
      String title = videoDetailAsJsonObject['title'];
      String? description = videoDetailAsJsonObject['description'];
      String? url = videoDetailAsJsonObject['url'];

      Category? category;
      if (videoDetailAsJsonObject['category'] != null) {
        category = Category(
          id: videoDetailAsJsonObject['category']['id'],
          title: videoDetailAsJsonObject['category']['title'],
          image: videoDetailAsJsonObject['category']['image'],
        );
      }

      Teacher? teacher;
      if (videoDetailAsJsonObject['teacher'] != null) {
        teacher = Teacher(
          videoDetailAsJsonObject['teacher']['id'],
          videoDetailAsJsonObject['teacher']['user']['id'],
          videoDetailAsJsonObject['teacher']['user']['first_name'],
          videoDetailAsJsonObject['teacher']['user']['last_name'],
          avatar: videoDetailAsJsonObject['teacher']['user']['avatar'],
          about: videoDetailAsJsonObject['teacher']['user']['about'],
          website: videoDetailAsJsonObject['teacher']['user']['website'],
        );
      }

      Source? source;
      if (videoDetailAsJsonObject['source'] != null) {
        source = Source(
          videoDetailAsJsonObject['source']['id'],
          videoDetailAsJsonObject['source']['address'],
          videoDetailAsJsonObject['source']['name'],
          image: videoDetailAsJsonObject['source']['image'],
        );
      }

      Course? course;
      if (videoDetailAsJsonObject['course'] != null) {
        course = Course(
          id: videoDetailAsJsonObject['course']['id'],
          title: videoDetailAsJsonObject['course']['title'],
          image: videoDetailAsJsonObject['course']['image'],
        );
      }

      String cover = videoDetailAsJsonObject['cover'];
      String? banner = videoDetailAsJsonObject['banner'];
      String? wallpaper = videoDetailAsJsonObject['wallpaper'];
      int? length = videoDetailAsJsonObject['length'];
      int visit = videoDetailAsJsonObject['visit'];
      double? rate = videoDetailAsJsonObject['rate'];
      int like = videoDetailAsJsonObject['like'] ?? 0;
      int dislike = videoDetailAsJsonObject['dislike'] ?? 0;
      bool? tag = videoDetailAsJsonObject['tag'];

      return Video(
        id,
        title,
        cover,
        visit,
        description: description,
        url: url,
        category: category,
        teacher: teacher,
        source: source,
        course: course,
        banner: banner,
        wallpaper: wallpaper,
        length: length,
        rate: rate,
        like: like,
        dislike: dislike,
        tag: tag,
      );
    } catch (e) {
      throw '😦 ${e.toString()}';
    }
  }

  static Future<List<Video>> getCategoryVideos(
      {required int categoryId}) async {
    NetworkHelper networkHelper =
        NetworkHelper('$host/training/category/$categoryId/videos/');
    try {
      List<Video> videos = [];
      List listOfJsonObjectVideos = await networkHelper.getData();

      for (var item in listOfJsonObjectVideos) {
        Video video = Video(item['id'], item['title'], item['cover'], item['visit'], tag: item['tag']);
        videos.add(video);
      }
      return videos;
    } catch (e) {
      throw '😦';
    }
  }
  
  static Future<List<Video>> getSourceVideos({required int sourceId}) async {
    NetworkHelper networkHelper = NetworkHelper('$host/training/source/$sourceId/videos/');
    try {
      List<Video> videos = [];
      List listOfJsonObjectVideos = await networkHelper.getData();

      for (var item in listOfJsonObjectVideos) {
        Video video = Video(item['id'], item['title'], item['cover'], item['visit'], tag: item['tag']);
        videos.add(video);
      }
      return videos;
    } catch (e) {
      throw '😦';
    }
  }

  static Future<List<Video>> getCourseVideos({required int courseId}) async {
    NetworkHelper networkHelper = NetworkHelper('$host/training/course/$courseId/videos/');
    try {
      List<Video> videos = [];
      List listOfJsonObjectVideos = await networkHelper.getData();

      for (var item in listOfJsonObjectVideos) {
        Video video = Video(item['id'], item['title'], item['cover'], item['visit'], tag: item['tag']);
        videos.add(video);
      }
      return videos;
    } catch (e) {
      throw '😦';
    }
  }

  static Future<List<Video>> getCourseRelatedVideosList(
      {required int? courseId}) async {
    NetworkHelper networkHelper =
        NetworkHelper('$host/training/course/$courseId/videos/');
    try {
      List<Video> videos = [];
      List listOfJsonObjectVideos = await networkHelper.getData();

      if (listOfJsonObjectVideos.isEmpty) {
        return videos;
      }

      for (var item in listOfJsonObjectVideos) {
        Video video =
            Video(item['id'], item['title'], item['cover'], item['visit']);
        videos.add(video);
      }

      return videos;
    } catch (e) {
      throw '😦';
    }
  }

  static Future<List<Video>> getSearchedVideoList(
      {required String phrase}) async {
    NetworkHelper networkHelper =
        NetworkHelper('$host/training/search/$phrase/videos/');
    try {
      List listOfJsonObjectVideos = await networkHelper.getData();
      List<Video> videos = [];
      for (var item in listOfJsonObjectVideos) {
        Video video = Video(
          item['id'],
          item['title'],
          item['cover'],
          item['visit'],
          rate: item['rate'],
          description: item['description'],
          category: Category(
            id: item['category']['id'],
            title: item['category']['title'],
            image: item['category']['image'],
          ),
          teacher: Teacher(
            item['teacher']['id'],
            item['teacher']['user']['id'],
            item['teacher']['user']['first_name'],
            item['teacher']['user']['last_name'],
            avatar: item['teacher']['user']['avatar'],
          ),
        );

        videos.add(video);
      }
      return videos;
    } catch (e) {
      throw '😦';
    }
  }

  static Future<List<Comment>> getVideoComments({required int videoId}) async {
    NetworkHelper networkHelper =
        NetworkHelper('$host/training/video/comments/$videoId/');
    try {
      List listOfJsonObjectComments = await networkHelper.getData();
      List<Comment> comments = [];
      for (var item in listOfJsonObjectComments) {
        Comment comment = Comment(
          item['id'],
          item['text'],
          like: item['like'],
          dislike: item['dislike'],
        );
        comments.add(comment);
      }
      return comments;
    } catch (e) {
      throw '😦';
    }
  }

  static Future<String?> postRegisterUser(Map<String, String> userObj) async {
    NetworkHelper networkHelper =
        NetworkHelper('$host/api/rest-auth/registration/');
    try {
      var userKeyAsJsonObject = await networkHelper.postData(userObj);

      if (userKeyAsJsonObject != 'Bad Request') {
        return userKeyAsJsonObject['key'];
      } else {
        return null;
      }
    } catch (e) {
      throw '😦';
    }
  }

  static Future<String?> postLoginUser(Map<String, dynamic> userObj) async {
    NetworkHelper networkHelper = NetworkHelper('$host/api/rest-auth/login/');
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      var userKeyAsJsonObject = await networkHelper.postData(jsonEncode(userObj), headers: headers);

      if (userKeyAsJsonObject != 'Bad Request') {
        return userKeyAsJsonObject['key'];
      } else {
        return null;
      }
    } catch (e) {
      throw '😦';
    }
  }

  static Future<Video?> patchVideoDetail(
      int videoId, String userKey, Map<String, dynamic> data) async {
    NetworkHelper networkHelper =
        NetworkHelper('$host/training/update/video/$videoId/');
    try {
      var videoUpdatedDetailAsJsonObject = await networkHelper.patchData({
        'Content-Type': 'application/json',
        'Authorization': 'Token $userKey'
      }, data);
      if (videoUpdatedDetailAsJsonObject != 'Bad Request or Unauthorized') {
        int id = videoUpdatedDetailAsJsonObject['id'];
        String title = videoUpdatedDetailAsJsonObject['title'];
        String? description = videoUpdatedDetailAsJsonObject['description'];
        String? url = videoUpdatedDetailAsJsonObject['url'];

        Category? category = Category(
          id: videoUpdatedDetailAsJsonObject['category']['id'],
          title: videoUpdatedDetailAsJsonObject['category']['title'],
          image: videoUpdatedDetailAsJsonObject['category']['image'],
        );

        Teacher? teacher = Teacher(
          videoUpdatedDetailAsJsonObject['teacher']['id'],
          videoUpdatedDetailAsJsonObject['teacher']['user']['id'],
          videoUpdatedDetailAsJsonObject['teacher']['user']['first_name'],
          videoUpdatedDetailAsJsonObject['teacher']['user']['last_name'],
          avatar: videoUpdatedDetailAsJsonObject['teacher']['user']['avatar'],
          about: videoUpdatedDetailAsJsonObject['teacher']['user']['about'],
          website: videoUpdatedDetailAsJsonObject['teacher']['user']['website'],
        );

        Source? source = Source(
          videoUpdatedDetailAsJsonObject['source']['id'],
          videoUpdatedDetailAsJsonObject['source']['address'],
          videoUpdatedDetailAsJsonObject['source']['name'],
          image: videoUpdatedDetailAsJsonObject['source']['image'],
        );

        Course? course;
        if (videoUpdatedDetailAsJsonObject['course'] != null) {
          course = Course(
            id: videoUpdatedDetailAsJsonObject['course']['id'],
            title: videoUpdatedDetailAsJsonObject['course']['title'],
            image: videoUpdatedDetailAsJsonObject['course']['image'],
          );
        }

        String cover = videoUpdatedDetailAsJsonObject['cover'];
        String? banner = videoUpdatedDetailAsJsonObject['banner'];
        String? wallpaper = videoUpdatedDetailAsJsonObject['wallpaper'];
        int? length = videoUpdatedDetailAsJsonObject['length'];
        int visit = videoUpdatedDetailAsJsonObject['visit'];
        double? rate = videoUpdatedDetailAsJsonObject['rate'];
        bool? tag = videoUpdatedDetailAsJsonObject['tag'];

        return Video(
          id,
          title,
          cover,
          visit,
          description: description,
          url: url,
          category: category,
          teacher: teacher,
          source: source,
          course: course,
          banner: banner,
          wallpaper: wallpaper,
          length: length,
          rate: rate,
          tag: tag,
        );
      } else {
        return null;
      }
    } catch (e) {
      throw '😦' + e.toString();
    }
  }

  static Future<int> patchLikingVideo(
      String userKey, Map<String, dynamic> data) async {
    NetworkHelper networkHelper = NetworkHelper('$host/training/video/liking/');
    try {
      var likingStateAsJsonObject = await networkHelper.patchData({
        "Content-Type": "application/json",
        "Authorization": "Token $userKey"
      }, data);
      if (likingStateAsJsonObject != 'Bad Request or Unauthorized') {
        // return likingStateAsJsonObject['like_state'];
        return 0;
      } else {
        return -1;
      }
    } catch (e) {
      throw '😦' + e.toString();
    }
  }

  static Future<String?> postCreateLikingVideo(
      Map<String, dynamic> jsonObj) async {
    NetworkHelper networkHelper = NetworkHelper('$host/training/video/liking/');
    try {
      User? user = await EducationPreferences.getUserPreferences(); // 1
      // User? user = Provider.of<UserData>(context).user;             // or 2
      if (user != null) {
        String userKey = user.key.trim();

        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Authorization": "Token $userKey"
        };

        var userLikingCreationStatusAsJsonObject =
            await networkHelper.postData(jsonEncode(jsonObj), headers: headers);
        if (userLikingCreationStatusAsJsonObject != 'Bad Request') {
          return userLikingCreationStatusAsJsonObject['msg'];
        }
      }
      return null;
    } catch (e) {
      throw '😦';
    }
  }

  static Future<List<News>> getNewsList() async {
    NetworkHelper networkHelper = NetworkHelper('$host/training/news/list/');
    try {
      List listOfJsonObjectNews = await networkHelper.getData();
      List<News> newsList = [];
      for (var item in listOfJsonObjectNews) {
        News news = News(
          item['id'],
          item['title'],
          item['content'] ?? '',
          item['image'],
          item['author'],
          item['publish_at'],
        );

        newsList.add(news);
      }
      return newsList;
    } catch (e) {
      throw '😦';
    }
  }

  static Future<News> getNewsDetail(int newsId) async {
    NetworkHelper networkHelper =
        NetworkHelper('$host/training/news/detail/$newsId/');
    try {
      Map<String, dynamic> newsDetailAsJsonObject =
          await networkHelper.getData();
      return News(
        newsDetailAsJsonObject['id'],
        newsDetailAsJsonObject['title'],
        newsDetailAsJsonObject['content'],
        newsDetailAsJsonObject['image'],
        newsDetailAsJsonObject['author'],
        newsDetailAsJsonObject['publish_at'],
        source: newsDetailAsJsonObject.containsKey('source')
            ? Source(
                newsDetailAsJsonObject['source']['id'],
                newsDetailAsJsonObject['source']['address'],
                newsDetailAsJsonObject['source']['name'],
                image: newsDetailAsJsonObject['source']['image'])
            : null,
      );
    } catch (e) {
      throw '😦';
    }
  }
}
