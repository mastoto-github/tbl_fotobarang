import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:tbl_fotobarang/main.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:tbl_fotobarang/screens/muat/tambahkemasan_form.dart';

class MuatDetil extends StatefulWidget {
  final String vnopol;
  final String vdriver;
  final int vjmlbrg;
  final int vmuatid;

  const MuatDetil(
      {super.key,
      required this.vnopol,
      required this.vdriver,
      required this.vjmlbrg,
      required this.vmuatid});

  @override
  State<MuatDetil> createState() => _MuatDetilState();
}

class _MuatDetilState extends State<MuatDetil> {
  dynamic vkode, vreskode;
  dynamic nresp, vresp;
  dynamic listKemasan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Muat')),
      body: Column(
        children: [
          // Header section
          Container(
            color: Colors.blueAccent,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.vnopol,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Driver : ' + widget.vdriver,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Kemasan terangkut : ${widget.vjmlbrg}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.green.shade500),
                          onPressed: () async {
                            await scanbarcode()
                                .then((value) => setState(() {}));
                          },
                          child: const Text(
                            "Tambah Kemasan (Barcode)",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.green.shade500),
                          onPressed: () async {
                            _showAnimatedDialog(context,
                                TambahKemasanForm(vnokms: widget.vmuatid));
                          },
                          child: const Text(
                            "Tambah Kemasan (Manual)",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          FutureBuilder<dynamic>(
              future: getDetilMuat(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  int jmldata = snapshot.data!.length;
                  return Expanded(
                      child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final record =
                          snapshot.data[index] as Map<String, dynamic>;
                      return buildListDetil(record);
                    },
                  ));
                } else {
                  return Container(
                    //padding: EdgeInsets.all(20),
                    child: Text('Belum ada data'),
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget buildListDetil(Map<String, dynamic> record) {
    final spt = record['kemasan_id'].toString();
    final gatein = record['waktu_gatein'].toString();
    List<String> pisah = spt.split(", ");
    String nokms = pisah[1].replaceAll("]", "");
    //nokms = nokms.replaceAll(" ", "");
    return ListTile(
      leading: Image.asset(
        'assets/icons/kemasan.png',
        width: 19,
      ),
      title: Text('$nokms -- No SPPB : ${record['no_sppb']}'),
      subtitle: Text(
          "${record['nama_penerima']} -- Gate In : ${record['waktu_gatein']}"),
    );
  }

  Future<dynamic> getDetilMuat() async {
    //final orpc = OdooClient("https://tps.transbenua.com");
    //final session = await orpc.authenticate('tbl_test', 'tbl', 'tbl');
    return await orpc.callKw({
      'model': 'dps.muat.ids',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['muat_id', '=', widget.vmuatid]
        ],
        'fields': [
          'id',
          'kemasan_id',
          'no_sppb',
          'nama_penerima',
          'waktu_gatein'
        ],
        'limit': 400,
      },
    });
    final int a = 1;
  }

  Future<dynamic> fetchKemasan() async {
    await orpc.callKw({
      'model': 'dps.kemasan',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['name', '=', vkode]
        ],
        'fields': ['id', 'name', 'no_sppb', 'waktu_gatein'],
        'limit': 1,
      },
    }).then((value) {
      if (value != null) {
        setState(() {
          listKemasan = value;
        });
      } else {
        setState(() {
          listKemasan = "0";
        });
      }
    });
    return listKemasan;
  }

  Future insertMuatIds() async {
    var kemasanId = await orpc.callKw({
      'model': 'dps.muat.ids',
      'method': 'create',
      'args': [
        {'muat_id': widget.vmuatid, 'kemasan_id': vreskode[0]['id']},
      ],
      'kwargs': {},
    });
  }

  void _showAnimatedDialog(BuildContext context, var val) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: val,
          );
        }).then((value) => setState(() {}));
  }

  Future scanbarcode() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#FFFF0000", "Kembali", false, ScanMode.BARCODE)
        .then((String kode) async {
      setState(() {
        vkode = kode;
      });
      //print(vkode);
      vreskode = await fetchKemasan();
      //print(listcn[0]['end_respon']);
      if (vreskode.length > 0) {
        vresp = vreskode[0]['no_sppb'] ?? "X";
      } else {
        vresp = "N";
      }

      if (vresp == "N") {
        FlutterBeep.beep(false);
        // ignore: use_build_context_synchronously
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Tidak ditemukan!",
            text: "Data kemasan tidak ditemukan di aplikasi",
            autoCloseDuration: const Duration(seconds: 4));
      } else if (vresp == "X" || vresp == "false") {
        FlutterBeep.beep(false);
        // ignore: use_build_context_synchronously
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Belum Dapat Dimuat!",
            text: "Kemasan belum mendapatkan SPPB",
            autoCloseDuration: const Duration(seconds: 2));
      } else {
        await insertMuatIds();
        FlutterBeep.beep();
        // ignore: use_build_context_synchronously
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: "Berhasil!",
            text: "Data Muat Kemasan Tersimpan",
            autoCloseDuration: const Duration(seconds: 2));
        //setState(() {});
      }
      //nresp = vresp?[0];
      // if (nresp == "4") {
      //   // ignore: use_build_context_synchronously
      //   CoolAlert.show(
      //     context: context,
      //     type: CoolAlertType.confirm,
      //     title: "$vkode : Barang sudah dapat dikeluarkan",
      //     text: "Rekam pengeluaran ?",
      //     confirmBtnText: 'Ya',
      //     cancelBtnText: 'Tidak',
      //     confirmBtnColor: Colors.green,
      //     onConfirmBtnTap: () {},
      //   );
      // } else if (nresp == "N") {
      //   // ignore: use_build_context_synchronously
      //   CoolAlert.show(
      //       context: context,
      //       type: CoolAlertType.error,
      //       title: "Tidak ditemukan!",
      //       text: "Data barang tidak ditemukan di aplikasi",
      //       autoCloseDuration: const Duration(seconds: 2));
      // } else {
      //   // ignore: use_build_context_synchronously
      //   CoolAlert.show(
      //       context: context,
      //       type: CoolAlertType.warning,
      //       title: listKemasan[0]['end_respon'],
      //       text: "$vkode : Barang belum dapat dikeluarkan",
      //       autoCloseDuration: const Duration(seconds: 3));
      // }
    });
  }
}
