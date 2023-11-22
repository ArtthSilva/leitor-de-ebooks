// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:leitor_de_ebooks/data/models/book_model.dart';
import 'package:leitor_de_ebooks/http/exceptions/exception.dart';
import 'package:leitor_de_ebooks/services/book_service.dart';
import 'package:leitor_de_ebooks/views/favorites_books_screen.dart';

class BookStore {
  final BookService service;

  BookStore({
    required this.service,
  });

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<BookModel>> state = ValueNotifier<List<BookModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  final ValueNotifier<List<BookModel>> livrosFavoritos = ValueNotifier<List<BookModel>>([]);

  Future loadBooks() async{
    isLoading.value = true;

    try {
     final result =  await service.getBooks();
     state.value = result;
    } on NotFoundException catch (e){
      erro.value = e.message;
    }
    catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  } 

void addBookFavorite(BookModel livro) {
 if (livrosFavoritos.value.contains(livro)) {
  livrosFavoritos.value = List<BookModel>.from(livrosFavoritos.value)..remove(livro);
 } else {
  livrosFavoritos.value = List<BookModel>.from(livrosFavoritos.value)..add(livro);
 }
}
 void navigateToFavoriteBooksScreen(BuildContext context) {
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (_) => FavoritesBooksScreen(livrosFavoritos: livrosFavoritos.value),
     ),
   );
 }
}
