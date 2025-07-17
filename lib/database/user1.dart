import 'package:pixelmator/database/pixelAnimation.dart';
import 'entity.dart';

class User1 extends Entity {
  String firebaseId;
  String? name = '';
  String? photoUrl = 'null';
  List<String>? following;
  List<String>? likedAnimations;
  int? publishedCount;
  int followersCount;

  User1(this.firebaseId, this.name, this.following, this.likedAnimations,
      this.publishedCount, this.followersCount,
      [this.photoUrl]);

  @override
  Map<String, dynamic> toJson() => {
        "firebaseId": firebaseId,
        "name": name,
        "photoUrl": photoUrl,
        "following": following,
        "likedAnimations": likedAnimations,
        "publishedCount": publishedCount,
        "followersCount": followersCount,
      };

  @override
  static User1 fromJson(Map<dynamic, dynamic> v) {
    List<String> fl = [];
    for (String f in v["following"]) fl.add(f);
    List<String> lA = [];
    for (String l in v["likedAnimations"]) lA.add(l);
    return User1(v["firebaseId"], v["name"], fl, lA, v["publishedCount"],
        v["followersCount"], v["photoUrl"]);
  }
}
