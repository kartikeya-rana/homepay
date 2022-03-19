import 'package:flutter/material.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';

typedef HouseCallback = void Function(CloudHouseDetails house);

class HousesListView extends StatelessWidget {
  const HousesListView({
    Key? key,
    required this.houses,
    required this.onTap,
  }) : super(key: key);

  final HouseCallback onTap;

  final Iterable<CloudHouseDetails> houses;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: houses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: ((context, index) {
          final house = houses.elementAt(index);
          return Container(
            height: 150,
            // padding: const EdgeInsets.all(),
            // ignore: const
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1507692984170-ff22288b21cf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=985&q=80"),
                fit: BoxFit.cover,
                opacity: 0.9,
              ),
            ),
            child: Card(
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              // shape: RoundedRectangleBorder(
              //   // borderRadius: BorderRadius.circular(8.0),
              // ),
              child: InkWell(
                onTap: () {
                  onTap(house);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        house.nickname,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        house.country,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        child: TextButton(
                      child: const Text(
                        'Pay Rent',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // TODO: Pay Rent Button Functionality
                      },
                    )),
                  ]),
                ),
              ),
              elevation: 2,
            ),
          );
        }));
  }
}
