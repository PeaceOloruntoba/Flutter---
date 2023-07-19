import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/cached_image.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/bookmark_icon.dart';
import 'package:wordpress_app/widgets/video_icon.dart';


//card for releated articles in the details page
class Card5 extends StatelessWidget {
  const Card5({Key? key, required this.article})
      : super(key: key);
  final Article article;

  @override
  Widget build(BuildContext context) {
    final bookmarkedList = Hive.box(Constants.bookmarkTag);
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Theme.of(context).colorScheme.surface,
                    blurRadius: 10,
                    offset: Offset(0, 3))
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      height: 120,
                      width: 120,
                      child: CustomCacheImage(imageUrl: article.image, radius: 5)
                  ),

                  VideoIcon(tags: article.tags, iconSize: 40,)
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 120,
                  padding: EdgeInsets.only(top: 0, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppService.getNormalText(article.title!),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        article.category!.toUpperCase(),
                        style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            size: 16,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(article.timeAgo!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                          Spacer(),
                          BookmarkIcon(
                            bookmarkedList: bookmarkedList,
                            article: article,
                            iconSize: 18,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
      onTap: () => navigateToDetailsScreenByReplace(context, article, null)
    );
  }
}
