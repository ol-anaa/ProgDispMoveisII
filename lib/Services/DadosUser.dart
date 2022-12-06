class DadosUser {
  int? id; //Define váriavel id 
  String? nome; //Define váriavel nome
  String? data; //Define várivael data 

  DadosUser({this.id, this.nome, this.data}); //construtor

  DadosUser.fromJson(Map<String, dynamic> json) {
    id = json['id']; // o id da classe recebe o id que vem do json
    nome = json['nome']; // o nome da classe recebe o nome que vem do json
    data = json['data']; // o data da classe recebe o data que vem do json
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id; //id do banco recebe os dados digitados no flutter
    data['nome'] = this.nome; //nome do banco recebe os dados digitados no flutter
    data['data'] = this.data; //data do banco recebe os dados digitados no flutter
    return data;
  }
}