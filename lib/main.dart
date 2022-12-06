import 'package:flutter/material.dart';
import 'package:trabalho_final/pages/qrCode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QRCodePage(), //Chama a página de QRCode par inicio
    );
  }
}