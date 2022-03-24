import 'package:flutter/material.dart';
import 'package:homepay/constants/cloud_storage_constants.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details_storage.dart';
import 'package:homepay/services/cloud/collection/cloud_owner_details_storage.dart';

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
  String _address1 = '';
  String _address2 = '';
  String _city = '';
  String _state = '';
  String _country = '';
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
          ownerNumber: int.parse(_ownerNumber),
          accountHolderName: _bankAccountHolderName,
          bankAccountNumber: _bankAccountNumber,
          bankIdentifierCode: _bankIdentifierCode,
          bankName: _bankName,
          dateCreated: _now);

      await _houseService.createNewHouse(
          userId: userId,
          ownerId: ownerDocumentId,
          nickname: _nickname,
          address1: _address1,
          address2: _address2,
          city: _city,
          state: _state,
          country: _country,
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
      _address1 = house.address1;
      _address2 = house.address2;
      _city = house.city;
      _state = house.state;
      _country = house.country;
      _rentAmount = house.rentAmount.toString();
      _ownerName = owner.ownerName;
      _ownerNumber = ownerNumberField.toString();
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
                          TextFormField(
                            initialValue: _nickname,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'House Nickname *',
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
                            initialValue: _address1,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Address 1',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _address1 = text,
                          ),
                          TextFormField(
                            initialValue: _address2,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Address 2',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _address2 = text,
                          ),
                          TextFormField(
                            initialValue: _city,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'City',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _city = text,
                          ),
                          TextFormField(
                            initialValue: _state,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'State',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _state = text,
                          ),
                          TextFormField(
                            initialValue: _country,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Country',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _country = text,
                          ),
                          TextFormField(
                            initialValue: _rentAmount.toString(),
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Rent Amount *',
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
                                labelText: 'Owner Name *',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _ownerName = text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: _ownerNumber,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Owner Number *',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _ownerNumber = text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: _bankName,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Bank Name',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _bankName = text,
                          ),
                          TextFormField(
                            initialValue: _country,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Account Holder Name',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _bankAccountHolderName = text,
                          ),
                          TextFormField(
                            initialValue: _country,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Bank Account Number',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: houseFormBorderColor)),
                                labelStyle:
                                    TextStyle(color: houseFormLabelColor)),
                            style: const TextStyle(color: houseFormTextColor),
                            onChanged: (text) => _bankAccountNumber = text,
                          ),
                          TextFormField(
                            initialValue: _country,
                            enabled: _isFormEnabled,
                            decoration: const InputDecoration(
                                labelText: 'Bank Identifier Code',
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
