// Model for Album
class Album {
  final int id;
  final String title;

  Album({required this.id, required this.title});

  // Create Album from JSON
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], title: json['title']);
  }
}
