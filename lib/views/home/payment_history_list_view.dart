import 'package:flutter/material.dart';
import 'package:homepay/services/cloud/collection/cloud_payment_history.dart';
import 'package:intl/intl.dart';
import 'package:homepay/constants/colors_constants.dart';

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

        return Card(
          color: primaryColor,
          shadowColor: secondaryColor,
          elevation: 1.5,
          child: ListTile(
            title: Text(
              'Paid \$ ${payment.amountPaid}',
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(formatter.format(payment.paymentDate),
                style: const TextStyle(color: Colors.white)),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 1),
    );
  }
}
