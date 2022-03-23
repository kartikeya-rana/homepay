import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepay/constants/cloud_storage_constants.dart';
import 'package:homepay/services/cloud/cloud_storage_exceptions.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';

class CloudHouseStorage {
  final houses = FirebaseFirestore.instance.collection(houseCollectionName);

  // Singleton
  static final CloudHouseStorage _shared = CloudHouseStorage._sharedInstance();
  CloudHouseStorage._sharedInstance();
  factory CloudHouseStorage() => _shared;

  // Create New House
  Future<void> createNewHouse({
    required String userId,
    required String nickname,
    required String ownerId,
    required String address1,
    required String address2,
    required String city,
    required String state,
    required String country,
    required int rentAmount,
    required DateTime dueDate,
    required DateTime dateCreated,
  }) async {
    try {
      await houses.add({
        userIdField: userId,
        houseOwnerIdField: ownerId,
        houseNicknameField: nickname,
        houseAddress1Field: address1,
        houseAddress2Field: address2,
        houseCityField: city,
        houseStateField: state,
        houseCountryField: country,
        houseRentAmountField: rentAmount,
        houseDueDateField: dueDate,
        houseDateCreatedField: dateCreated,
      });
    } catch (e) {
      throw CouldNotCreateHouseException();
    }
  }

  Future<Iterable<CloudHouseDetails>> getHouses(
      {required String userId}) async {
    try {
      return await houses
          .where(
            userIdField,
            isEqualTo: userId,
          )
          .get()
          .then(
            (value) =>
                value.docs.map((doc) => CloudHouseDetails.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllHousesException();
    }
  }

  Stream<Iterable<CloudHouseDetails>> allHouses({required String userId}) {
    return houses.snapshots().map((event) => event.docs
        .map((doc) => CloudHouseDetails.fromSnapshot(doc))
        .where((house) => house.userId == userId));
  }

  // Future<void> updateHouse() async {
  //   // TODO: Implement Update House Functionality
  // }

  Future<void> deleteHouse({required String documentId}) async {
    try {
      await houses.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteHouseException();
    }
  }
}
