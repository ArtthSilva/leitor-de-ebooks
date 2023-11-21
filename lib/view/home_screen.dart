import 'package:flutter/material.dart';
import 'package:leitor_de_ebooks/http/http_client.dart';
import 'package:leitor_de_ebooks/service/livro_service_impl.dart';
import 'package:leitor_de_ebooks/stores/livro_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LivroStore store = LivroStore(
    service: LivroServiceImp(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getLivros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros '),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([store.isLoading, store.erro, store.state]),
        builder: (context, child) {
          if (store.isLoading.value == true) {
            return const CircularProgressIndicator();
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
                padding: const EdgeInsets.all(16),
                itemCount: store.state.value.length,
                itemBuilder: (_, index) {
                  final item = store.state.value[index];
                  return  Container(
                    padding: const EdgeInsets.all(20),                   
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: Image.network(  
                              height: MediaQuery.sizeOf(context).height * 0.3,                      
                              item.cover,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(item.title),
                          Text(item.author)
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
