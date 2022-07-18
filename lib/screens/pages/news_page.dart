import 'package:education/providers/videos_data.dart';
import 'package:education/screens/news_detail_screen.dart';
import 'package:education/widgets/news_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<VideosData>(
          builder: (context, videosData, child) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: videosData.newsCount,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewsDetail(newsId: videosData.news[index].id),
                      ),
                    );
                  },
                  child: NewsItem(news: videosData.news[index],),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
