import 'package:flutter/material.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:homepay/constants/routes.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/utilities/dialogs/logout_dialog.dart';
import 'package:homepay/views/home/house_view.dart';
import 'package:homepay/views/home/payment_history_view.dart';
import 'package:homepay/views/home/reward_view.dart';
import 'package:url_launcher/url_launcher.dart';

AppBar homeAppBar(BuildContext context) {
  const feedbackFormUrl = 'https://forms.gle/rw1eBPy25VfrY7qq5';

  return AppBar(
    // toolbarHeight: 20,
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(addNewHouseRoute);
        },
        child: const Text(
          'Add Rental',
          style: TextStyle(fontSize: 16),
        ),
      ),
      PopupMenuButton(
          color: popUpMenuColor,
          elevation: 10,
          padding: const EdgeInsets.all(0),
          icon: const Icon(Icons.keyboard_double_arrow_down_rounded),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        final isLogout = await showLogOutDialog(context);
                        if (isLogout) {
                          AuthService.firebase().logOut();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute, (route) => false);
                        }
                      },
                    )),
                PopupMenuItem(
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.feed,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Feedback',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await launch(feedbackFormUrl);
                      },
                    ))
              ])
    ],
  );
}

AppBar emptyAppBar() {
  return AppBar(
    toolbarHeight: 10,
  );
}

class BaseView extends StatefulWidget {
  const BaseView({Key? key}) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int _currentIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HouseView(),
    const PaymentHistoryView(),
    const RewardView(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<AppBar> _appBar = <AppBar>[
      homeAppBar(context),
      emptyAppBar(),
      emptyAppBar()
    ];

    return Scaffold(
      appBar: _appBar.elementAt(_currentIndex),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: _pages.elementAt(_currentIndex), //New
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.fort), label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on), label: 'History'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.offline_bolt_sharp), label: 'Rewards'),
          ],
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
      ),
    );
  }
}
