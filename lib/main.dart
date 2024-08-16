import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
// import 'package:tbl_fotobarang/pages/myhomepage2.dart';
import 'package:tbl_fotobarang/screens/bottom_nav_bar.dart';
import 'package:tbl_fotobarang/themes.dart';

// import 'package:tbl_fotobarang/pages/myhomepage.dart';
final orpc = OdooClient("https://tps.transbenua.com");

void main() async {
  await orpc.authenticate('transbenua', 'tbl', 'tbl');
  //final session = await orpc.authenticate('transbenua', 'tbl', 'tbl');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TBL - Pemuatan Barang',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(selectedItemColor: redColor)),
      home: const BottomNavBar(),
    );
  }
}
