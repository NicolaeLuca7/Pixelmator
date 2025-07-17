import 'package:pixelmator/database/entity.dart';

class PublishedAnimation extends Entity {
  String resourceId;
  String userId;
  int likesCount;
  DateTime publishDate;

  PublishedAnimation(
      this.resourceId, this.userId, this.likesCount, this.publishDate);

  @override
  Map<String, dynamic> toJson() => {
        "resourceId": resourceId,
        "userId": userId,
        "likesCount": likesCount,
        "publishDate": publishDate
      };

  @override
  static PublishedAnimation fromJson(Map<dynamic, dynamic> v) {
    return PublishedAnimation(v["resourceId"], v["userId"], v["likesCount"],
        v["publishDate"].toDate());
  }
}
