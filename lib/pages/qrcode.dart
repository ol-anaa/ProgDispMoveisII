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
  final TextEditingController _controllerLink = TextEditingController();

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
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
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
              label: const Text('Validar QRCode'),
            ),
            const SizedBox(
              height: 30,
            ),
            Text("Caso não seja possível a leitura do QRCode, digite: ",
                style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 122, 119, 119),
                ),),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _controllerLink,
              autofocus: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.insert_link, size: 30.0),
                labelText: "Link",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: const TextStyle(fontSize: 20),
            ),

            Container(
              margin: (const EdgeInsets.only(top: 30, left: 25, right: 25)),
              height: 55,
              width: 150,
              decoration: const BoxDecoration(
                color: Color(0xFF4065C3),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: TextButton(
                child: const Center(
                  child: Text(
                    'Enviar',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                onPressed: () => ValidarLink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ValidarLink() {
    if (_controllerLink.text == 'https://www.slmm.com.br/CTC/getLista.php') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListaUser()),
      );
    } else if (_controllerLink.text == 'https://www.slmm.com.br/CTC/insere.php') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CadastrarUser()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Link inválido"),
      ));
    }
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
