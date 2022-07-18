import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:education/models/news.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({required this.news, Key? key}) : super(key: key);

  final News news;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    double radius = 8;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      title: Text(
        news.title,
        style: Theme.of(context).textTheme.subtitle1,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نویسنده: ${news.author}',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.grey[500]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                // DateFormat("EEEE  H:m  yyyy/MM/yy")
                //     .format(DateTime.parse(news.publishAt)),
                toStringFormatter(Jalali.fromDateTime(DateTime.parse(news.publishAt))),
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Theme.of(context).primaryColorDark),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              blurRadius: 6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.network(
            news.image,
            fit: BoxFit.cover,
            width: screenWidth * 0.24,
            // height: screenWidth * 0.2,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                CupertinoIcons.news,
                color: Theme.of(context).errorColor,
              );
            },
          ),
        ),
      ),
    );
  }
}

String toStringFormatter(Jalali d) {
  final f = d.formatter;

  return '${f.wN}   ${f.date.minute}:${f.date.minute}   ${f.yyyy}/${f.mm}/${f.dd}';
}

/*
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.cover,
      image: NetworkImage(
        video.cover,
      ),
    ),
    borderRadius: BorderRadius.circular(8),
  ),
),
 */
