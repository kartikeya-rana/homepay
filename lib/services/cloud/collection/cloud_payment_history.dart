import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepay/constants/cloud_storage_constants.dart';

class CloudPaymentHistory {
  final String documentId;
  final String userId;
  final String houseId;
  final String ownerId;
  final int amountPaid;
  final DateTime paymentDate;

  CloudPaymentHistory(
      {required this.documentId,
      required this.userId,
      required this.houseId,
      required this.ownerId,
      required this.amountPaid,
      required this.paymentDate});

  CloudPaymentHistory.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[paymentUserIdField] as String,
        houseId = snapshot.data()[paymentHouseIdField] as String,
        ownerId = snapshot.data()[paymentOwnerIdField] as String,
        amountPaid = snapshot.data()[paymentAmountPaidField] as int,
        paymentDate = snapshot.data()[paymentDateField].toDate();
}
