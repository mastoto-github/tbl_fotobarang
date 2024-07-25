import 'package:flutter/material.dart';
import 'package:tbl_fotobarang/themes.dart';

class CheckPage extends StatelessWidget {
  const CheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkgreyColor,
      body: Center(
          child: Text(
        'Check Page',
        style: mediumText15,
      )),
    );
  }
}
