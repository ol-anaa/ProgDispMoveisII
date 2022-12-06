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
  String link = ''; //String que vai receber o link escaneado
  //Controller que pega o link digitado caso o QRCode não funcione 
  final TextEditingController _controllerLink = TextEditingController();

  //Função que le o QRCode
  readQRCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );
    setState(() => link = code != '-1' ? code : 'Não validado');

    //Se o link for o de listar os usuário, vai para página de listar usuários
    if (link == 'https://www.slmm.com.br/CTC/getLista.php'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListaUser()),
      );
    }
    //Se o linl for de inserir vai para página de inserir 
    else if (link == 'https://www.slmm.com.br/CTC/insere.php'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CadastrarUser()),
      );
    }
    //Se o usuário clicar em cnscelar volta para página inicial de escanear QRCode
    else if (link == 'cancelar') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QRCodePage()),
      );
    }
    //Se nada funcionar, fala que a url não foi encontrada
    else {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Url não encontrada"),
      ));
    }
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
            //Monta o botão que vai chamar o função de escanear 
            ElevatedButton.icon(
              onPressed: readQRCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4065C3) //define cor
              ),
              icon: const Icon(Icons.qr_code),
              label: const Text('Validar QRCode',
               style: TextStyle(fontSize: 20),),
            ),
            const SizedBox(
              height: 40,
            ),
            //Caso não seja possível escanear o QRCode
            Text("Caso não seja possível a leitura do QRCode, digite: ",
                style: const TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 122, 119, 119),
                ),),
            const SizedBox(
              height: 20,
            ),
            //Controller que recebe o link de onde o usuário quer ir
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
            //Forma o botão que chama a função que valida o link
            Container(
              margin: (const EdgeInsets.only(top: 30, left: 25, right: 25)),
              height: 40,
              width: 120,
              decoration: const BoxDecoration(
                color: Color(0xFF4065C3),
              ),
              child: TextButton(
                child: const Center(
                  child: Text(
                    'Enviar',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                onPressed: () => ValidarLink(), //Chama a função
              ),
            ),
          ],
        ),
      ),
    );
  }

  ValidarLink() {
    //Se o link digitado for o de listar os usuário vai para página de lista
    if (_controllerLink.text == 'https://www.slmm.com.br/CTC/getLista.php') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListaUser()),
      );
    } 
    //Se o link for o de inserir vai para página de inserir usuários
    else if (_controllerLink.text == 'https://www.slmm.com.br/CTC/insere.php') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CadastrarUser()),
      );
    } 
    //Se nenhum desses dois links forem passados, manda uma mensagem que o link é inválido
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Link inválido"),
      ));
    }
  }
}
