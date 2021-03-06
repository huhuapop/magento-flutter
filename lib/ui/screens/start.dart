import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tabs/accounts.dart';
import '../../providers/cart.dart';
import '../tabs/cart.dart';
import '../tabs/home.dart';
import '../tabs/search.dart';
import '../../utils.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    HomeTabs(
      key: PageStorageKey('Home'),
    ),
    SearchTabs(
      key: PageStorageKey('Search'),
    ),
    AccountsTabs(
      key: PageStorageKey('Account'),
    ),
    CartTabs(
      key: PageStorageKey('Cart'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    if (cart.id.isEmpty) {
      getCart(context);
    }
    return Scaffold(
      body: PageStorage(
        child: _tabs[_selectedIndex],
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Customer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
