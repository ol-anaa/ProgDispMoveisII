class DadosUser {
  int? id;
  String? nome;
  String? data;

  DadosUser({this.id, this.nome, this.data});

  DadosUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['data'] = this.data;
    return data;
  }
}