import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepay/constants/cloud_storage_constants.dart';

class CloudOwnerDetails {
  final String documentId;
  final String userId;
  final String ownerName;
  final String ownerNumber;
  final String accountHolderName;
  final String bankAccountNumber;
  final String bankIdentifierCode;
  final String bankName;
  final DateTime dateCreated;

  CloudOwnerDetails(
      {required this.documentId,
      required this.userId,
      required this.ownerName,
      required this.ownerNumber,
      required this.accountHolderName,
      required this.bankAccountNumber,
      required this.bankIdentifierCode,
      required this.bankName,
      required this.dateCreated});

  CloudOwnerDetails.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[userIdField] as String,
        ownerName = snapshot.data()[ownerNameField] as String,
        ownerNumber = snapshot.data()[ownerNumberField] as String,
        accountHolderName =
            snapshot.data()[ownerAccountHolderNameField] as String,
        bankAccountNumber =
            snapshot.data()[ownerBankAccountNumberField] as String,
        bankIdentifierCode =
            snapshot.data()[ownerBankIdentifierCodeField] as String,
        bankName = snapshot.data()[ownerBankNameField] as String,
        dateCreated = snapshot.data()[ownerDateCreatedField].toDate();

  CloudOwnerDetails.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot[userIdField] as String,
        ownerName = snapshot[ownerNameField] as String,
        ownerNumber = snapshot[ownerNumberField] as String,
        accountHolderName = snapshot[ownerAccountHolderNameField] as String,
        bankAccountNumber = snapshot[ownerBankAccountNumberField] as String,
        bankIdentifierCode = snapshot[ownerBankIdentifierCodeField] as String,
        bankName = snapshot[ownerBankNameField] as String,
        dateCreated = snapshot[ownerDateCreatedField].toDate();
}
