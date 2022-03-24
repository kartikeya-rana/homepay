import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details_storage.dart';
import 'package:homepay/views/home/house_list_view.dart';

class HouseView extends StatefulWidget {
  const HouseView({Key? key}) : super(key: key);

  @override
  State<HouseView> createState() => _HouseViewState();
}

class _HouseViewState extends State<HouseView> {
  late final CloudHouseStorage _houseService;
  String get userId => AuthService.firebase().currentUser!.id;
  final feedbackFormUrl = 'https://forms.gle/rw1eBPy25VfrY7qq5';

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
        const SizedBox(
          height: 12,
        ),
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
          child: Card(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: ListTile(
                title: const Text(
                  'Google Solution Challenge 2022',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                subtitle: const Text(
                  "This app is created for Google Solution Challenge'22. Kindly share your feedback.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
                trailing: TextButton(
                    onPressed: () async {
                      if (await canLaunch(feedbackFormUrl)) {
                        await launch(feedbackFormUrl, forceWebView: true);
                      }
                    },
                    child: const Text('Click Here')),
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
