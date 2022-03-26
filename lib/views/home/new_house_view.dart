import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details_storage.dart';
import 'package:homepay/services/cloud/collection/cloud_owner_details_storage.dart';
import 'package:homepay/views/home/google_map_view.dart';

class NewHouseView extends StatefulWidget {
  const NewHouseView({Key? key}) : super(key: key);

  @override
  State<NewHouseView> createState() => _NewHouseViewState();
}

class _NewHouseViewState extends State<NewHouseView> {
  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  late final CloudHouseStorage _houseService;
  late final CloudOwnerStorage _ownerService;
  late final CloudHouseDetails house;

  String _nickname = '';
  String _address = '';
  GeoPoint _geoPoint = GeoPoint(0, 0);
  String _rentAmount = '';
  String _ownerName = '';
  String _ownerNumber = '';
  String _bankName = '';
  String _bankAccountHolderName = '';
  String _bankAccountNumber = '';
  String _bankIdentifierCode = '';
  bool _isFormEnabled = true;
  // late final DateTime _dueDate;
  // late final DateTime _dateCreated;

  @override
  void initState() {
    _houseService = CloudHouseStorage();
    _ownerService = CloudOwnerStorage();
    super.initState();
  }

  Future<bool> _save() async {
    // validate all the form fields
    if (_formKey.currentState!.validate()) {
      final _currentUser = AuthService.firebase().currentUser!;
      final userId = _currentUser.id;

      DateTime _now = DateTime.now();

      final String ownerDocumentId = await _ownerService.createNewOwner(
          userId: userId,
          ownerName: _ownerName,
          ownerNumber: 0,
          accountHolderName: _bankAccountHolderName,
          bankAccountNumber: _bankAccountNumber,
          bankIdentifierCode: _bankIdentifierCode,
          bankName: _bankName,
          dateCreated: _now);

      await _houseService.createNewHouse(
          userId: userId,
          ownerId: ownerDocumentId,
          nickname: _nickname,
          address: _address,
          geoPoint: _geoPoint,
          rentAmount: int.parse(_rentAmount),
          dueDate: _now,
          dateCreated: _now);

      return true;
    }

    return false;
  }

  Future<void> createOrInsertDetails(arguments) async {
    if (arguments != null) {
      house = arguments as CloudHouseDetails;
      final owner =
          await _ownerService.getOwnerDetails(documentId: house.ownerId);

      _nickname = house.nickname;
      _address = house.address;
      _rentAmount = house.rentAmount.toString();
      _ownerName = owner.ownerName;
      // _ownerNumber = ownerNumberField.toString();
      _bankName = owner.bankName;
      _bankAccountHolderName = owner.accountHolderName;
      _bankAccountNumber = owner.bankAccountNumber.toString();
      _bankIdentifierCode = owner.bankIdentifierCode;
      _isFormEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    // Get the house details when clicked on card and fill the initial values

    return FutureBuilder(
        future: createOrInsertDetails(arguments),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'House Details',
                    style: TextStyle(color: secondaryColor),
                  ),
                  shadowColor: Colors.black,
                  elevation: 6,
                ),
                body: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Form(
                      key: _formKey,

                      // padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if (_isFormEnabled)
                            GoogleMapView(
                              addressLatLng: (location) {
                                _geoPoint = location;
                              },
                            ),
                          TextFormField(
                            initialValue: _nickname,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'House Nickname',
                                icon: Icon(Icons.home, color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _nickname = text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: _address,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Address',
                                icon:
                                    Icon(Icons.navigation, color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _address = text,
                          ),
                          TextFormField(
                            initialValue: _rentAmount.toString(),
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Rent Amount',
                                icon: Icon(
                                  Icons.savings,
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _rentAmount = text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: _ownerName,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Owner Name',
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _ownerName = text,
                          ),
                          // TextFormField(
                          //   initialValue: _ownerNumber,
                          //   enabled: _isFormEnabled,
                          //   decoration: const InputDecoration(
                          //       labelText: 'Owner Number *',
                          //       enabledBorder: UnderlineInputBorder(
                          //           borderSide: BorderSide(
                          //               color: houseFormBorderColor)),
                          //       labelStyle:
                          //           TextStyle(color: houseFormLabelColor)),
                          //   style: const TextStyle(color: houseFormTextColor),
                          //   onChanged: (text) => _ownerNumber = text,
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'required';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          TextFormField(
                            initialValue: _bankName,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Owner Bank Name',
                                icon: Icon(
                                  Icons.account_balance_outlined,
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _bankName = text,
                          ),
                          // TextFormField(
                          //   initialValue: _bankAccountHolderName,
                          //   enabled: _isFormEnabled,
                          //   decoration: const InputDecoration(
                          //       labelText: 'Account Holder Name',
                          //       enabledBorder: UnderlineInputBorder(
                          //           borderSide: BorderSide(
                          //               color: houseFormBorderColor)),
                          //       labelStyle:
                          //           TextStyle(color: houseFormLabelColor)),
                          //   style: const TextStyle(color: houseFormTextColor),
                          //   onChanged: (text) => _bankAccountHolderName = text,
                          // ),
                          TextFormField(
                            initialValue: _bankAccountNumber,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Owner Bank Account Number',
                                icon: Icon(Icons.account_balance_wallet,
                                    color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _bankAccountNumber = text,
                          ),
                          TextFormField(
                            initialValue: _bankIdentifierCode,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Owner Bank Identifier Code',
                                icon: Icon(
                                  Icons.qr_code,
                                  color: Colors.white,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _bankIdentifierCode = text,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (_isFormEnabled)
                            ElevatedButton(
                                onPressed: () async {
                                  final bool isSaved = await _save();
                                  if (isSaved) {
                                    Navigator.of(context).pop();
                                  }
                                  //
                                },
                                child: const Text('Save'))
                          else
                            ElevatedButton(
                                onPressed: () async {
                                  _houseService.deleteHouse(
                                      documentId: house.documentId);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete')),
                        ],
                      ),
                    ),
                  ),
                ),
              );

            default:
              return Container();
          }
        }));
  }
}
