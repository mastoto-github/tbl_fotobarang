import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  String code = "";
  String getcode = "";

  Future scanbarcode() async {
    getcode = await FlutterBarcodeScanner.scanBarcode(
        "#FFFF0000", "Batal", false, ScanMode.BARCODE);
    setState(() {
      code = getcode;
    });
  }

  Future<dynamic> fetchContacts() {
    return orpc.callKw({
      'model': 'dps.cn_pibk',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['barcode', '=', code]
        ],
        'fields': ['id', 'name', 'email', '__last_update', 'image_128'],
        'limit': 80,
      },
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Upload Foto Pemeriksaan"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          TextButton(
              child: const Text(
                "SCAN BARCODE",
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              onPressed: () {
                scanbarcode();
              }),
          Text(code)
        ],
      )),
    );
  }
}
