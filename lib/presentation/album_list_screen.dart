import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../domain/album_bloc.dart';
import '../domain/album_state.dart';
import '../data/models/album.dart';
import '../data/models/photo.dart';
import '../domain/album_event.dart';

class AlbumListScreen extends StatelessWidget {
  // List screen for displaying albums
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            // Show loading indicator
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading albums...', style: TextStyle(color: Colors.white70)),
                ],
              ),
            );
          } else if (state is AlbumError) {
            // Show error message and retry button
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message, style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<AlbumBloc>().add(FetchAlbums()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is AlbumLoaded) {
            final albums = state.albums;
            final photosByAlbum = state.photosByAlbum;

            if (albums.isEmpty) {
              // Show empty state
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_album_outlined, color: Colors.white24, size: 64),
                    SizedBox(height: 16),
                    Text('No albums found.', style: TextStyle(color: Colors.white54, fontSize: 18)),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                final photos = photosByAlbum[album.id] ?? [];

                // Pick first photo thumbnail or placeholder
                final thumbnailUrl =
                    photos.isNotEmpty
                        ? photos.first.thumbnailUrl
                        : 'https://via.placeholder.com/150/222/fff?text=No+Image';

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    context.push(
                      '/details',
                      extra: {'album': album, 'photos': photos},
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Image.network(
                                thumbnailUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, color: Colors.black26, size: 32),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  album.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  photos.length.toString(),
                                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          // Fallback empty container
          return const Center(child: Text('Something went wrong.', style: TextStyle(color: Colors.white70)));
        },
      ),
    );
  }
}
