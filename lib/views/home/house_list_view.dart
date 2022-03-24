import 'package:flutter/material.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';
import 'package:homepay/views/home/pay_rent_bottom_sheet_view.dart';

typedef HouseCallback = void Function(CloudHouseDetails house);

class HousesListView extends StatelessWidget {
  const HousesListView({
    Key? key,
    required this.houses,
    required this.onTap,
  }) : super(key: key);

  final HouseCallback onTap;
  final Iterable<CloudHouseDetails> houses;
  // late final TextEditingController _rentAmountController;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: houses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: ((context, index) {
          final house = houses.elementAt(index);
          return Container(
            height: 130,
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
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    secondaryColor,
                    Colors.teal.shade700,
                    primaryColor,
                    Colors.black45,
                    Colors.black87,
                  ]),
            ),
            child: Card(
              shadowColor: Colors.transparent,
              color: Colors.transparent,
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
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
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
                        // payRentButton(context, house);
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return PayRentBottomSheetView(
                                house: house,
                              );
                            });
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
