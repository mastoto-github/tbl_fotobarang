import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tbl_fotobarang/main.dart';
import 'package:tbl_fotobarang/themes.dart';

import '../input_field.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  dynamic vkode, vreskode;
  dynamic nresp, vresp;
  dynamic listKemasan;
  dynamic vsppb;
  String vnocn = "",
      vnokms = "",
      vhperiksa = "",
      vstakhir = "",
      vgatein = "",
      vhsl = "p2ph";
  dynamic vcnid;
  final tNoKemasan = TextEditingController();
  final List<String> _dropDownItems = ['p2ph', 'p2wh', 'p2pm', 'p2wm'];
  String _selectedItem = 'p2ph';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
            image: const DecorationImage(
              image: AssetImage('assets/images/bg-container-3.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: kGrey,
                blurRadius: 5,
                offset: Offset.fromDirection(2),
              )
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                Text(
                  'Check Kemasan',
                  style: kBody1.copyWith(
                    color: kWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Check Status dan Data CN',
                  style: kSubtitle2.copyWith(
                    color: kWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          child: TextButton(
            onPressed: () async {
              await scanbarcode().then((value) => setState(() {}));
            },
            style: TextButton.styleFrom(
              backgroundColor: kWhite,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              elevation: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  size: 13,
                  color: kLuckyBlue,
                ),
                Text(
                  'Scan Barcode',
                  style: kButton2.copyWith(
                    color: kLuckyBlue,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 30,
          ),
          child: Column(
            children: [
              InputField(
                title: 'Nomor Kemasan',
                isSecured: false,
                tCont: tNoKemasan,
              ),
              TextButton(
                onPressed: () async {
                  await checkmanual().then((value) => setState(() {}));
                  FocusScope.of(context).unfocus();
                },
                style: TextButton.styleFrom(
                  backgroundColor: kWhite,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      size: 13,
                      color: kLuckyBlue,
                    ),
                    Text(
                      'Check Manual',
                      style: kButton2.copyWith(
                        color: kLuckyBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 30,
          ),
          padding: const EdgeInsets.fromLTRB(15, 19, 15, 14),
          constraints: const BoxConstraints.expand(
            height: 310,
          ),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: kGrey,
                blurRadius: 1,
                offset: Offset.fromDirection(1, 2),
              )
            ],
          ),
          child: Expanded(
            child: Row(
              children: [
                SizedBox(
                  height: 45,
                  width: 45,
                  child: CircleAvatar(
                    backgroundColor: kTropicalBlue,
                    child: Image.asset(
                      'assets/icons/kemasan.png',
                      width: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            vnokms ?? "--",
                            style: kBody1,
                          ),
                          const Spacer(),
                          Text(
                            vnocn.isEmpty ? "No CN : --" : "No CN : $vnocn",
                            style: kBody1,
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      LinearPercentIndicator(
                        lineHeight: 4,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        percent: 1,
                        progressColor: kBlueRibbon,
                        backgroundColor: kGrey.withOpacity(0.3),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Hasil Periksa :",
                              style: kBody1.copyWith(
                                color: kGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //const Spacer(),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              vhperiksa ?? "--",
                              style: kBody1.copyWith(
                                color: kGrey,
                              ),
                            ),
                          ),
                          const Spacer(),
                          DropdownButton(
                            value: _selectedItem,
                            style: kBody1.copyWith(color: kGrey),
                            items: _dropDownItems.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedItem = value!;
                                vhsl = _selectedItem;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: TextButton(
                              onPressed: () async {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    text: "Ubah Hasil Periksa ?",
                                    confirmBtnText: "Ya",
                                    cancelBtnText: "Tidak",
                                    confirmBtnColor: Colors.green,
                                    onConfirmBtnTap: () async {
                                      try {
                                        await updateHasilPeriksa();
                                        // ignore: use_build_context_synchronously
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            title: "Berhasil!",
                                            text: "Hasil Periksa Diubah",
                                            autoCloseDuration:
                                                const Duration(seconds: 2));
                                      } catch (e) {
                                        // ignore: use_build_context_synchronously
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            title: "Gagal!",
                                            text: "Gagal Merubah",
                                            autoCloseDuration:
                                                const Duration(seconds: 2));
                                      }
                                      // ignore: use_build_context_synchronously
                                    });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: kWhite,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                elevation: 4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    size: 13,
                                    color: kLuckyBlue,
                                  ),
                                  Text(
                                    'Ubah',
                                    style: kButton2.copyWith(
                                      color: kLuckyBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      //const Spacer(),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Status Akhir :",
                          style: kBody1.copyWith(
                            color: kGrey,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          vstakhir ?? "--",
                          style: kBody1.copyWith(
                            color: kGrey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      //const Spacer(),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "No SPPB :",
                              style: kBody1.copyWith(
                                color: kGrey,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Gate In :",
                              style: kBody1.copyWith(
                                color: kGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              vsppb ?? "--",
                              style: kBody1.copyWith(
                                color: kGrey,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              vgatein ?? "--",
                              style: kBody1.copyWith(
                                color: kGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ])),
    );
  }

  Future scanbarcode() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#FFFF0000", "Kembali", false, ScanMode.BARCODE)
        .then((String kode) async {
      setState(() {
        vkode = kode.toUpperCase();
      });
      //print(vkode);
      vreskode = await fetchKemasan();
      if (vreskode.length > 0) {
        vnocn = vreskode[0]['cn'];
        vcnid = vreskode[0]['cn_id'][0];
        vnokms = vreskode[0]['name'];
        if (vsppb is String) {
          vsppb = vsppb;
        } else {
          vsppb = "--";
        }
        vhperiksa = vreskode[0]['hasil_periksa'];
        vstakhir = vreskode[0]['status_akhir'];
        vgatein = vreskode[0]['waktu_gatein'];
      } else {
        vnocn = "--";
        vnokms = "--";
        vsppb = "Kemasan td ditemukan";
        vhperiksa = "Kemasan td ditemukan";
        vstakhir = "Kemasan td ditemukan";
        vgatein = "Kemasan tdk ditemukan";
      }
    });
  }

  Future checkmanual() async {
    setState(() {
      vkode = tNoKemasan.text.toUpperCase();
    });
    //print(vkode);
    vreskode = await fetchKemasan();

    //print(listcn[0]['end_respon']);
    // if (vreskode.length > 0) {
    if (vreskode.length > 0) {
      vnocn = vreskode[0]['cn'];
      vcnid = vreskode[0]['cn_id'][0];
      vnokms = vreskode[0]['name'];
      vsppb = vreskode[0]['no_sppb'];
      vgatein = vreskode[0]['waktu_gatein'];
      if (vsppb is String) {
        vsppb = vsppb;
      } else {
        vsppb = "--";
      }
      vhperiksa = vreskode[0]['hasil_periksa'];
      vstakhir = vreskode[0]['status_akhir'];
    } else {
      vnocn = "--";
      vnokms = "--";
      vsppb = "Kemasan tdk ditemukan";
      vhperiksa = "Kemasan tdk ditemukan";
      vstakhir = "Kemasan tdk ditemukan";
      vgatein = "Kemasan tdk ditemukan";
    } // } else {
    //   vresp = "N";
    // }
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
        'fields': [
          'id',
          'cn_id',
          'cn',
          'name',
          'no_sppb',
          'hasil_periksa',
          'status_akhir',
          'waktu_gatein'
        ],
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

  Future updateHasilPeriksa() async {
    var kemasanId = await orpc.callKw({
      'model': 'dps.cn.pibk',
      'method': 'write',
      'args': [
        vcnid,
        {'hasil_periksa': vhsl},
      ],
      'kwargs': {},
    });
  }
}
