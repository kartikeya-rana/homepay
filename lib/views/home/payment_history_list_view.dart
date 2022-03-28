import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:homepay/services/cloud/collection/cloud_payment_history.dart';
import 'package:intl/intl.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class PaymentHistoryListView extends StatelessWidget {
  const PaymentHistoryListView({Key? key, required this.payments})
      : super(key: key);
  final Iterable<CloudPaymentHistory> payments;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments.elementAt(index);
        final DateFormat formatter = DateFormat('dd-MM-yyyy');

        return Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: primaryColor,
              boxShadow: insideShadow),
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            // shadowColor: secondaryColor,
            // elevation: 1.5,
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              title: Text(
                'Paid \$ ${payment.amountPaid}',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(formatter.format(payment.paymentDate),
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }
}
