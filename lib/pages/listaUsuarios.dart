import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trabalho_final/pages/detalhesUsuario.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/Usuario.dart';

class ListaUser extends StatefulWidget {
  const ListaUser({Key? key}) : super(key: key);

  @override
  State<ListaUser> createState() => _ListaUser();
}

class _ListaUser extends State<ListaUser> {
  late Future<List<Usuarios>> usuarios;
  int id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usuarios = Coletauser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Usuários"),
        ),
        body: Center(
          child: FutureBuilder<List<Usuarios>>(
            future: usuarios,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Usuarios usuario = snapshot.data![index];
                      id = usuario.id!;
                      return ListTile(
                        title: Text(usuario.nome!),
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => DetalheUser()),
                          );
                        },
                        //subtitle: Text(usuario.id!),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const CircularProgressIndicator();
            },
          ),
        ));
  }

  Future<List<Usuarios>> Coletauser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('key', id);
    
    var url = Uri.parse('https://www.slmm.com.br/CTC/getLista.php');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List listaUsuario = json.decode(response.body);
      return listaUsuario.map((e) => Usuarios.fromJson(e)).toList();
    } else {
      throw Exception('Não foi possível carregar os usuários!');
    }
  }
}
