import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'livro.dart';
import 'dart:convert';
import 'package:mysql1/mysql1.dart';

const _port = 8081;

void main() async {
  var settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '260405',
    db: 'apilivro'
  );

  var conn = await MySqlConnection.connect(settings);
  final router = Router();

  // GET /livros
  router.get('/livros', (Request request) async {
    try {
      var results = await conn.query("SELECT * FROM Livro");
      final _livros = <Livro>[];
  
      for (var row in results) {
        int id = row[0];
        String titulo = row[1].toString();
        String autor = row[2].toString();
        int anoPublicacao = row[3];
  
        Livro aux = Livro(id: id, titulo: titulo , autor: autor, anoPublicacao: anoPublicacao);
        _livros.add(aux);
      }
      return Response.ok(_livros.map((livro) => livro.toJson()).toString());
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao obter dados da tabela Livro: $e');
    }
  });

  // POST /livros
  router.post('/livros', (Request request) async {
    try {
      final livro = await request.readAsString();
      var novoLivro = Livro.fromJson(jsonDecode(livro));
  
      var id = novoLivro.id;
      var titulo = novoLivro.titulo;
      var autor = novoLivro.autor;
      var dp = novoLivro.anoPublicacao;
  
      var inserir = "INSERT INTO Livro (id, titulo, autor, anoPublicacao) VALUES ($id, '$titulo', '$autor', $dp)";
      
      await conn.query(inserir);
  
      return Response.ok('{"success": true}');
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao inserir dados na tabela Livro: $e');
    }
  });

  // GET /livros/:id
  router.get('/livros/<id>', (Request request, String id) async {
    try {
      var inserir = "SELECT * FROM Livro WHERE id = $id";
      var result = await conn.query(inserir);
  
      String titulo = result.first[1].toString();
      String autor = result.first[2].toString();
      int anoPublicacao = result.first[3];
  
      Livro livro = Livro(id: int.parse(id), titulo: titulo , autor: autor, anoPublicacao: anoPublicacao);
  
      return Response.ok(livro.toJson().toString());
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao obter dados do livro com ID $id: $e');
    }
  });

  // PUT /livros/:id
  router.put('/livros/<id>', (Request request, String id) async {
    try {
      final livroAtualizado = await request.readAsString();
      var novoLivro = Livro.fromJson(jsonDecode(livroAtualizado));
  
      var titulo = novoLivro.titulo;
      var autor = novoLivro.autor;
      var dp = novoLivro.anoPublicacao;
  
      var inserir = "UPDATE Livro SET titulo = '$titulo', autor = '$autor', anoPublicacao = $dp WHERE id = $id";
  
      await conn.query(inserir);
  
      return Response.ok('{"success": true}');
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao atualizar dados do livro com ID $id: $e');
    }
  });

  // DELETE /livros/:id
  router.delete('/livros/<id>', (Request request, String id) async {
    try {
      var inserir = "DELETE FROM Livro WHERE id = $id";
      await conn.query(inserir);
  
      return Response.ok('{"success": true}');
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao excluir livro com ID $id: $e');
    }
  });

  final server = await shelf_io.serve(router, '10.51.222.222', _port);
  print(server.address);

  print('Server listening on port $_port');
}