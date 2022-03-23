import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepay/constants/cloud_storage_constants.dart';
import 'package:homepay/services/cloud/cloud_storage_exceptions.dart';
import 'package:homepay/services/cloud/collection/cloud_owner_details.dart';

class CloudOwnerStorage {
  // Singleton
  static final CloudOwnerStorage _shared = CloudOwnerStorage._sharedInstance();
  CloudOwnerStorage._sharedInstance();
  factory CloudOwnerStorage() => _shared;

  final owners = FirebaseFirestore.instance.collection(ownerCollectionName);

  Future<String> createNewOwner(
      {required String userId,
      required String ownerName,
      required int ownerNumber,
      required String accountHolderName,
      required String bankAccountNumber,
      required String bankIdentifierCode,
      required String bankName,
      required DateTime dateCreated}) async {
    try {
      final owner = await owners.add({
        ownerUserIdField: userId,
        ownerNameField: ownerName,
        ownerNumberField: ownerNumber,
        ownerAccountHolderNameField: accountHolderName,
        ownerBankAccountNumberField: bankAccountNumber,
        ownerBankIdentifierCodeField: bankIdentifierCode,
        ownerBankNameField: bankName,
        ownerDateCreatedField: dateCreated
      });

      final fetchedOwner = await owner.get();
      return fetchedOwner.id;
    } catch (e) {
      throw CouldNotCreateOwnerException();
    }
  }

  Future<CloudOwnerDetails> getOwnerDetails(
      {required String documentId}) async {
    try {
      final owner = await owners.doc(documentId).get();
      return CloudOwnerDetails.fromDocumentSnapshot(owner);
    } catch (e) {
      throw CouldNotGetOwnerException();
    }
  }

  Future<void> deleteOwner({required String documentId}) async {
    try {
      await owners.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteOwnerException();
    }
  }
}
