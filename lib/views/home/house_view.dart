import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:url_launcher/url_launcher.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details_storage.dart';
import 'package:homepay/views/home/house_list_view.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

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

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // padding: const EdgeInsets.all(),
          decoration: BoxDecoration(
              boxShadow: insideShadow,
              borderRadius: BorderRadius.circular(8),
              color: primaryColor),
          child: Card(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: ListTile(
                leading: Image.asset(
                  'lib/assets/images/payment-method.png',
                  fit: BoxFit.contain,
                ),
                title: const Text(
                  'Rental Credit Score',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                subtitle: const Text(
                  'Score is calculated based upon on timely payments, rental history, and rental amount.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                    overflow: TextOverflow.visible,
                  ),
                ),
                contentPadding: const EdgeInsets.all(8)),
            elevation: 2,
          ),
        ),
        const SizedBox(
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
                      return const Center();
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
