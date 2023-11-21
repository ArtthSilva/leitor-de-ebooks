import 'package:leitor_de_ebooks/data/models/livro_model.dart';

abstract class LivroService {
  Future <List<LivroModel>> getLivros();
} 