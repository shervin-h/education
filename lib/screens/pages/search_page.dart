import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:education/providers/videos_data.dart';
import 'package:education/models/video.dart';
import 'package:education/services/education_api.dart';
import 'package:education/widgets/search_video_item_widget.dart';
import 'package:education/widgets/search_bar_widget.dart';
import 'package:education/screens/video_detail_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller;
  bool isWriting = false;
  bool isSearching = false;

  String _result = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      if (_controller.value.text.isEmpty) {
        setState(() {
          isWriting = false;
          isSearching = false;
        });
      } else {
        setState(() {
          isWriting = true;
          _result = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future searchVideos(BuildContext context, String title) async {
    setState(() {
      isSearching = true;
    });

    List<Video> searchList =
        await EducationApi.getSearchedVideoList(phrase: title);

    Provider.of<VideosData>(context, listen: false).clearSearchedVideos();
    if (searchList.isEmpty) {
      _result = 'متاسفانه چیزی پیدا نشد ):';
    } else {
      Provider.of<VideosData>(context, listen: false)
          .addAllSearchedVideos(searchList);
      _result = '';
    }

    setState(() {
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchBar(
              isWriting: isWriting,
              controller: _controller,
              onSubmitted: (_) {
                if (_controller.text.trim().isNotEmpty) {
                  searchVideos(context, _controller.text);
                }
              },
            ),
            Expanded(
              child: (isSearching)
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: Theme.of(context).primaryColor,
                          radius: 16,
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: (_result.isEmpty)
                          ? Consumer<VideosData>(
                              builder: (context, videosData, child) {
                                return ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: videosData.searchedVideos.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoDetailScreen(
                                                    videoId: videosData
                                                        .searchedVideos[index]
                                                        .id),
                                          ),
                                        );
                                      },
                                      child: SearchVideoItem(
                                        video: videosData.searchedVideos[index],
                                        onDismissed: (direction) {
                                          videosData.removeSearchedItem(videosData.searchedVideos[index].id);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                _result,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Theme.of(context).errorColor),
                              ),
                            ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

/*
FutureBuilder(
                  // future: searchVideos(context, _controller.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CupertinoActivityIndicator(
                          color: Theme.of(context).primaryColor,
                          radius: 16,
                        ),
                      );
                    } else {
                      if (snapshot.error != null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'اشکالی در گرفتن ویدیو ها پیش آمد ..!',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      color: Theme.of(context).errorColor),
                            ),
                          ),
                        );
                      } else {
                        return Consumer<VideosData>(
                          builder: (context, videosData, child) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: videosData.searchedVideos.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => VideoDetailScreen(
                                            videoId: videosData.searchedVideos[index].id),
                                      ),
                                    );
                                  },
                                  child: SearchVideoItem(
                                    video: videosData.searchedVideos[index],
                                    onDismissed: (direction) {},
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    }
                  },
                ),
 */
