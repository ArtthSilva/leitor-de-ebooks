
class BookModel {
  final int id;
  final String title;
  final String author;
  final String cover;
  final String download;  
  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.cover,
    required this.download,
  });

  factory BookModel.fromMap(Map<String, dynamic> map){
    return BookModel(
      id: map['id'],
      title: map['title'],
     author: map['author'],
      cover: map['cover_url'], 
      download: map['download_url']);
  }
}
