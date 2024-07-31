import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Style {
  btnStyle({required Color btnColor, required double btnWidth}) {
    return ButtonStyle(
        elevation: MaterialStateProperty.all(5),
        fixedSize: MaterialStateProperty.all(Size(btnWidth, 50)),
        backgroundColor: MaterialStateColor.resolveWith((states) => btnColor));
  }

  txtStyle({required Color txtColor}) {
    return TextStyle(color: txtColor);
  }
}
