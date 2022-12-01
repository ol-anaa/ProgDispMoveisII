import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:trabalho_final/pages/listaUsuarios.dart';

const double _kAlturaSeletorData = 216;

class CadastrarUser extends StatefulWidget {
  const CadastrarUser({Key? key}) : super(key: key);

  @override
  State<CadastrarUser> createState() => _CadastrarUser();
}

class _CadastrarUser extends State<CadastrarUser> {
  String? formattedDate;

  DateTime dateTime = DateTime.now();

  final TextEditingController _controllerNome = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar novo Usuário"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 250, 20, 20),
        child: Form(
          child: Column(
            children: <Widget>[
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
                  initialDateTime: dateTime,
                  onDateTimeChanged: (novaDataEntrega) {
                    setState(() {
                      dateTime = novaDataEntrega;
                      formattedDate =
                          DateFormat('yy/MM/dd HH:mm:ss').format(dateTime);
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
                        'CADASTRE-SE!',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    onPressed: () => submitUser()),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _submitUser() async {
    print(formattedDate);
    print(_controllerNome.text);
  }

  void submitUser() async {
    String URL = "https://www.slmm.com.br/CTC/insere.php";
    var response = await http.post(Uri.parse(URL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nome": _controllerNome.text, "data": formattedDate}));

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
