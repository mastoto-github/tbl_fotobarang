import 'package:flutter/material.dart';
import 'package:tbl_fotobarang/inputformat.dart';

class InputField extends StatelessWidget {
  String title;
  bool isSecured;
  TextEditingController tCont;

  InputField(
      {required this.title, required this.isSecured, required this.tCont});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            SizedBox(
              height: 1,
            ),
            Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.transparent, width: 0),
                    color: Color.fromARGB(255, 241, 241, 241)),
                child: TextField(
                  controller: tCont,
                  obscureText: isSecured,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: title,
                      hintStyle: TextStyle(color: Colors.grey)),
                  inputFormatters: [UpperCaseTextFormatter()],
                ),
              ),
            )
          ]),
    );
  }
}
