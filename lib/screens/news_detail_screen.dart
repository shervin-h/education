import 'package:education/providers/theme_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:education/models/news.dart';
import 'package:education/services/education_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../ui/theme.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({required this.newsId, Key? key}) : super(key: key);

  final int newsId;

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  late News _news;
  bool _isInitialized = false;

  late ScrollController _scrollController;
  bool _pinnedAppBar = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // print(_scrollController.offset.round());
      if (_scrollController.offset.round() > 140) {
        setState(() {
          _pinnedAppBar = true;
        });
      } else {
        setState(() {
          _pinnedAppBar = false;
        });
      }
    });

    _initializeNews();
  }

  _initializeNews() async {
    _news = await EducationApi.getNewsDetail(widget.newsId);
    setState(() {
      _isInitialized = true;
    });
  }

  dynamic _setupAuthorImage(News news) {
    if (news.source != null && news.source!.image != null) {
      return NetworkImage(news.source!.image!);
    }
    return const AssetImage('assets/images/background_1.jpg');
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

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final newsId = ModalRoute.of(context)!.settings.arguments as int;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double expandedAppBarHeight = screenHeight * 0.3;

    return Scaffold(
      body: (!_isInitialized)
          ? Center(
              child: CupertinoActivityIndicator(
                color: Theme.of(context).primaryColor,
                radius: 16,
              ),
            )
          : CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  collapsedHeight: AppBar().preferredSize.height,
                  pinned: true,
                  expandedHeight: expandedAppBarHeight,
                  leading: const SizedBox(),
                  flexibleSpace: (!_pinnedAppBar)
                      ? SizedBox(
                          height: expandedAppBarHeight,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Image.network(
                                _news.image,
                                fit: BoxFit.cover,
                                width: screenWidth,
                                height: expandedAppBarHeight,
                                errorBuilder: (context, object, stackTrace) {
                                  return Image.asset(
                                    'assets/images/placeholder_video.png',
                                    fit: BoxFit.scaleDown,
                                    width: screenWidth,
                                    height: expandedAppBarHeight,
                                  );
                                },
                              ),
                              Container(
                                width: screenWidth,
                                height: expandedAppBarHeight,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Theme.of(context).scaffoldBackgroundColor,
                                      Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .withOpacity(0.6),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _news.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                              shadows: [
                                                Shadow(
                                                  color: Theme.of(context).primaryColorDark.withOpacity(0.8),
                                                  blurRadius: 4,
                                                )
                                              ],
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'نویسنده: ${_news.author}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: Colors.grey[500],
                                              shadows: [
                                                Shadow(
                                                  color: Theme.of(context).primaryColorDark.withOpacity(0.9),
                                                  blurRadius: 1,
                                                ),
                                              ],
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          // DateFormat("EEEE  H:m  yyyy/MM/yy")
                                          //     .format(DateTime.parse(
                                          //         _news.publishAt)),
                                          toStringFormatter(Jalali.fromDateTime(DateTime.parse(_news.publishAt))),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                color: Theme.of(context).primaryColorDark,
                                                fontWeight: FontWeight.bold,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          height: AppBar().preferredSize.height,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Provider.of<ThemeInfo>(context).isDark
                                ? Theme.of(context).scaffoldBackgroundColor
                                : lightMaterialGrey,
                          ),
                          child: Text(
                            _news.title.substring(
                                0,
                                (_news.title.length > 40)
                                    ? 40
                                    : _news.title.length),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: Theme.of(context).primaryColorDark,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: (!_pinnedAppBar)
                              ? [
                                  const BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                  )
                                ]
                              : null,
                        ),
                        child: const Icon(CupertinoIcons.right_chevron),
                      ),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                      child: Text(_news.content,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(height: 1.6),
                          textAlign: TextAlign.start
                          // textAlign: TextAlign.justify,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                      child: Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        'منبع: ',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).primaryColorDark),
                        textAlign: TextAlign.center,
                      ),
                      title: Text(
                        _news.source!.name,
                        textAlign: TextAlign.start,
                      ),
                      subtitle: Text(
                        _news.source!.address.substring(
                            0,
                            (_news.source!.address.length > 30)
                                ? 30
                                : _news.source!.address.length),
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          _news.source!.image!,
                          fit: BoxFit.scaleDown,
                          width: expandedAppBarHeight * 0.5,
                          height: expandedAppBarHeight * 0.5,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              CupertinoIcons.building_2_fill,
                              color: Theme.of(context).errorColor,
                            );
                          },
                        ),
                      ),
                      /*leading: FadeInImage(
                        image: NetworkImage(_news.source!.image!),
                        placeholder: const AssetImage("assets/images/background_07.jpg"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Icon(
                            CupertinoIcons.exclamationmark_circle,
                            color: Theme.of(context).errorColor,
                          );
                          // return Image.asset(
                          //   'assets/images/error.jpg',
                          //   fit: BoxFit.fitWidth,
                          // );
                        },
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        width: expandedAppBarHeight * 0.4,
                        height: expandedAppBarHeight * 0.4,
                      ),*/
                    ),
                  ]),
                ),
              ],
            ),
    );
  }
}

String toStringFormatter(Jalali d) {
  final f = d.formatter;
  return '${f.wN}   ${f.date.minute}:${f.date.minute}   ${f.yyyy}/${f.mm}/${f.dd}';
}
