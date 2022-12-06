import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trabalho_final/pages/detalhesUsuario.dart';
import 'dart:convert';

import '../Services/Usuario.dart';

class ListaUser extends StatefulWidget {
  const ListaUser({Key? key}) : super(key: key);

  @override
  State<ListaUser> createState() => _ListaUser();
}

class _ListaUser extends State<ListaUser> {
  late Future<List<Usuarios>> usuarios; //Inicializa uma lista de usuários
  int id = 0; //Variável que vai guardar o id

  @override
  void initState() {
    super.initState();
    usuarios =
        Coletauser(); //Assim que a página é iniciada chamo o método que pega os dados do usuário
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4065C3), //defino a cor da nav
        title: Text("Lista de Usuários"), //Título da página
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, //Deixo a página ser rolavel na vertical
        child: Center(
          child: FutureBuilder<List<Usuarios>>(
            //Inicio da lista
            future: usuarios,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 810, //Defino um tamanho que a lista vai ter na tela
                  child: ListView.builder(
                      //Aqui definitivamentte eu pego os dados da lista para mostrar na página
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Usuarios usuario = snapshot.data![index];
                        return ListTile(
                          title: Text(usuario.nome!), //Como titulo eu trago o nome do usuário
                          subtitle: Text(usuario.id.toString()), //Como subtitulo eu chamo o id
                          onTap: () {
                            //Quando o usuário clicar em um item da lista ele vai para outra página que
                            //vai mostrar os dados específicos do usuário
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalheUser(), //Vai para página
                                settings: RouteSettings(
                                  arguments: usuario.id, //Envia como argumento o id do usuário clicado
                                ),
                              ),
                            );
                          },
                        );
                      }),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  //Requisição http da lista de usuários
  Future<List<Usuarios>> Coletauser() async {
    var url = Uri.parse('https://www.slmm.com.br/CTC/getLista.php');
    var response = await http.get(url);

    //Se a requisição der certo ele inicia a classe Usuarios com os dados recebidos
    if (response.statusCode == 200) {
      List listaUsuario = json.decode(response.body);
      return listaUsuario.map((e) => Usuarios.fromJson(e)).toList();
    } else {
      throw Exception('Não foi possível carregar os usuários!');
    }
  }
}
