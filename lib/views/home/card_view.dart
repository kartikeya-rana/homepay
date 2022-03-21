import 'package:flutter/material.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details_storage.dart';
import 'package:homepay/services/cloud/collection/cloud_rewards_storage.dart';
import 'package:homepay/views/home/house_list_view.dart';
import 'package:homepay/views/home/new_house_view.dart';

class CardView extends StatefulWidget {
  const CardView({Key? key}) : super(key: key);

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  late final CloudHouseStorage _houseService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _houseService = CloudHouseStorage();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Expanded(
          child: StreamBuilder(
              stream: _houseService.allHouses(userId: userId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allHouses =
                          snapshot.data as Iterable<CloudHouseDetails>;
                      return HousesListView(
                        houses: allHouses,
                        onTap: (house) {
                          Navigator.of(context)
                              .pushNamed(addNewHouseRoute, arguments: house);
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                  default:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                }
              }),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(addNewHouseRoute);
          },
          child: const Text('Add Rental'),
        ),
      ]),
    );
  }
}
