import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepay/constants/cloud_storage_constants.dart';

class CloudHouseDetails {
  final String documentId;
  final String userId;
  final String ownerId;
  final String nickname;
  final String address;
  final GeoPoint geoPoint;
  final int rentAmount;
  final DateTime dueDate;
  final DateTime dateCreated;

  CloudHouseDetails(
      {required this.documentId,
      required this.userId,
      required this.ownerId,
      required this.nickname,
      required this.address,
      required this.geoPoint,
      required this.rentAmount,
      required this.dueDate,
      required this.dateCreated});

  CloudHouseDetails.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userId = snapshot.data()[userIdField],
        ownerId = snapshot.data()[houseOwnerIdField],
        nickname = snapshot.data()[houseNicknameField] as String,
        address = snapshot.data()[houseAddressField] as String,
        geoPoint = snapshot.data()[houseGeoPoint] as GeoPoint,
        rentAmount = snapshot.data()[houseRentAmountField] as int,
        dueDate = snapshot.data()[houseDueDateField].toDate(),
        dateCreated = snapshot.data()[houseDateCreatedField].toDate();
}
