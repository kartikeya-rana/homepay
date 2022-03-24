import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepay/constants/cloud_storage_constants.dart';
import 'package:homepay/services/cloud/cloud_storage_exceptions.dart';
import 'package:homepay/services/cloud/collection/cloud_rewards.dart';

class CloudRewardsStorage {
  final rewards = FirebaseFirestore.instance.collection(rewardsCollectionName);

  // Singleton
  static final CloudRewardsStorage _shared =
      CloudRewardsStorage._sharedInstance();
  CloudRewardsStorage._sharedInstance();
  factory CloudRewardsStorage() => _shared;

  Future<void> createNewUserRewards({required String userId}) async {
    DateTime _now = DateTime.now();
    try {
      await rewards.add({
        rewardsUserIdField: userId,
        rewardsEarnedField: 0,
        rewardsUsedField: 0,
        rewardsDateCreatedField: _now,
        rewardsDateUpdatedField: _now,
      });
    } catch (e) {
      throw CouldNotCreateRewardException();
    }
  }

  Future<bool> isRewardProfile({required String userId}) async {
    final result = await rewards.where(userIdField, isEqualTo: userId).get();
    return result.docs.isEmpty;
  }

  Stream<Iterable<CloudRewards>> getRewards({required String userId}) {
    return rewards.snapshots().map((event) => event.docs
        .map((doc) => CloudRewards.fromSnapshot(doc))
        .where((reward) => reward.userId == userId));
  }

  Future<CloudRewards> getRewardDetails({required String userId}) async {
    final result = await rewards.where(userIdField, isEqualTo: userId).get();
    return CloudRewards.fromSnapshot(result.docs[0]);
  }

  // Future<CloudRewards> getRewards({required String userId}) async {
  //   final reward = await rewards.where(userIdField, isEqualTo: userId).get();
  //   return CloudRewards.fromSnapshot(reward.docs[0]);
  // }

  Future<void> updateRewards(
      {required String documentId,
      required int rewardsUsed,
      required int rewardsEarned}) async {
    try {
      await rewards.doc(documentId).update(
          {rewardsUsedField: rewardsUsed, rewardsEarnedField: rewardsEarned});
    } catch (e) {
      throw CouldNotUpdateRewardException();
    }
  }
}
