import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trabalho_final/pages/listaUsuarios.dart';
import '../Services/DadosUser.dart';

class DetalheUser extends StatefulWidget {
  final int? id;
  DetalheUser({Key? key, this.id}) : super(key: key);

  @override
  State<DetalheUser> createState() => _DetalheUser();
}

class _DetalheUser extends State<DetalheUser> {
  late Future<List<DadosUser>> dadosUser; //Inicia a lista de dados do usuaário
  int? id; //Váriavel que vai guardar o id
  DateTime? dataBanco; //Váriavle que vai armazenar a data que vem do banco
  //Formato a data atual em utc
  final data = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final IdUsuario = ModalRoute.of(context)
        ?.settings
        .arguments; //Recebo o id do usúario por argumento
    id = IdUsuario
        as int?; //Minha váriavel id recebe o id enviado da página de lista
    dadosUser =
        DadosReceb(); //Minha lista vai ser populada com os dados que vem na requisição
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4065C3), //Define cor da nav
        title: Text("Dados específicos do usuário"), //Define título
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(115, 250, 0, 40),
              child: FutureBuilder<List<DadosUser>>(
                //Inicio da lista
                future: dadosUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //Aqui efetivamente começa a mostrar a lista de usuário
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            snapshot.data!.length, //Vejo o tamanho da lista
                        itemBuilder: (context, index) {
                          DadosUser usuario = snapshot.data![index];
                          dataBanco = DateTime.parse(usuario
                              .data!); //Minha váriavel recebe a data do banco
                          //Formata a data que vem do banco para utc
                          final dataUtcBanco = DateTime.utc(dataBanco!.year,
                              dataBanco!.month, dataBanco!.day);
                          //Faço a diferença entre as datas usando o método difference
                          final diferenca = data.difference(dataUtcBanco);

                          //Faço uma função para definir o melhor jeito de mostrar o tempo para o usuário
                          texto() {
                            //Mostra em segundos
                            if (diferenca.inMinutes < 60) {
                              return "Usuário está na lista a " +
                                  diferenca.inSeconds.toString() +
                                  "s.";
                            }
                            //Mostra em minutos
                            else if (diferenca.inHours < 24) {
                              return "Usuário está na lista a " +
                                  diferenca.inMinutes.toString() +
                                  "s.";
                            }
                            //Mostra em horas
                            else if (diferenca.inDays < 1) {
                              return "Usuário está na lista a " +
                                  diferenca.inHours.toString() +
                                  "h.";
                            }
                            //Mostra em dias
                            else {
                              return "Usuário está na lista a " +
                                  diferenca.inDays.toString() +
                                  " dias.";
                            }
                          }

                          return ListTile(
                            title: Text(usuario.nome!), //Como título mostra o nome do usuário
                            subtitle: Text(
                              texto(), //Chama a função de tempo como subtítulo
                            ),
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
          //Monto o botão de deletar usuário
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
              onPressed: () => deletar(), //Chamo a função de deletar
            ),
          ),
        ],
      ),
    );
  }

  //Requisição http para deletar
  deletar() async {
    //defino a url e passo junto com ela o id do usuário que eu quero digitar
    var url = Uri.parse('https://www.slmm.com.br/CTC/delete.php?id=${id}'); 
    var response = await http.delete(url);

    //Se der tudo certo volto para lista para ver que o usuário não está mais lá
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Usuário deletado com sucesso!"),
      ));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ListaUser(),
        ),
      );
    }
  }

  //Requisição get que retorna os dados específicos do usuário
  Future<List<DadosUser>> DadosReceb() async {
    //Passo junto a url o id do usuário que desejo saber os detalhes dos dados
    var url = Uri.parse('https://www.slmm.com.br/CTC/getDetalhe.php?id=${id}');
    var response = await http.get(url);

    //se der tudo certo eu mostro a lista dos dados na tela
    if (response.statusCode == 200) {
      List listaUsuario = json.decode(response.body);
      return listaUsuario.map((e) => DadosUser.fromJson(e)).toList(); //Classe DadosUser recebe os dados da requisição
    } else {
      throw Exception('Não foi possível carregar os usuários!');
    }
  }
}
