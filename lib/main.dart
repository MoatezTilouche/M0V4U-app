import 'package:app_m0v4u/shared/widgets/appbar/navbar_provider.dart';
import 'package:app_m0v4u/ui/actor/providers/actor_provider.dart';
import 'package:app_m0v4u/ui/genre_screen/providers/genre_provider.dart';
import 'package:app_m0v4u/ui/home_screen/providers/home_screen_provider.dart';
import 'package:app_m0v4u/ui/movie_screen/providers/movie_provider.dart';
import 'package:app_m0v4u/ui/movies/providers/movies_provider.dart';
import 'package:app_m0v4u/ui/splash_screen.dart';
import 'package:app_m0v4u/ui/trailer_screen/providers/trailer_provider.dart';
import 'package:app_m0v4u/ui/trailer_screen/providers/youtube_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
        ChangeNotifierProvider(create: (_) => MoviesProvider())

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
