class Usuarios {
  int? id; //Variavel de id 
  String? nome; //Variavel do nome

  Usuarios({this.id, this.nome}); //construtor

  Usuarios.fromJson(Map<String, dynamic> json) {
    id = json['id']; // o id da classe recebe o id que vem do json
    nome = json['nome']; // o nome da classe recebe o nome que vem do json
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id; //id do banco recebe os dados digitados no flutter
    data['nome'] = this.nome; //nome do banco recebe os dados digitados no flutter
    return data;
  }
}