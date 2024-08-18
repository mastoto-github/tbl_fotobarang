import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tbl_fotobarang/main.dart';
import 'package:tbl_fotobarang/themes.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  dynamic vkode, vreskode;
  dynamic nresp, vresp;
  dynamic listKemasan;
  String vnocn = "", vnokms = "", vsppb = "", vhperiksa = "", vstakhir = "";

  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: kHeading6.copyWith(
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
          vertical: 20,
          horizontal: 30,
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
        child: TextButton(
          onPressed: () {},
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
                'Input Manual',
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
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 30,
        ),
        padding: const EdgeInsets.fromLTRB(15, 19, 15, 14),
        constraints: const BoxConstraints.expand(
          height: 250,
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
                          style: kHeading6,
                        ),
                        const Spacer(),
                        Text(
                          vnocn.isEmpty ? "No CN : --" : "No CN : $vnocn",
                          style: kHeading6,
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
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Hasil Periksa :",
                        style: kBody0.copyWith(
                          color: kGrey,
                        ),
                      ),
                    ),
                    //const Spacer(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        vhperiksa ?? "--",
                        style: kBody0Bold.copyWith(
                          color: kGrey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    //const Spacer(),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Status Akhir :",
                        style: kBody0.copyWith(
                          color: kGrey,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        vstakhir ?? "--",
                        style: kBody0Bold.copyWith(
                          color: kGrey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    //const Spacer(),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "No SPPB :",
                        style: kBody0.copyWith(
                          color: kGrey,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        vsppb ?? "--",
                        style: kBody0Bold.copyWith(
                          color: kGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ]));
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
      // if (vreskode.length > 0) {
      vnocn = vreskode[0]['cn'];
      vnokms = vreskode[0]['name'];
      vsppb = vreskode[0]['no_sppb'];
      vhperiksa = vreskode[0]['hasil_periksa'];
      vstakhir = vreskode[0]['status_akhir'];
      // } else {
      //   vresp = "N";
      // }
    });
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
          'cn',
          'name',
          'no_sppb',
          'hasil_periksa',
          'status_akhir'
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
}
