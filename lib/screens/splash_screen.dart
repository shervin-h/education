import 'dart:async';

import 'package:education/providers/theme_info.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:education/services/education_api.dart';
import 'package:connectivity/connectivity.dart';
import 'my_home_page_screen.dart';
import 'package:education/helpers/preferences.dart';
import 'package:education/providers/user_data.dart';
import 'package:education/models/user.dart';
import 'package:education/providers/videos_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _subscription;
  bool isConnected = false;

  late EducationApi educationApi;

  @override
  void initState() {
    super.initState();
    _subscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {
          isConnected = true;
        });
      } else {
        setState(() {
          isConnected = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  getData(BuildContext context) {
    EducationPreferences.getUserPreferences().then((User? user) {
      if (user != null){
        Provider.of<UserData>(context, listen: false).setUser(user);
      }

      EducationPreferences.getSettingsPreferences().then((Map<String, dynamic> settings) {
        if (settings.containsKey('is_dark')){
          Provider.of<ThemeInfo>(context, listen: false).setDarkTheme(settings['is_dark']);
        }

        if (settings.containsKey('font_family')){
          Provider.of<ThemeInfo>(context, listen: false).setFontFamily(settings['font_family']);
        }

        Provider.of<VideosData>(context, listen: false).fetchAndSetBookmarkedVideos().then((value) {
          Provider.of<VideosData>(context, listen: false).fetchAndSetConsideredVideos().then((value) {
            EducationApi.getHomePageData(context: context).then((Map<String, dynamic> data) {

              Provider.of<VideosData>(context, listen: false).addAllVideos(data['videoList']);
              Provider.of<VideosData>(context, listen: false).addAllMostVisitedVideos(data['mostVisitedVideos']);
              Provider.of<VideosData>(context, listen: false).addAllTaggedVideos(data['taggedVideos']);
              Provider.of<VideosData>(context, listen: false).addAllSlides(data['slideList']);
              Provider.of<VideosData>(context, listen: false).addAllCategory(data['categoryList']);
              Provider.of<VideosData>(context, listen: false).addAllNews(data['news']);

              FlutterDownloader.initialize().then((value) {
                Navigator.of(context).pushReplacementNamed(
                  MyHomePageScreen.routeName,
                  // arguments: user,
                );
              });

            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isConnected) {
      Future.delayed(
        const Duration(seconds: 1, milliseconds: 500),
        () => getData(context),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Shimmer.fromColors(
                child: Text(
                  'Education',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                baseColor: Colors.transparent,
                highlightColor: Colors.lightBlueAccent,
                period: const Duration(seconds: 2),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'آموزش',
                    style:
                    Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    'نسخه 1.0.0',
                    style:
                    Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
