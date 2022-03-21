import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepay/constants/cloud_storage_constants.dart';
import 'package:homepay/services/cloud/collection/cloud_payment_history.dart';

class CloudPaymentHistoryStorage {
  final paymentHistory =
      FirebaseFirestore.instance.collection(paymentHistoryCollectionName);

  // Singleton
  static final CloudPaymentHistoryStorage _shared =
      CloudPaymentHistoryStorage._sharedInstance();
  CloudPaymentHistoryStorage._sharedInstance();
  factory CloudPaymentHistoryStorage() => _shared;

  Future<CloudPaymentHistory> createNewPayment(
      {required String userId,
      required String houseId,
      required String ownerId,
      required int amountPaid,
      required DateTime paymentDate}) async {
    final newPayment = await paymentHistory.add({
      paymentUserIdField: userId,
      paymentHouseIdField: houseId,
      paymentOwnerIdField: ownerId,
      paymentAmountPaidField: amountPaid,
      paymentDateField: paymentDate
    });

    final fetchedPayment = await newPayment.get();
    return CloudPaymentHistory(
        documentId: fetchedPayment.id,
        userId: userId,
        houseId: houseId,
        ownerId: ownerId,
        amountPaid: amountPaid,
        paymentDate: paymentDate);
  }

  Stream<Iterable<CloudPaymentHistory>> allPayments({required String userId}) {
    return paymentHistory
        .orderBy(paymentDateField, descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => CloudPaymentHistory.fromSnapshot(doc))
            .where((payment) => payment.userId == userId));
  }
}
