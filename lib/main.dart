import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'data/api_service.dart';
import 'domain/album_bloc.dart';
import 'domain/album_event.dart';
import 'presentation/album_list_screen.dart';
import 'presentation/album_detail_screen.dart';
import 'data/models/album.dart';
import 'data/models/photo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Main app widget
  MyApp({Key? key}) : super(key: key);

  final ApiService apiService = ApiService(client: http.Client());

  late final AlbumBloc albumBloc = AlbumBloc(apiService: apiService)
    ..add(FetchAlbums());

  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const AlbumListScreen()),
      GoRoute(
        path: '/details',
        builder: (context, state) {
          final extra = state.extra;
          Album album;
          List<Photo> photos = [];
          if (extra is Map) {
            album = extra['album'] as Album;
            final rawPhotos = extra['photos'];
            if (rawPhotos is List<Photo>) {
              photos = rawPhotos;
            } else if (rawPhotos is List) {
              photos = rawPhotos.whereType<Photo>().toList();
            }
          } else {
            album = extra as Album;
          }
          return AlbumDetailScreen(album: album, photos: photos);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => albumBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Albums App',
        routerConfig: _router,
        theme: ThemeData.dark().copyWith(
          colorScheme: ThemeData.dark().colorScheme.copyWith(
            primary: Colors.deepPurpleAccent,
            secondary: Colors.amberAccent,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          scaffoldBackgroundColor: const Color(0xFF181A20),
          cardColor: const Color(0xFF23232B),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
