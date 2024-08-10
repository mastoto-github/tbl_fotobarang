import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:tbl_fotobarang/screens/check/check.dart';
import 'package:tbl_fotobarang/screens/home/home.dart';
import 'package:tbl_fotobarang/screens/muat/muat.dart';
import 'package:tbl_fotobarang/themes.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final _screens = [const HomePage(), const MuatPage(), const CheckPage()];

  @override
  Widget build(BuildContext context) {
    Widget customNavBar() {
      return BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: bottomNavText,
        unselectedLabelStyle: bottomNavText,
        items: [
          BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Image.asset(
                  'assets/icons/home.png',
                  width: 25,
                  color: _selectedIndex == 0 ? redColor : greyColor,
                ),
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Image.asset(
                  'assets/icons/muat-kemasan.png',
                  width: 25,
                  color: _selectedIndex == 1 ? redColor : greyColor,
                ),
              ),
              label: 'Muat'),
          BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Image.asset(
                  'assets/icons/check-kemasan.png',
                  width: 25,
                  color: _selectedIndex == 2 ? redColor : greyColor,
                ),
              ),
              label: 'Check')
        ],
      );
    }

    return Scaffold(
      //backgroundColor: darkgreyColor,
      bottomNavigationBar: customNavBar(),
      body: Stack(
        children: _screens
            .asMap()
            .map((i, screen) => MapEntry(
                i,
                Offstage(
                  offstage: _selectedIndex != i,
                  child: screen,
                )))
            .values
            .toList(),
      ),
      backgroundColor: darkgreyColor,
    );
  }
}
