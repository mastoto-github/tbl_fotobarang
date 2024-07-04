import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class Cncheck extends StatefulWidget {
  final String code;
  final int pegawaiId;
  const Cncheck(this.code, this.pegawaiId, {super.key});
  @override
  State<Cncheck> createState() => _CncheckState();
}

class _CncheckState extends State<Cncheck> {
  final client = OdooClient('https://tps.transbenua.com');
  dynamic listcn;
  String? b64String;
  int? periksaId;
  final TextEditingController _lhp = TextEditingController();
  //int? pegawaiId;
  final List<File> imgList = [];
  final List<String> b64List = [];

  Future<dynamic> fetchCN() async {
    final session = await client.authenticate('transbenua', 'tbl', 'tbl');
    await client.callKw({
      'model': 'dps.cn.pibk',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['barcode', '=', widget.code]
        ],
        'fields': ['id', 'barcode', 'hasil_periksa'],
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

  @override
  void initState() {
    fetchCN();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check CN'),
        backgroundColor: Colors.blue,
      ),
      body: listcn == null
          ? const Text(
              "Info Data CN :",
              style: TextStyle(fontSize: 18),
            )
          : Center(
              child: Container(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Text("${listcn[0]['barcode']}",
                          style: const TextStyle(fontSize: 20)),
                      Text("Status : ${listcn[0]['hasil_periksa']}",
                          style: const TextStyle(fontSize: 14)),
                      TextButton(
                          onPressed: () async {},
                          child: const Text(
                            "Status Kemasan",
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          )),
                      Expanded(
                          child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              padding: const EdgeInsets.all(10),
                              children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              color: Colors.grey,
                              child: imgList.length > 0
                                  ? SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.file(
                                        imgList[0],
                                        fit: BoxFit.cover,
                                      ))
                                  : Container(),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              color: Colors.grey,
                              child: imgList.length > 1
                                  ? SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.file(
                                        imgList[1],
                                        fit: BoxFit.cover,
                                      ))
                                  : Container(),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              color: Colors.grey,
                              child: imgList.length > 2
                                  ? SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.file(
                                        imgList[2],
                                        fit: BoxFit.cover,
                                      ))
                                  : Container(),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              color: Colors.grey,
                              child: imgList.length > 3
                                  ? SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.file(
                                        imgList[3],
                                        fit: BoxFit.cover,
                                      ))
                                  : Container(),
                            ),
                          ])),
                      TextFormField(
                        minLines: 2,
                        maxLines: 11,
                        controller: _lhp,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            hintText: 'Hasil Pemeriksaan',
                            hintStyle: TextStyle(color: Colors.grey),
                            border:
                                OutlineInputBorder(borderSide: BorderSide())),
                      ),
                      ElevatedButton(
                          onPressed: () async {},
                          child: const Text(
                            "Upload",
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
