// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

import 'package:leitor_de_ebooks/data/models/book_model.dart';

class FavoritesBooksScreen extends StatelessWidget {
  final List<BookModel> livrosFavoritos;

  const FavoritesBooksScreen({
    Key? key,
    required this.livrosFavoritos,
  }) : super(key: key);

    Future<File> downloadEbook(String url) async {
    var response = await http.get(Uri.parse(url));
    var directory = await getTemporaryDirectory();
    var filePath = '${directory.path}/ebook.epub';
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros Favoritos'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: livrosFavoritos.length,
        itemBuilder: (context, index) {
          final livro = livrosFavoritos[index];
          return Container(
            
            padding: const EdgeInsets.all(20),
            child:Column(
                      children: [
                        Container(
                          height: MediaQuery.sizeOf(context).height * 0.5,
                          width: MediaQuery.sizeOf(context).width * 0.6,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 4),
                                )
                              ]),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  File ebook =
                                  await downloadEbook(livro.download);
                                  VocsyEpub.setConfig(
                                    identifier: "iosBook",
                                    scrollDirection:
                                    EpubScrollDirection.ALLDIRECTIONS,
                                    allowSharing: true,
                                    enableTts: true,
                                    nightMode: true,
                                  );
                                  VocsyEpub.open(ebook.path);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: Image.network(
                                    livro.cover,
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.4,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  livro.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                livro.author,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      ],
            )
          );
        },
      ),
    );
  }
}
