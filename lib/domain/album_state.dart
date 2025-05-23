import '../data/models/album.dart';
import '../data/models/photo.dart';

// State base class for album states
abstract class AlbumState {}

// Initial state
class AlbumInitial extends AlbumState {}

// Loading state
class AlbumLoading extends AlbumState {}

// Loaded state with albums and photos grouped by albumId
class AlbumLoaded extends AlbumState {
  final List<Album> albums;
  final Map<int, List<Photo>> photosByAlbum; // map albumId to photos

  AlbumLoaded({required this.albums, required this.photosByAlbum});
}

// Error state with message
class AlbumError extends AlbumState {
  final String message;

  AlbumError(this.message);
}
