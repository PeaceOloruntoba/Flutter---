import 'package:flutter/material.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/cards/card5.dart';
import 'package:wordpress_app/services/wordpress_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/utils/vertical_line.dart';
import 'package:wordpress_app/widgets/loading_indicator_widget.dart';

class RelatedArticles extends StatefulWidget {
  final int? postId;
  final int? catId;

  const RelatedArticles(
      {Key? key,
      required this.postId,
      required this.catId,})
      : super(key: key);

  @override
  _RelatedArticlesState createState() => _RelatedArticlesState();
}

class _RelatedArticlesState extends State<RelatedArticles> {
  Future? data;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = WordPressService().fetchPostsByCategoryIdExceptPostId(widget.postId, widget.catId, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  verticalLine(context, 20),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'contents you might love',
                    style: TextStyle(
                      letterSpacing: -0.7,
                      wordSpacing: 1,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ).tr(),
                ],
              ),
            ),
          
        SizedBox(
          height: 15,
        ),
        Container(
          child: FutureBuilder(
            future: data,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return _LoadingWidget();
                case ConnectionState.done:
                default:
                  if (snapshot.hasError || snapshot.data == null) {
                    return _NoContents();
                  } else if (snapshot.data.isEmpty) {
                    return _NoContents();
                  }

                  return ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      separatorBuilder: (ctx, idx) => SizedBox(
                            height: 15,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        Article? article = snapshot.data[index];
                        return Card5(
                            article: article!);
                      });
              }
            },
          ),
        ),
      ],
    );
  }
}

class _NoContents extends StatelessWidget {
  const _NoContents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      margin: EdgeInsets.only(right: 20, left: 20),
      child: Text(
        'no contents found',
        style: TextStyle(
          fontSize: 16,
        ),
      ).tr(),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 20, left: 20),
      child: LoadingIndicatorWidget()
    );
  }
}
