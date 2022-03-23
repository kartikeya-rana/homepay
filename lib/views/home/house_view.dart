import 'package:flutter/material.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details_storage.dart';
import 'package:homepay/services/cloud/collection/cloud_rewards_storage.dart';
import 'package:homepay/views/home/house_list_view.dart';
import 'package:homepay/views/home/new_house_view.dart';

class HouseView extends StatefulWidget {
  const HouseView({Key? key}) : super(key: key);

  @override
  State<HouseView> createState() => _HouseViewState();
}

class _HouseViewState extends State<HouseView> {
  late final CloudHouseStorage _houseService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _houseService = CloudHouseStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // padding: const EdgeInsets.all(),
          decoration: BoxDecoration(
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  spreadRadius: 1.5,
                ),
              ],
              borderRadius: BorderRadius.circular(8),
              color: rentalCardBackground),
          child: const Card(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: ListTile(
                title: Text(
                  'Rental Credit Score',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                subtitle: Text(
                  'Score is calculated based upon on timely payments, rental history, and rental amount.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                    overflow: TextOverflow.visible,
                  ),
                ),
                contentPadding: EdgeInsets.all(8)),
            elevation: 2,
          ),
        ),
        SizedBox(
          height: 12,
        ),
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
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context).pushNamed(addNewHouseRoute);
        //   },
        //   child: const Text('Add Rental'),
        // ),
      ],
    );
  }
}
