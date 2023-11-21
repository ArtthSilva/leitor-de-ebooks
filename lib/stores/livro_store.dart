// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:leitor_de_ebooks/data/models/livro_model.dart';
import 'package:leitor_de_ebooks/http/exceptions/exception.dart';
import 'package:leitor_de_ebooks/service/livro_service.dart';

class LivroStore {
  final LivroService service;

  LivroStore({
    required this.service,
  });

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<LivroModel>> state = ValueNotifier<List<LivroModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  Future getLivros() async{

    isLoading.value = true;

    try {
     final result =  await service.getLivros();
     state.value = result;
    } on NotFoundException catch (e){
      erro.value = e.message;
    }
    catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  } 
}
