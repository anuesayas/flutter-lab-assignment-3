import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/api_service.dart';
import 'album_event.dart';
import 'album_state.dart';
import '../data/models/photo.dart';

// Bloc for handling album events and states
class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final ApiService apiService;

  AlbumBloc({required this.apiService}) : super(AlbumInitial()) {
    on<FetchAlbums>((event, emit) async {
      emit(AlbumLoading());
      try {
        final albums = await apiService.fetchAlbums();
        final photos = await apiService.fetchPhotos();

        // Group photos by albumId
        final photosByAlbum = <int, List<Photo>>{};
        for (var photo in photos) {
          photosByAlbum.putIfAbsent(photo.albumId, () => []).add(photo);
        }

        emit(AlbumLoaded(albums: albums, photosByAlbum: photosByAlbum));
      } catch (e) {
        emit(AlbumError('Failed to fetch data. Please try again.'));
      }
    });
  }
}
