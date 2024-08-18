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
                    'Muat Kemasan',
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
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: jmldata,
                      itemBuilder: (context, index) {
                        final muatdata =
                            snapshot.data[index] as Map<String, dynamic>;
                        return portfolioCardList(muatdata);
                      },
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

  Widget portfolioCardList(Map<String, dynamic> muatdata) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MuatDetil(
                vnopol: muatdata['nopol'].toString(),
                vdriver: muatdata['driver'].toString(),
                vjmlbrg: muatdata['jml_kemasan'],
                vmuatid: muatdata['id']),
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
        child: Expanded(
          child: Row(
            children: [
              SizedBox(
                height: 55,
                width: 55,
                child: CircleAvatar(
                  backgroundColor: kTropicalBlue,
                  child: Image.asset(
                    'assets/icons/muat-kemasan.png',
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
                          muatdata['nopol'].toString(),
                          style: kSubtitle1,
                        ),
                        const Spacer(),
                        Text(
                          muatdata['driver'].toString(),
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
                      percent: 1,
                      progressColor: kBlueRibbon,
                      backgroundColor: kGrey.withOpacity(0.3),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Barang Termuat : ${muatdata['jml_kemasan']}",
                        style: kBody2.copyWith(
                          color: kGrey,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '---',
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
        'limit': 5,
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
