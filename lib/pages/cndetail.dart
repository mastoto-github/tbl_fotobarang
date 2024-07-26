import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class Cndetail extends StatefulWidget {
  final String code;
  final int pegawaiId;
  const Cndetail(this.code, this.pegawaiId, {super.key});
  @override
  State<Cndetail> createState() => _CndetailState();
}

class _CndetailState extends State<Cndetail> {
  final client = OdooClient('https://tps.transbenua.com');
  dynamic listcn;
  File? image, image2, image3, image4;
  String? b64String;
  int? periksaId;
  final TextEditingController _lhp = TextEditingController();
  //int? pegawaiId;
  final ImagePicker _picker = ImagePicker();
  final List<File> imgList = [];
  final List<String> b64List = [];

  Future getImage() async {
    final XFile? imagePicked =
        await _picker.pickImage(source: ImageSource.camera);
    image = File(imagePicked!.path);
    var img = await FlutterImageCompress.compressAndGetFile(
      image!.absolute.path,
      '${image!.path}cmp.jpg',
      quality: 70,
    );

    List<int> imageBytes = await img!.readAsBytes();
    b64String = base64Encode(imageBytes);
    //debugPrint(b64String);
    setState(() {
      imgList.add(File(img.path));
      b64List.add(b64String!);
    });
  }

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

  Future<int?> sendPhoto() async {
    int? ret;
    final session =
        await client.authenticate('transbenua', 'admin', 'admindps');
    await client.callKw({
      'model': 'dps.foto.periksa',
      'method': 'create',
      'args': [
        {
          'name': widget.code,
          'cn_id': listcn[0]['id'],
          'pegawai_id': widget.pegawaiId,
          'keterangan': _lhp.text,
        },
      ],
      'kwargs': {},
    }).then((value) {
      if (value != null) {
        periksaId = value;
      }
    });
    //debugPrint('periksaId awal : ${periksaId}');
    //await client.authenticate('testphoto_transbenua', 'admin', 'admindps');
    //int i = 0;
    for (var i = 0; i < b64List.length; i++) {
      await client.callKw({
        'model': 'dps.foto.detail',
        'method': 'create',
        'args': [
          {
            'name': "${widget.code}-$i",
            'periksa_id': periksaId,
            'isi_foto': b64List[i]
          },
        ],
        'kwargs': {},
      }).then((value) {
        ret = i;
      });
    }
    return ret! + 1;
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
        title: const Text('Pemeriksaan Barang'),
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
                          onPressed: () async {
                            await getImage();
                          },
                          child: const Text(
                            "Hasil Periksa",
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
                              child: imgList.isNotEmpty
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
                          onPressed: () async {
                            await sendPhoto().then((value) async {
                              if (value != null) {
                                await CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.success,
                                    text: 'Berhasil Upload $value Foto',
                                    title: 'Sukses',
                                    autoCloseDuration:
                                        const Duration(seconds: 3));
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            });
                          },
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
