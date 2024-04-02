class Livro {
  int id;
  String titulo;
  String autor;
  int anoPublicacao;

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.anoPublicacao,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'autor': autor,
    'anoPublicacao': anoPublicacao,
  };

  factory Livro.fromJson(Map<String, dynamic> json) => Livro(
    id: json['id'],
    titulo: json['titulo'],
    autor: json['autor'],
    anoPublicacao: json['anoPublicacao'],
  );
}
