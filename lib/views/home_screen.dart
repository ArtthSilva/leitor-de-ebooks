import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leitor_de_ebooks/data/models/book_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:leitor_de_ebooks/http/http_client.dart';
import 'package:leitor_de_ebooks/services/book_service_impl.dart';
import 'package:leitor_de_ebooks/stores/book_store.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:leitor_de_ebooks/widgets/book_widget.dart'; // Importando o widget BookWidget

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
   store.loadBooks();
 }

 @override
 void dispose() {
   super.dispose();
   store.loadBooks();
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
           return ValueListenableBuilder<List<BookModel>>(
             valueListenable: store.livrosFavoritos,
             builder: (context, value, child) {
               return BookWidget(
                livro: livro,
                onTap: () async {
                 File ebook = await downloadEbook(livro.download);
                 VocsyEpub.setConfig(
                  identifier: "iosBook",
                  scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                  allowSharing: true,
                  enableTts: true,
                  nightMode: true,
                 );
                 VocsyEpub.open(ebook.path);
                },
                onFavoriteTap: () => store.addBookFavorite(livro),
                livrosFavoritos: value,
               );
             },
           );
         });
         }
       },
     ),
   );
 }
}
