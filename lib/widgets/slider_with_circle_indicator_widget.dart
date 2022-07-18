import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:education/models/slide.dart';
import 'package:education/services/education_api.dart';
import 'package:education/screens/videos_list_screen.dart';
import 'package:education/screens/categorized_videos_list_screen.dart';
import 'package:education/helpers/helper_enums.dart';
import 'package:education/models/video.dart';
import 'package:education/providers/videos_data.dart';
import 'package:education/screens/video_detail_screen.dart';
import 'package:education/screens/news_detail_screen.dart';


class SliderWithCircleIndicatorWidget extends StatefulWidget {
  const SliderWithCircleIndicatorWidget({
    required this.height,
    required this.indicatorSize,
    required this.indicatorActiveColor,
    required this.indicatorDeActiveColor,
    required this.slides,
    Key? key}): super(key: key);

  final double height;
  final double indicatorSize;
  final Color indicatorActiveColor;
  final Color indicatorDeActiveColor;
  final List<Slide> slides;

  @override
  State<SliderWithCircleIndicatorWidget> createState() => _CircleContainersIndicatorWidgetState();
}

class _CircleContainersIndicatorWidgetState extends State<SliderWithCircleIndicatorWidget> {

  int currentIndex = 0;

  void changeIndicatorColor(int index){
    setState(() {
      currentIndex = index;
    });
  }


  bool isProcessing = false;

  Future<void> fetchAndSetSourceVideos (BuildContext context, int sourceId) async {
    setState(() {isProcessing = true;});

    List<Video> videos = await EducationApi.getSourceVideos(sourceId: sourceId);
    Provider.of<VideosData>(context, listen: false).addAllSourceVideos(videos);
    Navigator.of(context).pushNamed(Videos.routeName, arguments: ListType.bySource);

    setState(() {isProcessing = false;});
  }

  Future<void> fetchAndSetCourseVideos (BuildContext context, int courseId) async {
    setState(() {isProcessing = true;});

    List<Video> videos = await EducationApi.getCourseVideos(courseId: courseId);
    Provider.of<VideosData>(context, listen: false).addAllCourseVideos(videos);
    Navigator.of(context).pushNamed(Videos.routeName, arguments: ListType.byCourse);

    setState(() {isProcessing = false;});
  }
  
  Future _launchUrl(String url) async {
    setState(() {
      isProcessing = true;
    });
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        data: url,
      );
      await intent.launch();
    }
    setState(() {
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.slides.length;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: widget.height,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: count,
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: () {
                  if (widget.slides[index].kind != 'other' &&
                      widget.slides[index].kindId != null) {

                    switch(widget.slides[index].kind) {
                      case 'category': {
                        Navigator.of(context).pushNamed(
                            CategorizedVideos.routeName,
                            arguments: widget.slides[index].kindId!,
                        );
                      }
                      break;

                      case 'source': {
                        fetchAndSetSourceVideos(context, widget.slides[index].kindId!);
                      }
                      break;

                      case 'course': {
                        fetchAndSetSourceVideos(context, widget.slides[index].kindId!);
                      }
                      break;

                      case 'video': {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VideoDetailScreen(videoId:widget.slides[index].kindId!),
                          ),
                        );
                      }
                      break;

                      case 'news': {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NewsDetail(newsId: widget.slides[index].kindId!),
                          ),
                        );
                      }
                      break;

                      case 'url': {
                        // just in Android platforms
                        _launchUrl(widget.slides[index].description!.trim());
                      }
                      break;

                      default: {
                        //statements;
                      }
                      break;
                    }
                  }
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.network(
                      widget.slides[index].banner,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: widget.height,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placeholder_image',
                          fit: BoxFit.scaleDown,
                          width: double.infinity,
                          height: widget.height,
                        );
                      },
                    ),
                    Container(
                      width: double.infinity,
                      height: widget.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.transparent,
                            Theme.of(context).backgroundColor,
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.slides[index].title,
                        style: Theme.of(context).textTheme.bodyText1!
                            .copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,

                      ),
                    ),
                    isProcessing
                        ? Align(
                            alignment: Alignment.center,
                            child: CupertinoActivityIndicator(
                              color: Theme.of(context).primaryColor,
                              radius: 16,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              );
            },
            onPageChanged: changeIndicatorColor,
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: widget.indicatorSize * 2,
          padding: EdgeInsets.symmetric(horizontal: widget.indicatorSize),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: count,
            itemBuilder: (context, index){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: widget.indicatorSize/2),
                width: widget.indicatorSize,
                height: widget.indicatorSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // border: Border.all(width: 1, color: widget.indicatorActiveColor),
                  color: (currentIndex == index)
                      ? widget.indicatorActiveColor
                      : widget.indicatorDeActiveColor,
                ),
              );
            }
          ),
        )
      ],
    );
  }
}


