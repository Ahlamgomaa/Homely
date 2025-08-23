import 'package:homely/model/reel/fetch_reels.dart';

enum ReelUpdateType {
  like,
  follow,
  save,
  comment,
}

class ReelUpdater {
  /// Updates the reels list based on the provided type and data.
  ///
  /// [reelsList]: The list of reels to be updated.
  /// [type]: The type of update to perform.
  /// [data]: The new data to update the reels with.
  static void updateReelsList({
    required List<ReelData> reelsList,
    required ReelUpdateType type,
    required ReelData data,
    Function(ReelUpdateType, ReelData)? onUpdate,
  }) {
    onUpdate?.call(type, data);
    for (var element in reelsList) {
      switch (type) {
        case ReelUpdateType.like:
          if (element.id == data.id) {
            element.isLike = data.isLike;
            element.likesCount = data.likesCount;
          }
          break;

        case ReelUpdateType.follow:
          if (element.userId == data.userId) {
            element.isFollow = data.isFollow;
          }
          break;

        case ReelUpdateType.save:
          if (element.id == data.id) {
            element.isSaved = data.isSaved;
          }
          break;

        case ReelUpdateType.comment:
          if (element.id == data.id) {
            element.commentsCount = data.commentsCount;
          }
          break;
      }
    }
  }
}
