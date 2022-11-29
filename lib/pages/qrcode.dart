import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:trabalho_final/pages/cadastro.dart';
import 'package:trabalho_final/pages/listaUsuarios.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({Key? key}) : super(key: key);

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  String ticket = '';

  readQRCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );
    setState(() => ticket = code != '-1' ? code : 'Não validado');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (ticket == 'https://www.slmm.com.br/CTC/getLista.php')
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: NavegarLista(),
              ),
            if (ticket == 'https://www.slmm.com.br/CTC/insere.php')
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: InserirLista(),
              ),
            
            ElevatedButton.icon(
              onPressed: readQRCode,
              icon: const Icon(Icons.qr_code),
              label: const Text('Validar'),
            ),
          ],
        ),
      ),
    );
  }

  NavegarLista() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListaUser()),
    );
  }

    InserirLista() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastrarUser()),
    );
  }
}
