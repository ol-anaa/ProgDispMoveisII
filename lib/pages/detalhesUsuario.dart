import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Services/DadosUser.dart';
import '../Services/Usuario.dart';
import 'package:trabalho_final/pages/qrcode.dart';


class DetalheUser extends StatefulWidget {
  final int? id;
  DetalheUser({Key? key, this.id}) : super(key: key);

  @override
  State<DetalheUser> createState() => _DetalheUser();
}

class _DetalheUser extends State<DetalheUser> {
  late Future<List<DadosUser>> dadosUser;
  int? id;
 
  @override
  void initState() {
    super.initState();     
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ModalRoute.of(context)?.settings.arguments;
    id = usuario as int?; 
    dadosUser = DadosReceb();  
    return Scaffold(
      appBar: AppBar(
        title: Text("Dados específicos do usuário"),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(115, 250, 0, 40),
              child: FutureBuilder<List<DadosUser>>(
                future: dadosUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          DadosUser usuario = snapshot.data![index];
                          return ListTile(
                            title: Text(usuario.nome!),
                            subtitle: Text(usuario.data!),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
          Container(
            margin: (EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10)),
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              color: Color.fromARGB(200, 248, 6, 6),
              borderRadius: BorderRadius.all(
                Radius.circular(32),
              ),
            ),
            child: TextButton(
              child: Center(
                child: Text(
                  'Deletar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () => deletar(),
            ),
          ),
        ],
      ),
    );
  }

  deletar() async {
    var url = Uri.parse('https://www.slmm.com.br/CTC/delete.php?id=${id}');
    var response = await http.delete(url);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Usuário deletado com sucesso!"),
      ));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => QRCodePage(),
        ),
      );
    }
  }

  Future<List<DadosUser>> DadosReceb() async {
    var url = Uri.parse('https://www.slmm.com.br/CTC/getDetalhe.php?id=${id}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List listaUsuario = json.decode(response.body);
      return listaUsuario.map((e) => DadosUser.fromJson(e)).toList();
    } else {
      throw Exception('Não foi possível carregar os usuários!');
    }
  }
}
