import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:tbl_fotobarang/screens/input_field.dart';
import 'package:tbl_fotobarang/style.dart';
import 'package:tbl_fotobarang/themes.dart';

class TambahKemasanForm extends StatefulWidget {
  @override
  _TambahKemasanForm createState() => _TambahKemasanForm();
}

class _TambahKemasanForm extends State<TambahKemasanForm> {
  double _dialogHeight = 0.0;
  double _dialogWidth = Get.width;
  final tNoKemasan = TextEditingController(); 
  String? snokms;
  final client = OdooClient('https://tps.transbenua.com');

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _dialogHeight = Get.height / 2.7;
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
            title: 'Nomor Polisi',
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
                      insertMuatIds();
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

  Future<int?> sendMuat() async {
    int? ret;
    final session = await client.authenticate('tbl_test', 'tbl', 'tbl');
    await client.callKw({
      'model': 'dps.muat',
      'method': 'create',
      'args': [
        {
          'nopol': snokms,
          'driver': sdriver,
          'tujuan_muat': stujuan ?? '',
        },
      ],
      'kwargs': {},
    }).then((value) {
      if (value != null) {
        ret = value;
      }
    });
    //debugPrint('periksaId awal : ${periksaId}');

    return ret;
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
}
