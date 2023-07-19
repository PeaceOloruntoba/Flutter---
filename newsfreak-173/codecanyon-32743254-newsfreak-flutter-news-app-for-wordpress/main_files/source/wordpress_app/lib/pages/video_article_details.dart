import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:wordpress_app/blocs/ads_bloc.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/constants.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/bookmark_icon.dart';
import 'package:wordpress_app/widgets/html_body.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/widgets/related_articles.dart';
import 'package:wordpress_app/widgets/video_player_widget.dart';
import 'comments_page.dart';

class VideoArticleDeatils extends StatefulWidget {
  const VideoArticleDeatils({Key? key, required this.article})
      : super(key: key);

  final Article article;

  @override
  _VideoArticleDeatilsState createState() => _VideoArticleDeatilsState();
}

class _VideoArticleDeatilsState extends State<VideoArticleDeatils> {
  double _rightPaddingValue = 140;

  Future _handleShare() async {
    Share.share(widget.article.link!);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
        .then((value) => context.read<AdsBloc>().showLoadedAds());
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        _rightPaddingValue = 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Article? article = widget.article;
    final bookmarkedList = Hive.box(Constants.bookmarkTag);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        //appBar: _appBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              //color: Colors.amberAccent,
              child: Html(
                  shrinkWrap: false,
                  data: article!.content,
                  tagsList: const [
                    'html',
                    'body',
                    'figure',
                    'video'
                  ],
                  style: {
                    "body": Style(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      fontSize: FontSize(17.0),
                      lineHeight: LineHeight(1.4),
                    ),
                    "figure": Style(
                        margin: EdgeInsets.zero, padding: EdgeInsets.zero),
                  },
                  customRenders: {
                    AppService.videoMatcher(): CustomRender.widget(widget: (context1, buildChildren) {
                      String _videoSource = context1.tree.attributes['src'] ?? '';
                      if (_videoSource == "") return Container();
                      return SafeArea(
                        bottom: false,
                        top: true,
                        child: Stack(
                          children: [
                            VideoPlayerWidget(
                              videoUrl: _videoSource,
                              videoType: 'network',
                              thumbnailUrl: article.image,
                            ),

                            Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: Icon(Icons.keyboard_arrow_left, color: Colors.white,),
                                  onPressed: ()=> Navigator.pop(context),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  }),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 5, 0),
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                      child: AnimatedPadding(
                                        duration: Duration(milliseconds: 1000),
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: _rightPaddingValue,
                                            top: 5,
                                            bottom: 5),
                                        child: Text(
                                          article.category!,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                                  Spacer(),
                                  BookmarkIcon(
                                    bookmarkedList: bookmarkedList,
                                    article: article,
                                    iconSize: 22,
                                    iconColor: Colors.blueGrey,
                                    normalIconColor: Colors.grey,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => _handleShare(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.time_solid,
                                        color: Colors.grey[400],
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        article.date!,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 8,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                article.avatar!),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'By ${article.author}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                AppService.getNormalText(article.title!),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.6,
                                    wordSpacing: 1),
                              ),
                              Divider(
                                color: Theme.of(context).primaryColor,
                                endIndent: 280,
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  TextButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Theme.of(context)
                                                  .primaryColor),
                                      shape: MaterialStateProperty.resolveWith(
                                          (states) => RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3))),
                                    ),
                                    icon: Icon(Icons.comment,
                                        color: Colors.white, size: 20),
                                    label: Text('comments',
                                            style:
                                                TextStyle(color: Colors.white))
                                        .tr(),
                                    onPressed: () => nextScreenPopup(
                                        context,
                                        CommentsPage(
                                          postId: article.id,
                                          categoryId: article.catId!,
                                          postTitle: article.title!,
                                          postLink: article.link!,
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        HtmlBody(
                            content: article.content!,
                            isVideoEnabled: false,
                            isimageEnabled: true,
                            isIframeVideoEnabled: true),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    RelatedArticles(
                      postId: article.id,
                      catId: article.catId,
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),

            // banner ads
            //AdConfig.isAdsEnabled == true ? BannerAdWidget() : Container(),
          ],
        ));
  }

  // AppBar _appBar() {
  //   return AppBar(
  //     automaticallyImplyLeading: false,
  //     toolbarHeight: 45,
  //     leading: IconButton(
  //       icon: Icon(
  //         Icons.arrow_back_ios_sharp,
  //         size: 20,
  //       ),
  //       onPressed: () => Navigator.pop(context),
  //     ),
  //     actions: [
  //       IconButton(
  //         icon: Icon(
  //           Icons.share,
  //           size: 20,
  //         ),
  //         onPressed: () => _handleShare(),
  //       ),
  //       IconButton(
  //         icon: Icon(
  //           Feather.external_link,
  //           size: 20,
  //         ),
  //         onPressed: () =>
  //             AppService().openLinkWithCustomTab(context, widget.article.link!),
  //       ),
  //     ],
  //   );
  // }
}
