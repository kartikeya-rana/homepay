import 'package:flutter/material.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details_storage.dart';

class NewHouseView extends StatefulWidget {
  const NewHouseView({Key? key}) : super(key: key);

  @override
  State<NewHouseView> createState() => _NewHouseViewState();
}

class _NewHouseViewState extends State<NewHouseView> {
  // declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  late final CloudHouseStorage _houseService;
  late final CloudHouseDetails _house;

  String _nickname = '';
  String _address1 = '';
  String _address2 = '';
  String _city = '';
  String _state = '';
  String _country = '';
  int _rentAmount = 0;
  bool _isFormEnabled = true;
  // late final DateTime _dueDate;
  // late final DateTime _dateCreated;

  @override
  void initState() {
    _houseService = CloudHouseStorage();
    super.initState();
  }

  Future<void> _save() async {
    // validate all the form fields
    if (_formKey.currentState!.validate()) {
      final _currentUser = AuthService.firebase().currentUser!;
      final userId = _currentUser.id;

      DateTime _now = DateTime.now();

      await _houseService.createNewHouse(
          userId: userId,
          nickname: _nickname,
          address1: _address1,
          address2: _address2,
          city: _city,
          state: _state,
          country: _country,
          rentAmount: _rentAmount,
          dueDate: _now,
          dateCreated: _now);
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    // Get the house details when clicked on card and fill the initial values
    if (arguments != null) {
      _house = arguments as CloudHouseDetails;
      _nickname = _house.nickname;
      _address1 = _house.address1;
      _address2 = _house.address2;
      _city = _house.city;
      _state = _house.state;
      _country = _house.country;
      _rentAmount = _house.rentAmount;
      _isFormEnabled = false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('New House')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _nickname,
                enabled: _isFormEnabled,
                decoration: const InputDecoration(labelText: 'House Nickname'),
                onChanged: (text) => setState(() => _nickname = text),
              ),
              TextFormField(
                initialValue: _address1,
                enabled: _isFormEnabled,
                decoration: const InputDecoration(labelText: 'Address 1'),
                onChanged: (text) => setState(() => _address1 = text),
              ),
              TextFormField(
                initialValue: _address2,
                enabled: _isFormEnabled,
                decoration: const InputDecoration(labelText: 'Address 2'),
                onChanged: (text) => setState(() => _address2 = text),
              ),
              TextFormField(
                initialValue: _city,
                enabled: _isFormEnabled,
                decoration: const InputDecoration(labelText: 'City'),
                onChanged: (text) => setState(() => _city = text),
              ),
              TextFormField(
                initialValue: _state,
                enabled: _isFormEnabled,
                decoration: const InputDecoration(labelText: 'State'),
                onChanged: (text) => setState(() => _state = text),
              ),
              TextFormField(
                initialValue: _country,
                enabled: _isFormEnabled,
                decoration: const InputDecoration(labelText: 'Country'),
                onChanged: (text) => setState(() => _country = text),
              ),
              TextFormField(
                initialValue: _rentAmount.toString(),
                enabled: _isFormEnabled,
                decoration: const InputDecoration(labelText: 'Rent Amount'),
                onChanged: (text) {
                  if (text != '') {
                    setState(() => _rentAmount = int.parse(text));
                  } else {
                    setState(() => _rentAmount = 0);
                  }
                },
              ),
              // TextFormField(
              //     decoration: const InputDecoration(labelText: 'Due Date'),
              //     onChanged: (text) => setState(() => _dueDate = text as DateTime),
              // ),
              const SizedBox(
                height: 10,
              ),
              if (_isFormEnabled)
                ElevatedButton(
                    onPressed: () async {
                      await _save();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'))
              else
                ElevatedButton(
                    onPressed: () async {
                      _houseService.deleteHouse(documentId: _house.documentId);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Delete')),
            ],
          ),
        ),
      ),
    );
  }
}
