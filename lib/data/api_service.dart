import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/album.dart';
import 'models/photo.dart';

// Service for fetching albums and photos from the API
class ApiService {
  final http.Client client;

  ApiService({required this.client});

  // Fetch list of albums
  Future<List<Album>> fetchAlbums() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    );
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  // Fetch list of photos
  Future<List<Photo>> fetchPhotos() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/photos'),
    );
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
