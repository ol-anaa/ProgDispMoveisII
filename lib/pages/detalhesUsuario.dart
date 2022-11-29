import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Services/DadosUser.dart';

class DetalheUser extends StatefulWidget {
  const DetalheUser({Key? key}) : super(key: key);

  @override
  State<DetalheUser> createState() => _DetalheUser();
}

class _DetalheUser extends State<DetalheUser> {
  late Future<List<DadosUser>> dadosUser;

  @override
  void initState() {
    super.initState();
    dadosUser = DadosReceb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dados específicos do usuário"),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(125, 250, 0, 40),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => deletar(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  deletar() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('key') ?? 0;

    var url = Uri.parse('https://www.slmm.com.br/CTC/delete.php?id=${id}');
    var response = await http.delete(url);
    if (response.statusCode == 200) {
      List listaUsuario = json.decode(response.body);
      return listaUsuario.map((e) => DadosUser.fromJson(e)).toList();
    } else {
      throw Exception('Não foi possível carregar os usuários!');
    }
  }

  Future<List<DadosUser>> DadosReceb() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('key') ?? 0;

    var url = Uri.parse('https://www.slmm.com.br/CTC/getDetalhe.php?id=15');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List listaUsuario = json.decode(response.body);
      return listaUsuario.map((e) => DadosUser.fromJson(e)).toList();
    } else {
      throw Exception('Não foi possível carregar os usuários!');
    }
  }
}
