import 'package:flutter/material.dart';
import 'package:homepay/views/home/card_view.dart';
import 'package:homepay/views/home/payment_history_view.dart';
import 'package:homepay/views/home/reward_view.dart';

const List<Widget> _pages = <Widget>[
  CardView(),
  PaymentHistoryView(),
  RewardView(),
];

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Pay')),
      body: Center(
        child: _pages.elementAt(_currentIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), label: 'History'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.star_rate_rounded), label: 'Rewards'),
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
