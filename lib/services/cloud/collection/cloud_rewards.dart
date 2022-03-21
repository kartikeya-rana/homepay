import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepay/constants/cloud_storage_constants.dart';

class CloudRewards {
  final String documentId;
  final String userId;
  final int rewardsEarned;
  final int rewardsUsed;
  final DateTime dateCreated;
  final DateTime dateUpdaed;

  CloudRewards(
      {required this.documentId,
      required this.userId,
      required this.rewardsEarned,
      required this.rewardsUsed,
      required this.dateCreated,
      required this.dateUpdaed});

  CloudRewards.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[rewardsUserIdField] as String,
        rewardsEarned = snapshot.data()[rewardsEarnedField] as int,
        rewardsUsed = snapshot.data()[rewardsUsedField] as int,
        dateCreated = snapshot.data()[rewardsDateCreatedField].toDate(),
        dateUpdaed = snapshot.data()[rewardsDateUpdatedField].toDate();
}
