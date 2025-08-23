import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/model/reel/comment.dart';
import 'package:homely/model/reel/fetch_comment.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class CommentSheetController extends GetxController {
  ReelData reelData;
  Function(ReelUpdateType type, ReelData data)? onUpdateReel;

  CommentSheetController(this.reelData, this.onUpdateReel);

  PrefService prefService = PrefService();
  ScrollController scrollController = ScrollController();
  TextEditingController commentTextEditController = TextEditingController();

  UserData? myUserData;
  bool isLoading = false;
  bool hasMoreProperty = true;

  bool isCommentSendLoading = false;
  List<CommentData> comments = [];

  @override
  void onReady() {
    super.onReady();
    prefData();
    fetchComment();
    _loadMoreData();
  }

  void prefData() async {
    await prefService.init();
    myUserData = prefService.getUserData();
    update();
  }

  void fetchComment() {
    if (!hasMoreProperty) return;
    isLoading = true;
    update();
    ApiService().call(
        completion: (response) {
          FetchComment comment = FetchComment.fromJson(response);
          if ((comment.data?.length ?? 0) < int.parse(cPaginationLimit)) {
            hasMoreProperty = false;
          }

          if (comment.status == true) {
            comments.addAll(comment.data ?? []);
            reelData.commentsCount = comments.length;
          }
          isLoading = false;
          update();
        },
        url: UrlRes.fetchComments,
        param: {uReelId: reelData.id, uStart: comments.length, uLimit: cPaginationLimit});
  }

  void onSendComment() {
    if (commentTextEditController.text.trim().isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    isCommentSendLoading = true;

    ApiService().call(
        completion: (response) {
          commentTextEditController.clear();
          isCommentSendLoading = false;
          Comment comment = Comment.fromJson(response);
          if (comment.status == true && comment.data != null) {
            comments.insert(0, comment.data!);
            reelData.commentsCount = comments.length;
            onUpdateReel?.call(ReelUpdateType.comment, reelData);
          }
          update();
        },
        onError: () {
          isCommentSendLoading = false;
          update();
        },
        url: UrlRes.addComment,
        param: {uUserId: myUserData?.id, uReelId: reelData.id, uDescription: commentTextEditController.text.trim()});
  }

  void _loadMoreData() {
    scrollController.addListener(
      () {
        if (scrollController.offset >= scrollController.position.maxScrollExtent) {
          if (!isLoading) {
            fetchComment();
          }
        }
      },
    );
  }
}
