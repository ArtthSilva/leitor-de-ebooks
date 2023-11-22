import 'package:flutter/material.dart';
import 'package:leitor_de_ebooks/data/models/book_model.dart';

class BookWidget extends StatefulWidget {
  final BookModel livro;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final List<BookModel> livrosFavoritos;

  const BookWidget({
    super.key,
    required this.livro,
    required this.onTap,
    required this.onFavoriteTap,
    required this.livrosFavoritos,
  });

  @override
  State<BookWidget> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {
  @override
  Widget build(BuildContext context) {
    bool isFavorite = widget.livrosFavoritos.contains(widget.livro);

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.5,
        width: MediaQuery.sizeOf(context).width * 0.7,
        color: Colors.grey[700],
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  widget.livro.cover,
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: -12,
                  right: -15,               
                  child: IconButton(
                    
                    icon: Icon(
                      size: 55,
                      isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      widget.onFavoriteTap();
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(                  
                    widget.livro.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      
                    ),
                  ),
                ),
                Text(
                  widget.livro.author,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
