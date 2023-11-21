import 'dart:convert';

import 'package:leitor_de_ebooks/data/models/livro_model.dart';
import 'package:leitor_de_ebooks/http/exceptions/exception.dart';
import 'package:leitor_de_ebooks/http/http_client.dart';
import 'package:leitor_de_ebooks/service/livro_service.dart';

class LivroServiceImp implements LivroService {
   final IHttpClient client;

  LivroServiceImp({required this.client});

  @override
  Future<List<LivroModel>> getLivros() async {
    final response = await client.get(url: 'https://escribo.com/books.json');

    if (response.statusCode == 200) {
      final List<LivroModel> livros = [];

      final body = jsonDecode(response.body);

      body.map((item){
        final LivroModel livro = LivroModel.fromMap(item);
        livros.add(livro);
      }).toList();

      return livros;
    }else if(response.statusCode == 404){
      throw NotFoundException(message: 'url não valida');
    }else{
      throw Exception('não deu p carregar');
    }
  }
  
}