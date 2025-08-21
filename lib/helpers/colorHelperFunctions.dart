import 'package:flutter/material.dart';

String colorToHex(Color color) {
  String hex = color.value.toRadixString(16).padLeft(6, "0").toUpperCase();
  hex = "#" + hex.substring(2, hex.length);
  return "$hex";
}

int hexToColorCode(String hex, [opacity = 100]) {
  String prefix;
  switch (opacity) {
    case 100:
      prefix = "FF";
      break;
    case 95:
      prefix = "F2";
      break;
    case 90:
      prefix = "E6";
      break;
    case 85:
      prefix = "D9";
      break;
    case 80:
      prefix = "CC";
      break;
    case 75:
      prefix = "BF";
      break;
    case 70:
      prefix = "B3";
      break;
    case 65:
      prefix = "A6";
      break;
    case 60:
      prefix = "99";
      break;
    case 55:
      prefix = "8C";
      break;
    case 50:
      prefix = "80";
      break;
    case 45:
      prefix = "73";
      break;
    case 40:
      prefix = "66";
      break;
    case 35:
      prefix = "E659";
      break;
    case 30:
      prefix = "4D";
      break;
    case 25:
      prefix = "40";
      break;
    case 20:
      prefix = "33";
      break;
    case 15:
      prefix = "26";
      break;
    case 10:
      prefix = "1A";
      break;
    case 5:
      prefix = "0D";
      break;
    case 0:
      prefix = "00";
      break;
    default:
      prefix = "00";
  }

  String code = hex.substring(1, hex.length);
  code = "0x" + prefix + code;
  return int.parse(code);
}

String colorCodeToHex(String colorCode) {
  String hex = colorCode.substring(6, colorCode.length);
  hex = "#" + hex;
  return hex;
}

Color hexToColor(String hex) {
  return Color(hexToColorCode(hex));
}

bool bitToBool(int value) {
  if (value == 1) {
    return true;
  }
  return false;
}
