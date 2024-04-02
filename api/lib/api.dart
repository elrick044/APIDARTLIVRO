import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'livro.dart';
import 'dart:convert';

const _port = 8080;
final _livros = <Livro>[];

void main() async {

  final router = Router();

  // **GET /livros**
  router.get('/livros', (Request request) async {
    return Response.ok(_livros.map((livro) => livro.toJson()).toString());
  });

  // **POST /livros**
  router.post('/livros', (Request request) async {
    final livro = await request.readAsString();
    final novoLivro = Livro.fromJson(jsonDecode(livro));
    _livros.add(novoLivro);
    return Response.ok('{"success": true}');
  });

  // **GET /livros/:id**
  router.get('/livros/<id>', (Request request, String id) async {
    final livro = _livros.firstWhere((livro) => livro.id == int.parse(id));
    return Response.ok(livro.toJson().toString());
  });

  // **PUT /livros/:id**
  router.put('/livros/<id>', (Request request, String id) async {
    final livroAtualizado = await request.readAsString();
    var livro = _livros.firstWhere((livro) => livro.id == int.parse(id));
    livro.titulo = jsonDecode(livroAtualizado)['titulo'];
    livro.autor = jsonDecode(livroAtualizado)['autor'];
    livro.anoPublicacao = jsonDecode(livroAtualizado)['anoPublicacao'];
    return Response.ok('{"success": true}');
  });

  // **DELETE /livros/:id**
  router.delete('/livros/<id>', (Request request, String id) async {
    _livros.removeWhere((livro) => livro.id == int.parse(id));
    return Response.ok('{"success": true}');
  });

  final server = await shelf_io.serve(router, '10.51.222.222', _port);
  print(server.address);

  print('Server listening on port $_port');
}