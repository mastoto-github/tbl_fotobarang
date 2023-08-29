import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:tbl_fotobarang/main.dart';
import 'package:tbl_fotobarang/pages/cndetail.dart';
import 'package:tbl_fotobarang/pages/testpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  final orpc = OdooClient("https://tps.transbenua.com");
  dynamic listpegawai;
  Pegawai? selectedValue;
  List<Pegawai?> pegawai = [];

  Future scanbarcode() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#FFFF0000", "Batal", false, ScanMode.BARCODE)
        .then((String kode) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Cndetail(kode, selectedValue!.id!)));

      //Navigator.push(
      //    context,
      //    MaterialPageRoute(
      //        builder: (context) => Cndetail('MBA0615', selectedValue!.id!)));
    });
  }

  Future getpegawai() async {
    final session =
        await orpc.authenticate('testphoto_transbenua', 'tbl', 'tbl');
    await orpc.callKw({
      'model': 'dps.pegawai.periksa',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['is_absen', '=', true]
        ],
        'fields': ['id', 'name'],
        'limit': 20,
      },
    }).then((value) {
      if (value != null) {
        setState(() {
          listpegawai = value;
        });
      }
    });
    int? vid;
    String? vname;
    setState(() {
      for (var i = 0; i < listpegawai.length; i++) {
        vid = listpegawai[i]['id'];
        vname = listpegawai[i]['name'];
        pegawai.add(Pegawai(id: vid, name: vname));
      }
    });
  }

  @override
  void initState() {
    getpegawai();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Upload Data Pemeriksaan"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          const Text("Petugas Pemeriksa", style: TextStyle(fontSize: 20)),
          DropdownButton<Pegawai?>(
            value: selectedValue,
            onChanged: (value) async {
              setState(() {
                selectedValue = value;
              });
            },
            items: pegawai
                .map<DropdownMenuItem<Pegawai>>((e) => DropdownMenuItem(
                      value: e,
                      child: Text((e?.name ?? '').toString()),
                    ))
                .toList(),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
              child: const Text(
                "SCAN BARCODE",
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              onPressed: () {
                scanbarcode();
              }),
        ],
      )),
    );
  }
}

class Pegawai {
  int? id;
  String? name;

  Pegawai({this.id, this.name});
}
