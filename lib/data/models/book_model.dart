
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

   factory BookModel.fromJson(Map<String, dynamic> json) {
   return BookModel(
     id: json['id'],
     title: json['title'],
     author: json['author'],
     cover: json['cover'],
     download: json['download'],
   );
 }
 Map<String, dynamic> toJson() {
  return {
    'id': id,
    'title': title,
    'author': author,
    'cover': cover,
    'download': download,
  };
 }


  @override
 bool operator ==(Object other) {
   if (identical(this, other)) return true;

   return other is BookModel && other.id == id;
 }

 @override
 int get hashCode => id.hashCode;

}
