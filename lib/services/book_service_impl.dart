import 'dart:convert';

import 'package:leitor_de_ebooks/data/models/book_model.dart';
import 'package:leitor_de_ebooks/http/exceptions/exception.dart';
import 'package:leitor_de_ebooks/http/http_client.dart';
import 'package:leitor_de_ebooks/services/book_service.dart';

class BookServiceImp implements BookService {
   final IHttpClient client;

  BookServiceImp({required this.client});

  @override
  Future<List<BookModel>> getBooks() async {
    final response = await client.get(url: 'https://escribo.com/books.json');

    if (response.statusCode == 200) {
      final List<BookModel> books = [];

      final body = jsonDecode(response.body);

      body.map((item){
        final BookModel book = BookModel.fromMap(item);
        books.add(book);
      }).toList();

      return books;
    }else if(response.statusCode == 404){
      throw NotFoundException(message: 'url não valida');
    }else{
      throw Exception('não deu p carregar');
    }
  }
  
}