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
  Future<CloudHouseDetails> createNewHouse({
    required String userId,
    required String nickname,
    required String address1,
    required String address2,
    required String city,
    required String state,
    required String country,
    required int rentAmount,
    required DateTime dueDate,
    required DateTime dateCreated,
  }) async {
    final house = await houses.add({
      userIdField: userId,
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

    final fetchedHouse = await house.get();

    return CloudHouseDetails(
        documentId: fetchedHouse.id,
        userId: userId,
        nickname: nickname,
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        country: country,
        rentAmount: rentAmount,
        dueDate: dueDate,
        dateCreated: dateCreated);
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
