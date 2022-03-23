import 'package:flutter/material.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';
import 'package:homepay/services/cloud/collection/cloud_payment_history_storage.dart';
import 'package:homepay/services/cloud/collection/cloud_rewards.dart';
import 'package:homepay/services/cloud/collection/cloud_rewards_storage.dart';

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
              image: const DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1507692984170-ff22288b21cf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=985&q=80"),
                fit: BoxFit.cover,
                opacity: 0.9,
              ),
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
                      onPressed: () => payRentButton(context, house),
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

Future<dynamic> payRentButton(BuildContext context, CloudHouseDetails house) {
  final _formKey = GlobalKey<FormState>();
  String _rentAmount = house.rentAmount.toString();

  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            const ListTile(
              // contentPadding: EdgeInsets.all(0),
              leading: Icon(Icons.real_estate_agent_outlined),
              title: Text(
                'Rental Amount',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: _rentAmount,
                  textAlign: TextAlign.center,
                  onChanged: (value) => _rentAmount = value,
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 20),
              child: Center(
                child: ElevatedButton(
                    onPressed: () async {
                      final CloudPaymentHistoryStorage _paymentService =
                          CloudPaymentHistoryStorage();
                      final CloudRewardsStorage _rewardService =
                          CloudRewardsStorage();
                      final currentUser = AuthService.firebase().currentUser!;

                      final DateTime now = DateTime.now();

                      await _paymentService.createNewPayment(
                          userId: currentUser.id,
                          houseId: house.documentId,
                          ownerId: '',
                          amountPaid: int.parse(_rentAmount),
                          paymentDate: now);

                      final rewardDetails = await _rewardService
                          .getRewardDetails(userId: currentUser.id);

                      final int rewardsEarned =
                          int.parse(_rentAmount) + rewardDetails.rewardsEarned;

                      await _rewardService.updateRewards(
                          documentId: rewardDetails.documentId,
                          rewardsUsed: rewardDetails.rewardsUsed,
                          rewardsEarned: rewardsEarned);

                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Pay',
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ),
          ],
        );
      });
}
