import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class MuatDetil extends StatelessWidget {
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
                    vnopol,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    vdriver,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Kemasan terangkut : $vjmlbrg',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
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
                  return Container(
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
    return ListTile(
      leading: Text(record['id'].toString()),
      title: Text(record['kemasan_id'].toString()),
      subtitle: Text(record['id'].toString()),
    );
  }

  Future<dynamic> getDetilMuat() async {
    final orpc = OdooClient("https://tps.transbenua.com");
    final session = await orpc.authenticate('tbl_test', 'tbl', 'tbl');
    return await orpc.callKw({
      'model': 'dps.muat.ids',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['muat_id', '=', vmuatid]
        ],
        'fields': ['id', 'kemasan_id'],
        'limit': 400,
      },
    });
    final int a = 1;
  }
}
