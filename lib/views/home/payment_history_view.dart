import 'package:flutter/material.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_payment_history.dart';
import 'package:homepay/services/cloud/collection/cloud_payment_history_storage.dart';
import 'package:homepay/views/home/payment_history_list_view.dart';

class PaymentHistoryView extends StatefulWidget {
  const PaymentHistoryView({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryView> createState() => _PaymentHistoryViewState();
}

class _PaymentHistoryViewState extends State<PaymentHistoryView> {
  late final CloudPaymentHistoryStorage _paymentService;
  final currentUser = AuthService.firebase().currentUser!;

  @override
  void initState() {
    _paymentService = CloudPaymentHistoryStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: StreamBuilder(
          stream: _paymentService.allPayments(userId: currentUser.id),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final payments =
                      snapshot.data as Iterable<CloudPaymentHistory>;
                  return PaymentHistoryListView(payments: payments);
                } else {
                  return Container();
                }
              default:
                return Container();
            }
          },
        )),
      ],
    );
  }
}
