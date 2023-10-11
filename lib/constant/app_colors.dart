import 'package:flutter/material.dart';

const primaryColor = Color(0xFF182427);
const secondaryColor = Color(0xFF1D7B58);
const colorDarkRed = Color(0xFF5E2829);
const colorGrey = Color(0xFF5C6567);
const colorGreyLight = Color(0xFF8B9192);
const colorGreyLight2 = Color(0xFFD0D3D3);
const colorGreyLight3 = Color(0xFFEFEFEF);
const colorGreyLight4 = Color(0xFFF7F7F7);
const colorWhite = Color(0xFFFFFFFF);
const colorCounter = Color(0xFF9F7115);
const colorGreen = Color(0xFF1D7B58);
const colorRed = Color(0xFFDF0000);
const colorTransparent = Colors.transparent;

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}