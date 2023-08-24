import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:tbl_fotobarang/pages/cndetail.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override

  //final orpc = OdooClient("https://tps.transbenua.com");
  Future scanbarcode() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#FFFF0000", "Batal", false, ScanMode.BARCODE)
        .then((String kode) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Cndetail(kode)));
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
          //Text(code)
        ],
      )),
    );
  }
}
