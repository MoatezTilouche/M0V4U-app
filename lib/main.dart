import 'package:app_m0v4u/shared/widgets/appbar/navbar_provider.dart';
import 'package:app_m0v4u/ui/actor/providers/actor_provider.dart';
import 'package:app_m0v4u/ui/actor_screen/providers/actor_screen_provider.dart';
import 'package:app_m0v4u/ui/auth/providers/auth_provider.dart';
import 'package:app_m0v4u/ui/genre_screen/providers/genre_provider.dart';
import 'package:app_m0v4u/ui/home_screen/providers/home_screen_provider.dart';
import 'package:app_m0v4u/ui/movie_screen/providers/favorites_provider.dart';
import 'package:app_m0v4u/ui/movie_screen/providers/movie_provider.dart';
import 'package:app_m0v4u/ui/movie_screen/providers/watchlist_provider.dart';
import 'package:app_m0v4u/ui/movies/providers/movies_provider.dart';
import 'package:app_m0v4u/ui/movies_acc_to_genres/providers/movies_by_genre_provider.dart';
import 'package:app_m0v4u/ui/splash_screen.dart';
import 'package:app_m0v4u/ui/trailer_screen/providers/trailer_provider.dart';
import 'package:app_m0v4u/ui/trailer_screen/providers/youtube_provider.dart';
import 'package:app_m0v4u/ui/tv_show_screen/providers/tv_favorite_provider.dart';
import 'package:app_m0v4u/ui/tv_show_screen/providers/tv_show_details_provider.dart';
import 'package:app_m0v4u/ui/tv_show_screen/providers/tv_show_watchlist_provider.dart';
import 'package:app_m0v4u/ui/tv_shows_screen/providers/tv_shows_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'ui/chat_bot_screen/providers/chatbot_provider.dart';

void main() {
  Gemini.init(apiKey: geminiApiKey);


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavBarState()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => GenreScreenProvider()),
        ChangeNotifierProvider(create: (_) => TrailerProvider()),
        ChangeNotifierProvider(create: (_) => YouTubeProvider()),
        ChangeNotifierProvider(create: (_) => MovieDetailProvider()),
        ChangeNotifierProvider(create: (_) => ActorProvider()),
        ChangeNotifierProvider(create: (_) => MoviesProvider()),
        ChangeNotifierProvider(create: (_) => ActorsProvider()),
        ChangeNotifierProvider(create: (_) => GenreMoviesProvider()),
        ChangeNotifierProvider(create: (_) => ChatBotProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => TvShowsProvider()),
        ChangeNotifierProvider(create: (_) => TvShowDetailProvider()),
        ChangeNotifierProvider(create: (_) => TvFavoriteProvider()),
        ChangeNotifierProvider(create: (_) => TvWatchlistProvider()),












      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M0V4U',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SplashScreen(),

    );

  }
}
