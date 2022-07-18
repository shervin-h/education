import 'package:education/providers/theme_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:education/ui/theme.dart';
import 'package:education/models/video.dart';


class SearchVideoItem extends StatelessWidget {
  const SearchVideoItem({
    required this.video,
    required this.onDismissed,
    Key? key
  }) : super(key: key);

  final Video video;
  final Function(DismissDirection)? onDismissed;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight * 0.2;
    return Dismissible(
      key: ValueKey(video.id),
      background: Container(
        margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            CupertinoIcons.delete,
            size: cardHeight * 0.2,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      child: Consumer<ThemeInfo>(
        builder: (context, themeInfo, child) {
          return SizedBox(
            height: cardHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Shimmer.fromColors(
                  highlightColor: themeInfo.isDark ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                  baseColor: themeInfo.isDark ? Theme.of(context).primaryColor.withOpacity(0.4) : Theme.of(context).primaryColorDark.withOpacity(0.4),
                  period: const Duration(
                    seconds: 4,
                  ),
                  direction: ShimmerDirection.rtl,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: themeInfo.isDark ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  padding: const EdgeInsets.all(2),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: themeInfo.isDark ? materialGrey : lightMaterialGrey,
                  ),
                  child: SizedBox(
                    width: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.star_fill,
                          size: 14,
                          color: Colors.yellowAccent,
                        ),
                        SizedBox(
                          height: cardHeight * 0.1,
                        ),
                        Text(
                          video.rate.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(32, 16, 8, 16),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    // color: materialGrey
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              cardHeight * 0.04,
                              cardHeight * 0.04,
                              cardHeight * 0.04,
                              cardHeight * 0.04),
                          child: Stack(
                            children: [
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
                              Container(
                                // height: cardHeight * 0.2,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
                                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
                                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.50),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(cardHeight * 0.02),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            CupertinoIcons.eye_fill,
                                            size: cardHeight * 0.08,
                                          ),
                                          Text(
                                            video.visit.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: cardHeight * 0.02,
                                      ),
                                      // Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.center,
                                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      //   children: [
                                      //     Icon(
                                      //       CupertinoIcons.star_fill,
                                      //       size: cardHeight * 0.08,
                                      //       color: Colors.yellowAccent,
                                      //     ),
                                      //     Text(
                                      //       video.rate.toString(),
                                      //       style: Theme.of(context)
                                      //           .textTheme
                                      //           .caption!
                                      //           .copyWith(
                                      //           color: Colors.yellowAccent,
                                      //           fontWeight: FontWeight.bold,
                                      //           fontSize: 12),
                                      //     )
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              video.title,
                              style: Theme.of(context).textTheme.subtitle1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              video.description!,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(color: Colors.grey[500]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'دسته : ${video.category!.title}',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(color: themeInfo.isDark ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'مدرس : ${video.teacher!.firstName} ${video.teacher!.lastName}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontStyle: FontStyle.italic),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: cardHeight * 0.1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(32, 16, 8, 16),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: cardHeight * 0.06,
                        bottom: cardHeight * 0.06,
                        child: Container(
                          width: cardHeight * 0.22,
                          height: cardHeight * 0.22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(video.teacher!.avatar!),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                Theme.of(context).primaryColor.withOpacity(0.4),
                                blurRadius: (cardHeight * 0.22) * 0.1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/*
child: Container(
                    width: cardHeight * 0.6,
                    height: cardHeight * 0.2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              CupertinoIcons.eye_fill,
                              size: cardHeight * 0.08,
                            ),
                            Text(
                              video.visit.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              CupertinoIcons.star_fill,
                              size: cardHeight * 0.08,
                              color: Colors.yellowAccent,
                            ),
                            Text(
                              video.rate.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                      color: Colors.yellowAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
 */
