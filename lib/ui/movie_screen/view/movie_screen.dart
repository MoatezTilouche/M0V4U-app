import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/actor/actor_carousel.dart';
import 'package:app_m0v4u/ui/trailer_screen/views/youtube_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/shared/widgets/appbar/menu_drawer.dart';
import 'package:app_m0v4u/ui/movie_screen/providers/movie_provider.dart';
import 'package:share_plus/share_plus.dart';

class MovieDetailScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final int movieId;

  MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailProvider()..loadMovie(movieId),
      child: Scaffold(

        extendBodyBehindAppBar: true,
        backgroundColor: AppStyles.primaryColor,
        appBar: const CustomNavBar(),
        drawer: const MenuDrawer(),
        body: Consumer<MovieDetailProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final movie = provider.movie;
            if (movie == null) {
              return const Center(child: Text("Movie not found."));
            }

            return Stack(
              children: [
                // Background image
                SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.backdropPath ?? movie.posterPath}',
                    fit: BoxFit.cover,
                  ),
                ),

                // Foreground content
                SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 300),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppStyles.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          movie.title ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Rating + runtime + year
                        Row(
                          children: [
                            Text(
                                '${movie.voteAverage?.toStringAsFixed(1) ?? '0.0'}',
                                style: const TextStyle(color: Colors.black)),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 15,
                            ),
                            const SizedBox(width: 12),
                            Text('${movie.runtime ?? 0} min',
                                style: const TextStyle(color: Colors.black26)),
                            const SizedBox(width: 12),
                            Text('${movie.releaseDate?.year ?? ''}',
                                style: const TextStyle(color: Colors.black26)),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Genres
                        Wrap(
                          spacing: 8,
                          children: movie.genres
                                  ?.map((g) => Container(
                                    
                                    child: Chip(
                                          label: Text(g.name ?? ''),
                                          backgroundColor:
                                              Color(0xFF4CAF50),
                                          labelStyle: const TextStyle(
                                              color: Colors.white),
                                        ),
                                  ))
                                  .toList() ??
                              [],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: provider.trailer != null
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => YouTubeScreen(
                                              videoId:
                                                  provider.trailer!.videoKey,
                                              title:
                                                  provider.trailer!.movieTitle,
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                                icon: Image.asset(
                                  Assets.playIcon,
                                  height: 20.0,
                                  width: 20.0,
                                ),
                                label: const Text(
                                  "Watch Trailer",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppStyles.secondaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: () {},
                              icon:  Image.asset(Assets.emptyLove,width: 30,height: 30,color: AppStyles.secondaryColor,)
                                 ,
                            ),
                            IconButton(
                              onPressed: () {
                                final message = '''
                                🎬 Check out this movie: ${movie.title}
                                
                                🗓️ Release Date: ${movie.releaseDate?.year ?? 'Unknown'}
                                ⭐ Rating: ${movie.voteAverage?.toString() ?? 'N/A'} / 10
                                📄 Overview: ${movie.overview ?? 'No description available.'}
                                
                                Powered by M0V4U
                                ''';

                                final params = ShareParams(
                                  text: message.trim(),
                                  subject: 'Discover ${movie.title}',
                                );

                                SharePlus.instance.share(params);
                              },

                              icon: const Icon(Icons.share,
                                  color: AppStyles.secondaryColor),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Cast (optional - requires provider.movie.credits)
                        if (movie.productionCompanies != null)
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: movie.productionCompanies!.length,
                              itemBuilder: (context, index) {
                                final actor = movie.productionCompanies![index];
                                return Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: actor.logoPath != null
                                            ? NetworkImage(
                                                'https://image.tmdb.org/t/p/w200${actor.logoPath}')
                                            : null,
                                        radius: 30,
                                        backgroundColor: AppStyles.primaryColor,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        actor.name ?? '',
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Overview
                        Text(
                          movie.overview ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black26,
                          ),
                        ),
                        const SizedBox(height: 20),

                        const SizedBox(height: 24),
                        ActorCarousel(actors: provider.actors),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
