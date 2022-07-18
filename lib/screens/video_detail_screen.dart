import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'dart:isolate';
import 'package:education/providers/theme_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:education/helpers/preferences.dart';
import 'package:education/models/user.dart';
import 'package:education/models/video.dart';
import 'package:education/providers/user_data.dart';
import 'package:education/providers/videos_data.dart';
import 'package:education/screens/video_detail_screen_tab_pages/comment_list.dart';
import 'package:education/ui/theme.dart';
import 'package:education/services/education_api.dart';
import 'package:education/screens/video_player_screen.dart';
import 'package:education/screens/video_detail_screen_tab_pages/related_videos_tab_page.dart';
import 'package:education/models/comment.dart';
import 'package:education/screens/video_detail_screen_tab_pages/similar_videos_screen_tab_page.dart';
import 'package:education/screens/video_detail_screen_tab_pages/video_list.dart';
import 'package:education/helpers/db_helper.dart';
import 'package:education/helpers/constants.dart';
import 'package:education/widgets/bottomsheet_alert_widget.dart';
import 'package:education/widgets/bottomsheet_success_widget.dart';
import 'package:education/helpers/download_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';


class VideoDetailScreen extends StatefulWidget {
  // static const String routeName = 'VideoDetailScreen';

  const VideoDetailScreen({required this.videoId, Key? key}) : super(key: key);

  final int videoId;

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen>
    with SingleTickerProviderStateMixin {
  late Video video;
  bool _isInitialized = false;

  late TabController _tabController;
  List<Tab> tabs = const <Tab>[
    Tab(text: 'قسمت ها'),
    Tab(text: 'نظرات'),
    Tab(text: 'مشابه'),
  ];

  List<Video> _relatedVideos = [];
  List<Comment> _comments = [];
  List<Video> _similarVideos = [];

  List<Widget> tabPages = [];
  int _pageNumber = 0;

  late ScrollController _scrollController;
  bool _pinnedAppBar = false;

  int _toggleHandThumbs = handThumbsDefaultStateId;
  bool _isBookmark = false;
  bool _seen = false;
  double _rating = 0.0;

  bool _processing = false;
  bool _ratingProcess = false;

  int progress = 0;
  final ReceivePort _receivePort = ReceivePort();
  static downloadingCallback(id, status, progress) {
    /// looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');

    /// sending the data
    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: tabs.length, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset.round() > 260) {
        setState(() {
          _pinnedAppBar = true;
        });
      } else {
        setState(() {
          _pinnedAppBar = false;
        });
      }
    });
    initializeVideo();

    /// register a send port for the other isolates
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, 'downloading');

    /// listening for the data is coming other isolates
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  initializeVideo() async {
    video = await EducationApi.getVideoDetailObject(id: widget.videoId);

    // Tab page 1 => related videos
    if (video.course != null) {
      _relatedVideos = await EducationApi.getCourseRelatedVideosList(courseId: video.course!.id);
    }
    if (_relatedVideos.isNotEmpty) {
      _relatedVideos.removeWhere((element) => element.id == widget.videoId);
      tabPages.add(VideoList(videos: _relatedVideos));
    } else {
      tabPages.add(_nothing('در حال حاضر قسمتی وجود ندارد!'));
    }

    // Tab page 2 => video comments
    _comments = await EducationApi.getVideoComments(videoId: widget.videoId);
    if (_comments.isNotEmpty) {
      tabPages.add(CommentList(comments: _comments));
    } else {
      tabPages.add(_nothing('در حال حاضر نظری نیست!'));
    }

    // Tab page 3 => similar videos
    if (video.category != null){
      _similarVideos = await EducationApi.getCategoryVideos(categoryId: video.category!.id);
    }
    if (_relatedVideos.isNotEmpty) {
      if (video.course != null ) {
        _similarVideos.removeWhere((element) {
          if (element.course != null) {
            return element.course!.id == video.course!.id;
          }
          return false;
        });
      }
      tabPages.add(VideoList(videos: _similarVideos));
    } else {
      tabPages.add(_nothing('در حال حاضر ویدیو ی مشابهی نیست!'));
    }

    /*if (_similarVideos.isNotEmpty) {
      tabPages.add(SimilarVideosTabPage(similarVideos: _similarVideos));
    } else {
      tabPages.add(_nothing('در حال حاضر ویدیو ی مشابهی وجود ندارد!'));
    }*/

    EducationApi.postCreateLikingVideo({"video_id": video.id}).then((result) {
      if (result == 'Already exist.' || result == 'Created successfully.') {
        _seen = true;
      }
    });

    List<Map<String, dynamic>> _consideredVideo =
        await DBHelper.getConsideredVideoData(widget.videoId);
    print(_consideredVideo.toString() + ' considered');
    if (_consideredVideo.isNotEmpty) {
      _toggleHandThumbs = _consideredVideo[0]['like_state'];
      _rating = _consideredVideo[0]['rating'];
      _seen = true;
    } else {
      await DBHelper.insert(
          'considered_videos',
          {
            'video_id': video.id,
            'seen': 1,
            'title': video.title,
            'description': video.description ?? '',
            'url': video.url ?? '',
            'cover': video.cover,
            'banner': video.banner ?? '',
            'wallpaper': video.wallpaper ?? '',
            'visit': video.visit
          },
      );
      Provider.of<VideosData>(context, listen: false).fetchAndSetConsideredVideos();
    }

    List<Map<String, dynamic>> _bookmarkedVideo =
        await DBHelper.getBookmarkedVideoData(widget.videoId);
    print(_bookmarkedVideo.toString() + ' bookmarked');
    if (_bookmarkedVideo.isNotEmpty) {
      _isBookmark = true;
    } else {
      _isBookmark = false;
    }

    setState(() {
      _isInitialized = true;
    });
  }

  void _changeTabPage(int index) {
    setState(() {
      _pageNumber = index;
    });
  }


  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, int>;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double defaultAppBarHeight = AppBar().preferredSize.height;

    double bannerHeight = screenHeight / 2.2;
    double tabBarViewHeight = screenHeight / 2.5;
    if (_relatedVideos.length >= 5 ||
        _similarVideos.length >= 5 ||
        _comments.length >= 5) {
      tabBarViewHeight = MediaQuery.of(context).size.height -
          TabBar(tabs: tabs).preferredSize.height - defaultAppBarHeight * 2;
    }

    return Scaffold(
      body: (!_isInitialized)
          ? Center(
              child: CupertinoActivityIndicator(
                color: Theme.of(context).primaryColor,
                radius: 16,
              ),
            )
          : Consumer<ThemeInfo>(
              builder: (context, themeInfo, child) {
                return Container(
                  width: screenWidth,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (video.wallpaper != null)
                          ? NetworkImage(video.wallpaper!)
                          : const AssetImage('assets/images/placeholder_video.png') as ImageProvider,
                      fit: BoxFit.cover,
                      onError: (object, stackTrace) {}
                      // opacity: 0.1,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor.withOpacity(0.92),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 8,
                        sigmaY: 8,
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            controller: _scrollController,
                            slivers: [
                              SliverAppBar(
                                collapsedHeight: defaultAppBarHeight * 2,
                                pinned: true,
                                expandedHeight: bannerHeight,
                                leading: const SizedBox(),
                                flexibleSpace: (!_pinnedAppBar)
                                    ? SizedBox(
                                        height: bannerHeight,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Image.network(
                                              video.banner!,
                                              fit: BoxFit.cover,
                                              width: screenWidth,
                                              height: bannerHeight,
                                            ),
                                            Container(
                                              width: screenWidth,
                                              height: bannerHeight,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                    Theme.of(context)
                                                        .backgroundColor
                                                        .withOpacity(0.70),
                                                    Theme.of(context)
                                                        .backgroundColor
                                                        .withOpacity(0.95),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: -50,
                                              right: 20,
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: screenWidth * 0.34,
                                                        height: screenWidth *
                                                            0.34 *
                                                            1.286,
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .lightGreenAccent,
                                                          borderRadius:
                                                          BorderRadius.circular(4),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .lightGreenAccent,
                                                              blurRadius: 8,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                        child: Image.network(
                                                          video.cover,
                                                          fit: BoxFit.cover,
                                                          width: screenWidth * 0.34,
                                                          height: screenWidth *
                                                              0.34 *
                                                              1.286,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(
                                                            10, 14, 10, 8),
                                                        child: Text(
                                                          video.title.substring(
                                                              0,
                                                              (video.title.length >
                                                                  30)
                                                                  ? 30
                                                                  : video.title
                                                                  .length),
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyText1,
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(12, 4, 12, 8),
                                                        child: SizedBox(
                                                          width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                              2.1,
                                                          child: Text(
                                                            video.source!.name.substring(
                                                                0,
                                                                (video.source!.name
                                                                    .length >
                                                                    40)
                                                                    ? 40
                                                                    : video
                                                                    .source!
                                                                    .name
                                                                    .length),
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyText2,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons.heart_fill,
                                                        color: Colors.redAccent,
                                                        size: screenWidth * 0.04,
                                                      ),
                                                      Text(
                                                        ' 95% ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons.eye,
                                                        size: screenWidth * 0.04,
                                                        color: (_seen) ? Theme.of(context).primaryColor : Colors.white,
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        '${video.visit}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(left: 8),
                                                  padding: const EdgeInsets.all(4.0),
                                                  decoration: BoxDecoration(
                                                      color: themeInfo.isDark
                                                          ? null
                                                          : Colors.black38,
                                                      borderRadius: BorderRadius.circular(screenWidth * 0.04 * 0.4)
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons.star_fill,
                                                        size: screenWidth * 0.04,
                                                        color: Colors.yellowAccent,
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        '${video.rate}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2!
                                                            .copyWith(color: Colors.yellowAccent),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: themeInfo.isDark
                                        ? Colors.transparent
                                        : lightMaterialGrey ,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: defaultAppBarHeight,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: themeInfo.isDark
                                              ? Theme.of(context).scaffoldBackgroundColor
                                              : lightMaterialGrey,
                                        ),
                                        child: Text(
                                          video.title.substring(
                                              0,
                                              (video.title.length > 30)
                                                  ? 30
                                                  : video.title.length),
                                          style:
                                          Theme.of(context).textTheme.bodyText1,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Container(
                                        // margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                        width: screenWidth,
                                        height: defaultAppBarHeight,
                                        alignment: Alignment.center,
                                        child: (_ratingProcess)
                                            ? ProcessingWidget(widget: RatingBar.builder(
                                          initialRating: _rating,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          minRating: 0.0,
                                          maxRating: 5.0,
                                          glowColor: Theme.of(context).primaryColor,
                                          itemCount: 5,
                                          itemSize: defaultAppBarHeight * 0.5,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 2),

                                          itemBuilder: (context, _) {
                                            return const Icon(
                                              CupertinoIcons.star_fill,
                                              color: Colors.yellowAccent,
                                            );
                                          },
                                          onRatingUpdate: (rating) {},
                                        ), opacity: 0.2)
                                            : RatingBar.builder(
                                                initialRating: _rating,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                minRating: 0.0,
                                                maxRating: 5.0,
                                                glowColor: Theme.of(context).primaryColor,
                                                itemCount: 5,
                                                itemSize: defaultAppBarHeight * 0.5,
                                                itemPadding: const EdgeInsets.symmetric(horizontal: 2),

                                                itemBuilder: (context, _) {
                                                  return const Icon(
                                                    CupertinoIcons.star_fill,
                                                    color: Colors.yellowAccent,
                                                  );
                                                },
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                  _changeRatingBarState(context, rating);
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  IconButton(
                                    icon: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: (!_pinnedAppBar)
                                            ? [
                                                const BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 8,
                                                ),
                                              ]
                                            : null ,
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.right_chevron,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(16, 8, 8, 16),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return VideoPlayerScreen(
                                                  url: video.url!,
                                                  title: video.title,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green),
                                            maximumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size.fromWidth(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        3.5))),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: const [
                                            Text('تماشا'),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              CupertinoIcons.play_arrow_solid,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(32, 8, 32, 8),
                                    child: Divider(
                                      height: 1,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    child: Text(
                                      video.description!,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(32, 8, 32, 8),
                                    child: Divider(
                                      height: 1,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  ListTile(
                                    /*leading: CircleAvatar(
                                  backgroundImage: _setupTeacherAvatar(video),
                                  radius: 30,
                                ),*/
                                    leading: Container(
                                      width: screenWidth * 0.12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: (video.teacher!.avatar != null)
                                              ? NetworkImage(video.teacher!.avatar!)
                                              : const AssetImage('assets/images/placeholder_user.png') as ImageProvider,
                                          fit: BoxFit.cover,
                                          onError: (error, stackTrace) {},
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                        '${video.teacher!.firstName} ${video.teacher!.lastName}'),
                                    /*subtitle: Text(
                                  video.teacher!.about!.substring(
                                      0,
                                      (video.teacher!.about!.length > 30)
                                          ? 30
                                          : video.teacher!.about!.length),
                                ),*/
                                    subtitle: (video.teacher!.website != null) ? Text(video.teacher!.website!) : null,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(32, 32, 32, 32),
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            (_processing && _toggleHandThumbs == handThumbsUpStateId)
                                                ? ProcessingWidget(widget: IconButton(
                                              onPressed: () {},
                                              icon: (_toggleHandThumbs == handThumbsUpStateId)
                                                  ? const Icon(CupertinoIcons.hand_thumbsup_fill)
                                                  : const Icon(CupertinoIcons.hand_thumbsup),
                                            ),
                                                opacity: 0.28)
                                                : IconButton(
                                              onPressed: () {
                                                _changeHandThumbsState(context, handThumbsUpStateId);
                                              },
                                              icon: (_toggleHandThumbs == handThumbsUpStateId)
                                                  ? const Icon(CupertinoIcons.hand_thumbsup_fill)
                                                  : const Icon(CupertinoIcons.hand_thumbsup),
                                            ),

                                            (_processing && _toggleHandThumbs == handThumbsDownStateId)
                                                ? ProcessingWidget(widget: IconButton(
                                              onPressed: () {},
                                              icon: (_toggleHandThumbs == handThumbsDownStateId)
                                                  ? const Icon(CupertinoIcons.hand_thumbsdown_fill)
                                                  : const Icon(CupertinoIcons.hand_thumbsdown),
                                            ), opacity: 0.28)
                                                : IconButton(
                                              onPressed: () {
                                                _changeHandThumbsState(context, handThumbsDownStateId);
                                              },
                                              icon: (_toggleHandThumbs == handThumbsDownStateId)
                                                  ? const Icon(CupertinoIcons.hand_thumbsdown_fill)
                                                  : const Icon(CupertinoIcons.hand_thumbsdown),
                                            ),

                                            IconButton(
                                              onPressed: () {
                                                _toggleBookmark(context);
                                              },
                                              icon: (_isBookmark)
                                                  ? const Icon(
                                                  CupertinoIcons.bookmark_fill)
                                                  : const Icon(CupertinoIcons.bookmark),
                                            ),

                                            (Provider.of<VideosData>(context).isDownloading)
                                                ? ProcessingWidget(
                                              widget: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(CupertinoIcons.arrow_down_to_line),
                                              ),
                                              opacity: 0.28,
                                            )
                                                : IconButton(
                                              onPressed: () {
                                                _flutterDownloader(context, 'https://up.7learn.com/expertvid/php-intro.mp4', 'php-intro.mp4');
                                              },
                                              icon: const Icon(CupertinoIcons.arrow_down_to_line),
                                            ),

                                            IconButton(
                                              onPressed: () {
                                                _share(context);
                                              },
                                              icon: const Icon(CupertinoIcons.share),
                                            ),
                                          ],
                                        ),
                                        (Provider.of<VideosData>(context).isDownloading)
                                            ? LinearProgressIndicator(
                                                backgroundColor: Colors.grey,
                                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                                value: progress.toDouble(),
                                                minHeight: 2,
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                  TabBar(
                                    labelColor: themeInfo.isDark
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).primaryColorDark,

                                    labelStyle:
                                    Theme.of(context).textTheme.headline6,

                                    indicatorSize: TabBarIndicatorSize.label,
                                    indicatorColor: themeInfo.isDark
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).primaryColorDark,

                                    overlayColor: MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor),
                                    onTap: _changeTabPage,
                                    tabs: tabs,
                                    controller: _tabController,
                                  ),
                                  SizedBox(
                                    width: screenWidth,
                                    height: tabBarViewHeight,
                                    child: TabBarView(
                                      physics: const BouncingScrollPhysics(),
                                      children: tabPages,
                                      controller: _tabController,
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _nothing(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.topCenter,
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }


  void _toggleBookmark(BuildContext context) async {
    setState(() {
      _isBookmark = !_isBookmark;
    });

    var bookmarkedVideoDataList =
    await DBHelper.getBookmarkedVideoData(video.id);
    if (_isBookmark) {
      if (bookmarkedVideoDataList.isEmpty) {
        await DBHelper.insert('bookmarked_videos', {
          'video_id': video.id,
          'title': video.title,
          'description': video.description ?? '',
          'url': video.url ?? '',
          'cover': video.cover,
          'banner': video.banner ?? '',
          'wallpaper': video.wallpaper ?? '',
          'visit': video.visit
        });
      }
    } else {
      if (bookmarkedVideoDataList.isNotEmpty) {
        Map<String, dynamic> bookmarkedVideoDataMap =
        bookmarkedVideoDataList[0];
        await DBHelper.delete(
            'bookmarked_videos', bookmarkedVideoDataMap['id']);
      }
    }

    Provider.of<VideosData>(context, listen: false)
        .fetchAndSetBookmarkedVideos();
  }


  Future<void> _patchLikingData(BuildContext context, String userKey) async {

    int res = await EducationApi.patchLikingVideo(
      userKey.trim(),
      {
        "video_id": widget.videoId,
        "like_state": _toggleHandThumbs,
      },
    );

    await DBHelper.updateConsideredVideo(
      {'like_state': _toggleHandThumbs},
      widget.videoId,
    );
  }

  Future<void> _changeHandThumbsState(BuildContext context, int handThumbsStateId) async {
    setState(() {
      _processing = true;
    });

    // get User object with SharedPreferences or Provider
    User? user = Provider.of<UserData>(context, listen: false).user;

    if (user != null) {
      if (_toggleHandThumbs != handThumbsStateId) {
        _toggleHandThumbs = handThumbsStateId;
      } else {
        _toggleHandThumbs = handThumbsDefaultStateId;
      }

      await _patchLikingData(context, user.key);
      Provider.of<VideosData>(context, listen: false)
          .fetchAndSetConsideredVideos();

    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const BottomSheetAlertWidget(message: 'لطفا ابتدا وارد شوید یا ثبت نام کنید!');
        },
      );
    }

    setState(() {
      _processing = false;
    });
  }


  Future<void> _patchRatingData(BuildContext context, String userKey) async {
    int res = await EducationApi.patchLikingVideo(
      userKey.trim(),
      {
        "video_id": widget.videoId,
        "rating": _rating,
      },
    );

    await DBHelper.updateConsideredVideo(
      {'rating': _rating},
      widget.videoId,
    );
  }

  Future<void> _changeRatingBarState(BuildContext context, double rating) async {
    setState(() {
      _ratingProcess = true;
    });

    // with shared preferences or provider
    User? user = Provider.of<UserData>(context, listen: false).user;

    if (user != null) {
      _rating = rating;

      await _patchRatingData(context, user.key);
      Provider.of<VideosData>(context, listen: false)
          .fetchAndSetConsideredVideos();

    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const BottomSheetAlertWidget(message: 'لطفا ابتدا وارد شوید یا ثبت نام کنید!');
        },
      );
    }

    setState(() {
      _ratingProcess = false;
    });
  }


  Future<void> _flutterDownloader(BuildContext context,String link, String fileName) async {

    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {

      Provider.of<VideosData>(context, listen: false).setIsDownloadingTrue();

      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        String saveDirPath = '${directory.path}/education';
        final saveDir = Directory(saveDirPath);
        bool hasExist = await saveDir.exists();
        if (!hasExist) {
          await saveDir.create();
        }
        final taskId = await FlutterDownloader.enqueue(
          url: link, // video download link
          savedDir: saveDirPath, // the path of directory where you want to save downloaded files
          fileName: fileName, // name of downloaded file. If this parameter is not set, the plugin will try to extract a file name from HTTP headers response or `url`
          showNotification: true, // show download progress in status bar (for Android)
          openFileFromNotification: true, // click on notification to open downloaded file (for Android)
        );
      }
      Provider.of<VideosData>(context, listen: false).setIsDownloadingFalse();
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const BottomSheetAlertWidget(message: 'اجازه دسترسی به حافظه جهت نگه داری ویدیو در حال دانلود، داده نشد!');
        },
      );
    }

  }
  //// Download Methods ////
  /*
  Future _myDownloader(BuildContext context, String videoUrl, String videoName) async {
    setState(() {
      _downloading = true;
    });

    if (Provider.of<VideosData>(context, listen: false).isDownloading) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const BottomSheetAlertWidget(message: 'لطفا صبر کنید تا دانلود تمام شود!');
        },
      );
      return;
    }

    Provider.of<VideosData>(context, listen: false).setIsDownloadingTrue();
    String videoPath = await Downloader.downloadFile(videoUrl, videoName);
    Provider.of<VideosData>(context, listen: false).setIsDownloadingFalse();

    if (videoPath.contains('Error')) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const BottomSheetAlertWidget(message: 'دانلود با خطا مواجه شد!');
        },
      );
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return const BottomSheetSuccessWidget(message: 'دانلود با موفقیت به پایان رسید');
          },
      );
    }

    setState(() {
      _downloading = false;
    });
  }

  FutureOr<void> _dioDownloadVideo(Map<String, dynamic> data) async {
    // BuildContext context, String videoUrl, String fileName

    Provider.of<VideosData>(data['context'], listen: false).setIsDownloadingTrue();

    // File extensions must be imported => fileName as parameter must have .mp4
    String filePath = await Downloader.getFilePath(data['fileName']);

    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.download(
      data['videoUrl'],
      filePath,
      onReceiveProgress: (receive, total) {
        String progress = ((receive / total) * 100).toStringAsFixed(0);
        setState(() {
          Provider.of<VideosData>(data['context'], listen: false).setProgress(progress);
        });
        if (progress == '100') {
          Provider.of<VideosData>(data['context'], listen: false).setIsDownloadingFalse();
        }
      },
      deleteOnError: true,
    ).then((_) {
      Provider.of<VideosData>(data['context'], listen: false).setIsDownloadingFalse();
    });
    dio.close();
  }

  Future<void> _protectVideoDownloading(BuildContext context, String videoUrl, String fileName) async {
    await compute(Downloader.dioDownloadVideo, {'context': context, 'videoUrl': videoUrl, 'fileName': fileName});
  }
   */

  Future<void> _share(BuildContext context) async {
    User? user = Provider.of<UserData>(context, listen: false).user;
    String text = '''
    سلام دوستم :)
    ${(user != null) ? 'من ${user.userName} هستم و از اپلیکیشن .:آموزش:. استفاده میکنم' : 'من درحال استفاده از پلتفرم رایگان .:آموزش:. هستم'}
    اینجا همه آموزش های مهارت محور رایگان هست
    پیشنهاد میکنم تو هم نصب کنی
    
    https://mysite.com
    ''';

    await Share.share(text, subject: 'اپلیکیشن آموزش');
  }
}

class ProcessingWidget extends StatelessWidget {
  const ProcessingWidget({
    required this.widget,
    required this.opacity,
    Key? key
  }) : super(key: key);

  final double opacity;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: opacity,
          child: widget,
        ),
        CupertinoActivityIndicator(
          color: Theme.of(context).primaryColor,
          radius: 10,
        ),
      ],
    );
  }
}
