import 'package:flutter/material.dart';
import 'package:trabalho_final/pages/detalhesUsuario.dart';
import 'package:trabalho_final/pages/listaUsuarios.dart';
import 'package:trabalho_final/pages/qrCode.dart';
import 'package:trabalho_final/pages/cadastro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QRCodePage(),
    );
  }
}