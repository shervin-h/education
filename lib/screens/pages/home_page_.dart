import 'package:education/providers/theme_info.dart';
import 'package:education/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:education/providers/videos_data.dart';
import 'package:education/widgets/horizontal_list_video_cards_widget.dart';
import 'package:education/widgets/slider_with_circle_indicator_widget.dart';
import 'package:education/helpers/helper_enums.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SliderWithCircleIndicatorWidget(
                  height: MediaQuery.of(context).size.height / 2.5,
                  indicatorSize: 8,

                  indicatorActiveColor: Provider.of<ThemeInfo>(context).isDark
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColorDark,

                  indicatorDeActiveColor: Provider.of<ThemeInfo>(context).isDark
                      ? materialGrey
                      : lightMaterialGrey,
                  // slides: slides,
                  slides: Provider.of<VideosData>(context).slides,
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.06,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ]),
                  ),
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
          // Container(
          //   width: double.infinity,
          //   height: 56,
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Theme.of(context).backgroundColor,
          //         Colors.transparent,
          //       ]
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       ElevatedButton(
          //         onPressed: (){},
          //         child: const Text('اخبار تکنولوژی'),
          //         style: ButtonStyle(
          //             backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          //             elevation: MaterialStateProperty.all<double>(0.0),
          //         ),
          //       ),
          //       ElevatedButton(
          //         onPressed: (){},
          //         child: const Text('انتخاب سردبیر'),
          //         style: ButtonStyle(
          //           backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          //           elevation: MaterialStateProperty.all<double>(0.0),
          //         ),
          //       ),
          //       ElevatedButton(
          //         onPressed: (){},
          //         child: const Text('برنامه نویسی'),
          //         style: ButtonStyle(
          //           backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          //           elevation: MaterialStateProperty.all<double>(0.0),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
