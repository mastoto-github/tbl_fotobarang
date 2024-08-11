import 'dart:ffi';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';

import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:tbl_fotobarang/main.dart';
import 'package:tbl_fotobarang/screens/input_field.dart';
import 'package:tbl_fotobarang/style.dart';
import 'package:tbl_fotobarang/themes.dart';

class TambahKemasanForm extends StatefulWidget {
  final int vnokms;

  const TambahKemasanForm({super.key, required this.vnokms});

  @override
  _TambahKemasanForm createState() => _TambahKemasanForm();
}

class _TambahKemasanForm extends State<TambahKemasanForm> {
  double _dialogHeight = 0.0;
  double _dialogWidth = Get.width;
  final tNoKemasan = TextEditingController();
  String? snokms;
  dynamic vkode, vreskode;
  dynamic nresp, vresp;
  dynamic listKemasan;

  final client = OdooClient('https://tps.transbenua.com');

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _dialogHeight = Get.height / 4.6;
      });
    });
  }

  Widget build(BuildContext context) {
    Style style = Style();

    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      height: _dialogHeight,
      width: _dialogWidth,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Get.width,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: const Text(
              'Tambah Kemasan Muat',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InputField(
            title: 'Nomor Kemasan',
            isSecured: false,
            tCont: tNoKemasan,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: style.btnStyle(
                    btnWidth: Get.width / 3,
                    btnColor: Color.fromARGB(255, 241, 241, 241)),
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 50), () {
                    setState(() {
                      _dialogHeight = 0;
                    });
                  });

                  await Future.delayed(const Duration(milliseconds: 450));
                  Get.back();
                },
                child: Text(
                  'Batal',
                  style: style.txtStyle(txtColor: blueColor),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 50), () {
                    setState(() {
                      _dialogHeight = 0;
                      snokms = tNoKemasan.text;
                      inputKemasan();
                    });
                  });
                  await Future.delayed(const Duration(milliseconds: 450));
                  Get.back(result: 'Ok');
                },
                style: style.btnStyle(
                    btnWidth: Get.width / 3, btnColor: blueColor),
                child: Text(
                  'Simpan',
                  style: style.txtStyle(txtColor: Colors.white),
                ),
              )
            ],
          )
        ],
      )),
    );
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
        'fields': ['id', 'name', 'no_sppb'],
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

  Future inputKemasan() async {
    vkode = snokms;
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
          autoCloseDuration: const Duration(seconds: 2));
    } else if (vresp == "X") {
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
          type: CoolAlertType.error,
          title: "Berhasil!",
          text: "Data Muat Kemasan Tersimpan",
          autoCloseDuration: const Duration(seconds: 2));
      //setState(() {});
    }
  }

  Future insertMuatIds() async {
    var kemasanId = await orpc.callKw({
      'model': 'dps.muat.ids',
      'method': 'create',
      'args': [
        {'muat_id': widget.vnokms, 'kemasan_id': vreskode[0]['id']},
      ],
      'kwargs': {},
    });
  }
}
