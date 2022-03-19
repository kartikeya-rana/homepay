import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepay/constants/cloud_storage_constants.dart';

class CloudHouseDetails {
  final String documentId;
  final String userId;
  final String nickname;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String country;
  final int rentAmount;
  final DateTime dueDate;
  final DateTime dateCreated;

  CloudHouseDetails(
      {required this.documentId,
      required this.userId,
      required this.nickname,
      required this.address1,
      required this.address2,
      required this.city,
      required this.state,
      required this.country,
      required this.rentAmount,
      required this.dueDate,
      required this.dateCreated});

  CloudHouseDetails.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[userIdField],
        nickname = snapshot.data()[houseNicknameField] as String,
        address1 = snapshot.data()[houseAddress1Field] as String,
        address2 = snapshot.data()[houseAddress2Field] as String,
        city = snapshot.data()[houseCityField] as String,
        state = snapshot.data()[houseStateField] as String,
        country = snapshot.data()[houseCountryField] as String,
        rentAmount = snapshot.data()[houseRentAmountField] as int,
        dueDate = snapshot.data()[houseDueDateField].toDate(),
        dateCreated = snapshot.data()[houseDateCreatedField].toDate();
}
