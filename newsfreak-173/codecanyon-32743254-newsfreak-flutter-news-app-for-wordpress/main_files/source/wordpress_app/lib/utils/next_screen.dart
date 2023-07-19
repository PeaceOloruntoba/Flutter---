import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/config/wp_config.dart';
import 'package:wordpress_app/models/article.dart';
import 'package:wordpress_app/models/notification_model.dart';
import 'package:wordpress_app/pages/article_details.dart';
import 'package:wordpress_app/pages/custom_notification_details.dart';
import 'package:wordpress_app/pages/video_article_details.dart';
import 'package:wordpress_app/pages/post_notification_details.dart';

void nextScreen (context, page){
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => page));
}


void nextScreeniOS (context, page){
  Navigator.push(context, CupertinoPageRoute(
    builder: (context) => page));
}


void nextScreenCloseOthers (context, page){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace (context, page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}


void nextScreenPopup (context, page){
  Navigator.push(context, MaterialPageRoute(
    fullscreenDialog: true,
    builder: (context) => page),
  );
}


void navigateToDetailsScreen (context, Article article, String? heroTag){
  if(article.tags == null || !article.tags!.contains(WpConfig.videoTagId)){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ArticleDetails(articleData: article, tag: heroTag,)),
    );
  }else{
     Navigator.push(context, MaterialPageRoute(
      builder: (context) => VideoArticleDeatils(article: article)),

    );
  }
}

void navigateToDetailsScreenByReplace (context, Article article, String? heroTag){
  if(article.tags == null || !article.tags!.contains(WpConfig.videoTagId)){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => ArticleDetails(articleData: article, tag: heroTag,)),
    );
  }else{
     Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => VideoArticleDeatils(article: article)),
    );
  }
}


void navigateToNotificationDetailsScreen (context, NotificationModel notificationModel){
  if(notificationModel.postID == null){
    nextScreen(context, CustomNotificationDeatils(notificationModel: notificationModel));
  }else{
    nextScreen(context, PostNotificationDetails(postID: notificationModel.postID!));
  }
}