import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class Cndetail extends StatefulWidget {
  final String code;
  const Cndetail(this.code, {super.key});
  @override
  State<Cndetail> createState() => _CndetailState();
}

class _CndetailState extends State<Cndetail> {
  final client = OdooClient('https://tps.transbenua.com');
  dynamic listcn;
  Future<dynamic> fetchCN() async {
    final session = await client.authenticate('test_transbenua', 'tbl', 'tbl');
    await client.callKw({
      'model': 'dps.cn.pibk',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['barcode', '=', widget.code]
        ],
        'fields': ['id', 'nama_pengirim', 'nama_penerima', 'barcode'],
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
      body: listcn == null
          ? Text(
              "Data CN Tidak Ditemukan : ${widget.code}",
              style: const TextStyle(fontSize: 18),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  Text("Pengirim : ${listcn[0]['nama_pengirim']}")
                ],
              ),
            ),
    );
  }
}
