import 'package:flutter/material.dart';

import '../data/models/album.dart';
import '../data/models/photo.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;
  final List<Photo> photos;

  // Detail screen for displaying album info and photos
  const AlbumDetailScreen({required this.album, required this.photos, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Album ID: ${album.id}', style: const TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              'Title: ${album.title}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Photos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amberAccent),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: photos.isEmpty
                    ? const Center(child: Text('No photos found.', style: TextStyle(color: Colors.white54)))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Responsive: 2 columns for narrow, 3 for medium, 4 for wide
                          int crossAxisCount = 2;
                          double width = constraints.maxWidth;
                          if (width > 700) {
                            crossAxisCount = 4;
                          } else if (width > 500) {
                            crossAxisCount = 3;
                          }
                          return GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            itemCount: photos.length,
                            itemBuilder: (context, index) {
                              final photo = photos[index];
                              return Card(
                                color: Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                                        child: Image.network(
                                          photo.thumbnailUrl,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        photo.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
