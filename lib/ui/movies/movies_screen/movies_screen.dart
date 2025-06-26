import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:app_m0v4u/ui/movies/models/movies.dart';
import 'package:app_m0v4u/ui/movies/providers/movies_provider.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/shared/widgets/appbar/menu_drawer.dart';
import 'package:app_m0v4u/shared/widgets/animations/animation_navigator.dart';
import 'package:app_m0v4u/ui/movie_screen/view/movie_screen.dart';
import 'package:app_m0v4u/shared/widgets/bottomBar/bottom_bar.dart';

import '../../../constants/assets.dart';
import '../../../constants/styles.dart';

class MoviesScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  String searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();

    // Initialize first tab
    Provider.of<MoviesProvider>(context, listen: false).fetchPopularMovies();

    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final provider = Provider.of<MoviesProvider>(context, listen: false);
      provider.resetMovies(_tabController.index);
      switch (_tabController.index) {
        case 0:
          provider.fetchPopularMovies();
          break;
        case 1:
          provider.fetchUpcomingMovies();
          break;
        case 2:
          provider.fetchTopRatedMovies();
          break;
        case 3:
          provider.fetchNowPlayingMovies();
          break;
      }
      _scrollController.jumpTo(0); // Reset scroll position
    }
  }

  void _onScroll() {
    final provider = Provider.of<MoviesProvider>(context, listen: false);
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        !provider.isLoading &&
        provider.hasMorePages(_tabController.index)) {
      switch (_tabController.index) {
        case 0:
          provider.fetchPopularMovies();
          break;
        case 1:
          provider.fetchUpcomingMovies();
          break;
        case 2:
          provider.fetchTopRatedMovies();
          break;
        case 3:
          provider.fetchNowPlayingMovies();
          break;
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = query;
      });
      if (searchQuery.isNotEmpty) {
        Provider.of<MoviesProvider>(context, listen: false).searchMovies(searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        children: [
          // Search Section
          Container(
            decoration: BoxDecoration(
              color: AppStyles.secondaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: TextEditingController(text: searchQuery), // Set the initial text
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(14.0))),
                  prefixIcon: IconButton(
                    icon: Image.asset(
                      Assets.searchIcon,
                      height: 25.0,
                      width: 25.0,
                    ),
                    onPressed: () {},
                  ),
                  suffixIcon: IconButton(
                    icon: Image.asset(
                      Assets.closeIcon,
                      height: 25.0,
                      width: 25.0,
                    ),
                    onPressed: () {
                      setState(() {
                        searchQuery = ''; // Clear the search query
                      });
                      // You can also call the searchMovies method with an empty query if needed
                      Provider.of<MoviesProvider>(context, listen: false).searchMovies('');
                    },
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          // TabBar Section
          Material(
            color: AppStyles.secondaryColor,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              indicatorColor: Colors.blueAccent,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              tabs: [
                Tab(
                  child: AutoSizeText(
                    'Popular',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Tab(
                  child: AutoSizeText(
                    'Upcoming',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Tab(
                  child: AutoSizeText(
                    'Top Rated',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Tab(
                  child: AutoSizeText(
                    'Now Playing',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          // Displaying either Search Results or Movies
          Expanded(
            child: Consumer<MoviesProvider>(builder: (context, provider, _) {
              List<Result> moviesToDisplay = [];
              bool hasMorePages = true;

              // If we are searching, show the search results
              if (searchQuery.isNotEmpty) {
                moviesToDisplay = provider.searchResults;
                hasMorePages = provider.searchHasMorePages;
              } else {
                // Otherwise, display the movies based on the selected tab
                switch (_tabController.index) {
                  case 0:
                    moviesToDisplay = provider.popularMovies;
                    hasMorePages = provider.popularHasMorePages;
                    break;
                  case 1:
                    moviesToDisplay = provider.upcomingMovies;
                    hasMorePages = provider.upcomingHasMorePages;
                    break;
                  case 2:
                    moviesToDisplay = provider.topRatedMovies;
                    hasMorePages = provider.topRatedHasMorePages;
                    break;
                  case 3:
                    moviesToDisplay = provider.nowPlayingMovies;
                    hasMorePages = provider.nowPlayingHasMorePages;
                    break;
                }
              }

              return Skeletonizer(
                enabled: provider.isLoading && moviesToDisplay.isEmpty,
                child: GridView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 1 / 1.3,
                  ),
                  itemCount: moviesToDisplay.length + (hasMorePages && provider.isLoading ? 2 : 0),
                  itemBuilder: (context, index) {
                    if (index >= moviesToDisplay.length) {
                      return Card(
                        color: AppStyles.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      );
                    }
                    final movie = moviesToDisplay[index];
                    return Card(
                      color: AppStyles.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: GestureDetector(
                        onTap: () {
                          AnimatedNavigator.pushZoomIn(context, MovieDetailScreen(movieId: movie.id!));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: 160,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.movie_filter, size: 50, color: Colors.grey[600]),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 35,
                                child: Center(
                                  child: AutoSizeText(
                                    maxLines: 2,
                                    movie.title ?? "Unknown Title",
                                    textAlign: TextAlign.center,
                                    minFontSize: 8,
                                    maxFontSize: 12,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
