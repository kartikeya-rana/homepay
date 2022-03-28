import 'package:flutter/material.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_house_details.dart';
import 'package:homepay/services/cloud/collection/cloud_payment_history_storage.dart';
import 'package:homepay/services/cloud/collection/cloud_rewards_storage.dart';
import 'package:homepay/utilities/dialogs/info_dialog.dart';

class PayRentBottomSheetView extends StatefulWidget {
  const PayRentBottomSheetView({Key? key, required this.house})
      : super(key: key);
  final CloudHouseDetails house;

  @override
  State<PayRentBottomSheetView> createState() => _PayRentBottomSheetViewState();
}

class _PayRentBottomSheetViewState extends State<PayRentBottomSheetView> {
  final _formKey = GlobalKey<FormState>();
  final CloudPaymentHistoryStorage _paymentService =
      CloudPaymentHistoryStorage();
  final CloudRewardsStorage _rewardService = CloudRewardsStorage();
  final currentUser = AuthService.firebase().currentUser!;
  final DateTime now = DateTime.now();
  bool status = true;

  @override
  Widget build(BuildContext context) {
    final house = widget.house;
    String _rentAmount = house.rentAmount.toString();

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
                onPressed: status
                    ? () async {
                        final rentCaptured = int.parse(_rentAmount);

                        setState(() {
                          status = false;
                        });

                        await _paymentService.createNewPayment(
                            userId: currentUser.id,
                            houseId: house.documentId,
                            ownerId: house.ownerId,
                            amountPaid: rentCaptured,
                            paymentDate: now);
                        final rewardDetails = await _rewardService
                            .getRewardDetails(userId: currentUser.id);

                        final int rewardsEarned =
                            rentCaptured + rewardDetails.rewardsEarned;

                        await _rewardService.updateRewards(
                            documentId: rewardDetails.documentId,
                            rewardsUsed: rewardDetails.rewardsUsed,
                            rewardsEarned: rewardsEarned);

                        Navigator.of(context).pop();
                        await showInfoDialog(context, "Rent Paid",
                            "Amount \$ ${rentCaptured.toString()}");
                      }
                    : null,
                child: const Text(
                  'Pay',
                  style: TextStyle(fontSize: 16),
                )),
          ),
        ),
      ],
    );
  }
}
