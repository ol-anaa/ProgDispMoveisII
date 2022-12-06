import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trabalho_final/pages/listaUsuarios.dart';

class CadastrarUser extends StatefulWidget {
  const CadastrarUser({Key? key}) : super(key: key);

  @override
  State<CadastrarUser> createState() => _CadastrarUser();
}

class _CadastrarUser extends State<CadastrarUser> {
  String? formattedDate; //String que vai receber a data formatada
  DateTime dateTime = DateTime.now(); //Inicio dateTime com a data e hora atual
  double _kAlturaSeletorData =
      216; //Seletor que define a altura do campo de data
  //Controller que vai pegar o nome do usuário
  final TextEditingController _controllerNome = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4065C3), //Cor da nav
        title: Text("Cadastrar novo Usuário"), //Título da página
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 150, 20, 20),
          child: Form(
            child: Column(
              children: <Widget>[
                //Aqui começa o form, o campo em qustão  permite que o usúario digite o nome
                TextFormField(
                  controller: _controllerNome,
                  autofocus: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.account_circle, size: 30.0),
                    labelText: "Nome",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                //Aqui começo a formar o campo que seleciona a data
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        Icon(
                          CupertinoIcons.clock,
                          color: CupertinoColors.lightBackgroundGray,
                          size: 28,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Data Cadastro',
                          style: TextStyle(color: CupertinoColors.inactiveGray),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat.yMMMd().add_Hm().format(dateTime),
                      style: TextStyle(color: CupertinoColors.inactiveGray),
                    ),
                  ],
                ),
                Container(
                  height: _kAlturaSeletorData,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: dateTime, //Define a data em que começa
                    onDateTimeChanged: (novaDataSelecionada) {
                      setState(() {
                        dateTime =
                            novaDataSelecionada; //Minha váriavel global recebe o que foi selecionado
                        //Formato da data e a hora da maneira adequada
                        formattedDate =
                            DateFormat('yy/MM/dd HH:mm:ss').format(dateTime);
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //Botão que chama a função para inserir
                Container(
                  margin: (const EdgeInsets.only(top: 10, left: 25, right: 25)),
                  height: 55,
                  width: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4065C3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: TextButton(
                    child: const Center(
                      child: Text(
                        'Cadastre-se!',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    onPressed: () => submitUser(), //Chamo a função que fará o post
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Função de requisição http post
  void submitUser() async {
    String URL = "https://www.slmm.com.br/CTC/insere.php"; //Defino URL
    //Começo verdadeiramente a requisição
    var response = await http.post(Uri.parse(URL),
        headers: {"Content-Type": "application/json"},
        body: //Recebe os parametros de nome e data formatada
            jsonEncode({"nome": _controllerNome.text, "data": formattedDate})); 

    //Se o post funiconar, vai para a página de listar todos os usuários 
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ListaUser(),
        ),
      );
    } else {
      throw Exception('Erro inesperado');
    }
  }
}
