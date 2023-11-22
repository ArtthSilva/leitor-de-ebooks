import 'package:leitor_de_ebooks/data/models/book_model.dart';

abstract class BookService {
  Future <List<BookModel>> getBooks();
} 