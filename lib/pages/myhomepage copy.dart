import 'package:cool_alert/cool_alert.dart';
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
  dynamic vkode, vreskode;
  dynamic nresp;
  List<Pegawai?> pegawai = [];
  // final client = OdooClient('https://tps.transbenua.com');
  dynamic listcn;

  Future scanbarcode() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#FFFF0000", "Batal", false, ScanMode.BARCODE)
        .then((String kode) async {
      setState(() {
        vkode = kode;
      });
      //print(vkode);
      vreskode = await fetchCN();
      //print(listcn[0]['end_respon']);
      nresp = listcn[0]['end_respon'] ?? "NNN";
      nresp = nresp?[0];
      if (nresp == "4") {
        // ignore: use_build_context_synchronously
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: listcn[0]['end_respon'],
            text: "$vkode : Barang sudah dapat dikeluarkan");
      } else if (nresp == "N") {
        // ignore: use_build_context_synchronously
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Tidak ditemukan!",
            text: "Data barang tidak ditemukan di aplikasi");
      } else {
        // ignore: use_build_context_synchronously
        CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            title: listcn[0]['end_respon'],
            text: "$vkode : Barang belum dapat dikeluarkan");
      }
    });
  }

  Future<dynamic> fetchCN() async {
    final session = await orpc.authenticate('transbenua', 'tbl', 'tbl');
    await orpc.callKw({
      'model': 'dps.cn.pibk',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['name', '=', vkode]
        ],
        'fields': ['no_master', 'nama_penerima', 'end_respon'],
        'limit': 2,
      },
    }).then((value) {
      if (value != null) {
        setState(() {
          listcn = value;
        });
      }
    });
    return listcn;
  }

  Future getpegawai() async {
    final session = await orpc.authenticate('transbenua', 'tbl', 'tbl');
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

  dynamic? kurs;
  Future getkurs() async {
    final session = await orpc.authenticate('transbenua', 'tbl', 'tbl');
    var res = await orpc.callKw({
      'model': 'dps.shipment',
      'method': 'getkurs',
      'args': ['read'],
      'kwargs': {},
    });

    int? vid;
    String? vname;
    setState(() {
      kurs = res;
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
        title: const Text("Check Pengeluaran Barang"),
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
              onPressed: () async {
                await scanbarcode();

                //await getkurs();
              }),
          //Text('Kurs: $kurs')
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
