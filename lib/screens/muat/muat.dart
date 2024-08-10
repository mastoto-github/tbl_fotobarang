import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tbl_fotobarang/main.dart';
import 'package:tbl_fotobarang/screens/muat/muat_detil.dart';
import 'package:tbl_fotobarang/screens/muat/signin_form.dart';
import 'package:tbl_fotobarang/themes.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class MuatPage extends StatefulWidget {
  const MuatPage({super.key});

  @override
  State<MuatPage> createState() => _MuatPageState();
}

class _MuatPageState extends State<MuatPage> {
  @override
  //final orpc = OdooClient("https://tps.transbenua.com");

  dynamic listmuat;
  dynamic dnopol;

  @override
  void initState() {
    super.initState();
    // getmuat();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
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
                    'Muat Barang',
                    style: kHeading6.copyWith(
                      color: kWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Pengeluaran Barang',
                    style: kSubtitle2.copyWith(
                      color: kWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<dynamic>(
              future: getmuat(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  int jmldata = snapshot.data!.length;
                  return Container(
                    child: Column(
                      children: [
                        _portfolioCardList(
                            snapshot.data[0]['id'],
                            'assets/icons/muat-kemasan.png',
                            snapshot.data[0]['nopol'],
                            snapshot.data[0]['driver'],
                            0.3,
                            snapshot.data[0]['jml_kemasan'],
                            '31 Juli 2024 12:00',
                            jmldata.toString()),
                        _portfolioCardList(
                            jmldata > 1 ? snapshot.data[1]['id'] : 0,
                            'assets/icons/muat-kemasan.png',
                            jmldata > 1 ? snapshot.data[1]['nopol'] : '--',
                            jmldata > 1 ? snapshot.data[1]['driver'] : '--',
                            0.3,
                            jmldata > 1 ? snapshot.data[1]['jml_kemasan'] : 0,
                            '31 Juli 2024 12:00',
                            '31 Juli 2024 15:00'),
                        _portfolioCardList(
                            jmldata > 2 ? snapshot.data[2]['id'] : 0,
                            'assets/icons/muat-kemasan.png',
                            jmldata > 2 ? snapshot.data[2]['nopol'] : '--',
                            jmldata > 2 ? snapshot.data[2]['driver'] : '--',
                            0.3,
                            jmldata > 2 ? snapshot.data[2]['jml_kemasan'] : 0,
                            '31 Juli 2024 12:00',
                            '31 Juli 2024 15:00'),
                        _portfolioCardList(
                            jmldata > 3 ? snapshot.data[3]['id'] : 0,
                            'assets/icons/muat-kemasan.png',
                            jmldata > 3 ? snapshot.data[3]['nopol'] : '--',
                            jmldata > 3 ? snapshot.data[3]['driver'] : '--',
                            0.3,
                            jmldata > 3 ? snapshot.data[3]['jml_kemasan'] : 0,
                            '31 Juli 2024 12:00',
                            '31 Juli 2024 15:00'),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    //padding: EdgeInsets.all(20),
                    child: Text('Belum ada data'),
                  );
                }
              }),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            child: TextButton(
              onPressed: () {
                _showAnimatedDialog(context, SigninForm());
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
                    'muat baru',
                    style: kButton2.copyWith(
                      color: kLuckyBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _portfolioCardList(
    int idmuat,
    String icon,
    String title,
    String driver,
    double percent,
    int amount,
    String timein,
    String timeout,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MuatDetil(
                vnopol: title,
                vdriver: driver,
                vjmlbrg: amount,
                vmuatid: idmuat),
          ),
        ).then((value) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        padding: const EdgeInsets.fromLTRB(15, 19, 15, 14),
        constraints: const BoxConstraints.expand(
          height: 120,
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
        child: Row(
          children: [
            SizedBox(
              height: 55,
              width: 55,
              child: CircleAvatar(
                backgroundColor: kTropicalBlue,
                child: Image.asset(
                  icon,
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
                  Row(
                    children: [
                      Text(
                        title,
                        style: kSubtitle1,
                      ),
                      const Spacer(),
                      Text(
                        driver,
                        style: kSubtitle2,
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
                    percent: percent,
                    progressColor: kBlueRibbon,
                    backgroundColor: kGrey.withOpacity(0.3),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Barang Termuat : $amount",
                      style: kBody2.copyWith(
                        color: kGrey,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      timeout,
                      style: kCaption.copyWith(
                        color: kLightGray,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> getmuat() async {
    //final session = await orpc.authenticate('tbl_test', 'tbl', 'tbl');
    return await orpc.callKw({
      'model': 'dps.muat',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': ['id', 'name', 'nopol', 'driver', 'state', 'jml_kemasan'],
        'limit': 4,
        'order': 'id desc'
      },
      //}).then((value) {
      //  if (value != null) {
      // setState(() {
      //    listmuat = value;
      // });
      //    return listmuat;
      // }
    });

    //int? vid;
    //String? vname;
    //setState(() {
    //for (var i = 0; i < listmuat.length; i++) {
    //dnopol[i] = listmuat[i]['id'];
    //vkdmuat = listmuat[i]['name'];
    //}
    //}
    //);
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
}
