import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixelmator/database/pixelAnimation.dart';
import 'package:pixelmator/database/publishedAnimation.dart';

import 'user1.dart';

final db = FirebaseFirestore.instance;

Future<User1?> getUser(String id) async {
  var res =
      await db.collection("users").where('firebaseId', isEqualTo: id).get();

  if (res.size == 0) return null;
  User1 us = User1.fromJson(res.docs[0].data());
  us.setId(res.docs[0].id);
  return us;
}

Future<User1?> getUserById(String id) async {
  var res = await db.collection("users").doc(id).get();
  User1 us = User1.fromJson(res.data()!);
  us.setId(res.id);
  return us;
}

Future<String?> addUser(User1 user) async {
  if (user.name!.length > 40) user.name != user.name!.substring(0, 40);
  var res = await db.collection("users").add(user.toJson());
  return res.id;
}

Future<void> updateUser(User1 user) async {
  await db.collection("users").doc(user.getId()).update(user.toJson());
}

Future<PixelAnimation?> getAnimationById(String id) async {
  var res = await db.collection("pAnimations").doc(id).get();
  PixelAnimation pAnim = PixelAnimation.fromJson(res.data()!);
  pAnim.setId(res.id); // = PixelAnimation.fromJson(res.docs[0].data());
  return pAnim;
}

Future<void> addAnimation(PixelAnimation pAnim) async {
  await db.collection("pAnimations").add(pAnim.toJson());
}

Future<void> updateAnimation(PixelAnimation pAnim) async {
  await db.collection("pAnimations").doc(pAnim.getId()).update(pAnim.toJson());
}

Future<void> deleteAnimation(String id) async {
  await db.collection("pAnimations").doc(id).delete();
}

Future<bool> checkIfPublished(String id) async {
  var res = await db
      .collection("publishedAnimations")
      .where('resourceId', isEqualTo: id)
      .get();

  return !(res.size == 0);
}

Future<void> publishAnimation(
    PublishedAnimation pubAnim, String animId, User1 user1) async {
  await db.collection("publishedAnimations").add(pubAnim.toJson());
  await db.collection("pAnimations").doc(animId).update({"published": true});
  user1.publishedCount = user1.publishedCount! + 1;
  await db
      .collection("users")
      .doc(user1.getId())
      .update({"publishedCount": user1.publishedCount});
}

Future<PublishedAnimation?> getPublished(String resourceId) async {
  var res = await db
      .collection("publishedAnimations")
      .where("resourceId", isEqualTo: resourceId)
      .get();
  if (res.size == 0) return null;
  PublishedAnimation pubAnim = PublishedAnimation.fromJson(res.docs[0].data());
  pubAnim.setId(res.docs[0].id);
  return pubAnim;
}

Future<void> unpublishAnimation(String id, String animId, User1 user1) async {
  await db.collection("publishedAnimations").doc(id).delete();
  await db.collection("pAnimations").doc(animId).update({"published": false});
  user1.publishedCount = user1.publishedCount! - 1;
  await db
      .collection("users")
      .doc(user1.getId())
      .update({"publishedCount": user1.publishedCount});
}

Future<void> updateLikes(String id, int likes) async {
  await db
      .collection("publishedAnimations")
      .doc(id)
      .update({"likesCount": likes});
}

Future<void> updateFollower(String userId, int count) async {
  await db.collection("users").doc(userId).update({"followersCount": count});
}
