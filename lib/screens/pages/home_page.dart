import 'package:education/providers/videos_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:education/models/slide.dart';
import 'package:education/models/video.dart';
import 'package:education/widgets/beautiful_background_design_widget.dart';
import 'package:education/widgets/horizontal_list_video_cards_widget.dart';
import 'package:education/widgets/slider_with_circle_indicator_widget.dart';

import '../../helpers/helper_enums.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                // image: DecorationImage(
                //   image: AssetImage('assets/images/background_01.jpg',),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BeautifulBackgroundDesignWidget(
                      iconData: CupertinoIcons.star,
                      color: Colors.yellowAccent,
                      degree: -20,
                      size: 100,
                      opacity: 0.4,
                      duration: 5000,
                      alignment: Alignment.centerRight,
                      paddingLeft: MediaQuery.of(context).size.width/7,
                      paddingRight: 32,
                    ),
                    BeautifulBackgroundDesignWidget(
                      iconData: Icons.movie,
                      color: Colors.greenAccent,
                      degree: -20,
                      size: 120,
                      opacity: 0.4,
                      duration: 5000,
                      alignment: Alignment.centerRight,
                      paddingLeft: 8,
                      paddingRight: MediaQuery.of(context).size.width/2,
                    ),
                    BeautifulBackgroundDesignWidget(
                      iconData: CupertinoIcons.book,
                      color: Colors.pinkAccent,
                      degree: 10,
                      size: 120,
                      opacity: 0.4,
                      duration: 3000,
                      alignment: Alignment.centerRight,
                      paddingLeft: 8,
                      paddingRight: MediaQuery.of(context).size.width/5,
                    ),
                    BeautifulBackgroundDesignWidget(
                      iconData: CupertinoIcons.film,
                      color: Colors.lightBlueAccent,
                      degree: 45,
                      size: 140,
                      opacity: 0.7,
                      duration: 5000,
                      alignment: Alignment.centerLeft,
                      paddingLeft: MediaQuery.of(context).size.width/7,
                      paddingRight: 8,
                    ),
                    BeautifulBackgroundDesignWidget(
                      iconData: CupertinoIcons.camera,
                      color: Colors.deepOrangeAccent,
                      degree: -10,
                      size: 100,
                      opacity: 0.4,
                      duration: 4000,
                      alignment: Alignment.centerRight,
                      paddingLeft: 8,
                      paddingRight: MediaQuery.of(context).size.width/4,
                    ),
                  ],
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 8,
                sigmaY: 8,
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SliderWithCircleIndicatorWidget(
                            height: MediaQuery.of(context).size.height/2.5,
                            indicatorSize: 8,
                            indicatorActiveColor: Theme.of(context).primaryColor,
                            indicatorDeActiveColor: Colors.grey.shade700,
                            // slides: slides,
                            slides: Provider.of<VideosData>(context).slides,
                        ),
                        HorizontalListVideoCards(
                          topic: 'جدیدترین ها',
                          // videos: videos,
                          videos: Provider.of<VideosData>(context).videos,
                          type: ListType.newest,
                        ),
                        HorizontalListVideoCards(
                          topic: 'پر بازدیدترین ها',
                          // videos: mostVisitedVideos,
                          videos: Provider.of<VideosData>(context).mostVisitedVideos,
                          type: ListType.mostVisited,
                        ),
                        HorizontalListVideoCards(
                          topic: 'انتخاب سردبیر',
                          // videos: mostVisitedVideos,
                          videos: Provider.of<VideosData>(context).taggedVideos,
                          type: ListType.tagged,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).backgroundColor,
                          Colors.transparent,
                        ]
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: (){},
                          child: const Text('اخبار تکنولوژی'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              elevation: MaterialStateProperty.all<double>(0.0),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){},
                          child: const Text('انتخاب سردبیر'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            elevation: MaterialStateProperty.all<double>(0.0),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){},
                          child: const Text('برنامه نویسی'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            elevation: MaterialStateProperty.all<double>(0.0),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
