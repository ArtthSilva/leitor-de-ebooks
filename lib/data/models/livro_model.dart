
class LivroModel {
  final int id;
  final String title;
  final String author;
  final String cover;
  final String download;  
  LivroModel({
    required this.id,
    required this.title,
    required this.author,
    required this.cover,
    required this.download,
  });

  factory LivroModel.fromMap(Map<String, dynamic> map){
    return LivroModel(
      id: map['id'],
      title: map['title'],
     author: map['author'],
      cover: map['cover_url'], 
      download: map['download_url']);
  }
}
