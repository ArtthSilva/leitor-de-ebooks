import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leitor_de_ebooks/data/models/book_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:leitor_de_ebooks/http/http_client.dart';
import 'package:leitor_de_ebooks/services/book_service_impl.dart';
import 'package:leitor_de_ebooks/stores/book_store.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final BookStore store = BookStore(
    service: BookServiceImp(
      client: HttpClient(),
    ),
  );

  Future<File> downloadEbook(String url) async {
    var response = await http.get(Uri.parse(url));
    var directory = await getTemporaryDirectory();
    var filePath = '${directory.path}/ebook.epub';
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  @override
  void initState() {
    super.initState();
    store.getLivros();
  }

  @override
  void dispose() {
    super.dispose();
    store.getLivros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros '),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => store.navigateToFavoriteBooksScreen(context),
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([store.isLoading, store.erro, store.state]),
        builder: (context, child) {
          if (store.isLoading.value == true) {
            return const Center(child: CircularProgressIndicator());
          }

          if (store.erro.value.isNotEmpty) {
            return Center(
              child: Text(
                store.erro.value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            );
          }

          if (store.state.value.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum livro',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: store.state.value.length,
                itemBuilder: (_, index) {
                  final livro = store.state.value[index];
                  return Container(
                    color: Colors.grey[300],
                    padding: const EdgeInsets.all(20),
                    child: Column(
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
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        livro.cover,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.4,
                                        fit: BoxFit.cover,
                                      ),
                                      ValueListenableBuilder<List<BookModel>>(
                                        valueListenable: store.livrosFavoritos,
                                        builder:
                                            (context, livrosFavoritos, child) {
                                          return Positioned(
                                            right: -15,
                                            top: -12,
                                            child: InkWell(
                                              child: IconButton(
                                                onPressed: () => store
                                                    .addBookFavorite(
                                                        livro),
                                                icon: Icon(
                                                  size: 55,
                                                  livrosFavoritos
                                                          .contains(livro)
                                                      ? Icons.bookmark
                                                      : Icons.bookmark_add,
                                                  color: livrosFavoritos
                                                          .contains(livro)
                                                      ? Colors.red
                                                      : Colors.lightBlue,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
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
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
