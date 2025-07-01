import 'dart:async';

import 'package:app_m0v4u/ui/tv_show_screen/views/tv_show_detail_screen.dart';
import 'package:app_m0v4u/ui/tv_shows_screen/providers/tv_shows_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:app_m0v4u/shared/widgets/animations/animation_navigator.dart';

import '../../../constants/assets.dart';
import '../../../constants/styles.dart';
import '../models/tv_shows.dart';

class TvShowsScreen extends StatefulWidget {
  @override
  _TvShowsScreenState createState() => _TvShowsScreenState();
}

class _TvShowsScreenState extends State<TvShowsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;

  String searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();

    // Initialize first tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TvShowsProvider>(context, listen: false).fetchPopularTvShows();

    });

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
      final provider = Provider.of<TvShowsProvider>(context, listen: false);
      provider.resetTvShows(_tabController.index);
      switch (_tabController.index) {
        case 0:
          provider.fetchPopularTvShows();
          break;
        case 1:
          provider.fetchUpcomingTvShows();
          break;
        case 2:
          provider.fetchTopRatedTvShows();
          break;
        case 3:
          provider.fetchNowPlayingTvShows();
          break;
      }
      _scrollController.jumpTo(0); // Reset scroll position
    }
  }

  void _onScroll() {
    final provider = Provider.of<TvShowsProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !provider.isLoading &&
        provider.hasMorePages(_tabController.index)) {
      switch (_tabController.index) {
        case 0:
          provider.fetchPopularTvShows();
          break;
        case 1:
          provider.fetchUpcomingTvShows();
          break;
        case 2:
          provider.fetchTopRatedTvShows();
          break;
        case 3:
          provider.fetchNowPlayingTvShows();
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
      if (query.isNotEmpty) {
        Provider.of<TvShowsProvider>(context, listen: false)
            .searchTvShows(searchQuery);
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
                controller: _textEditingController, // Set the initial text
                decoration: InputDecoration(
                  hintText: 'Search Tv Shows...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(14.0))),
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
                        _textEditingController.clear();

                        searchQuery = ''; // Clear the search query
                      });
                      // You can also call the searchTvShows method with an empty query if needed
                      Provider.of<TvShowsProvider>(context, listen: false)
                          .searchTvShows('');
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
                    child: _buildTapBarText('Popular')

                ),
                Tab(
                    child: _buildTapBarText('Airing Today')

                ),
                Tab(
                    child: _buildTapBarText('Top Rated')

    ),
                Tab(
                    child: _buildTapBarText('On the Air')

                ),
              ],
            ),
          ),
          // Displaying either Search Results or TvShows

          Expanded(
            child: Consumer<TvShowsProvider>(builder: (context, provider, _) {
              List<Result> tvShowsToDisplay = [];
              bool hasMorePages = true;


                // If we are searching, show the search results
                if (searchQuery.isNotEmpty) {
                  tvShowsToDisplay = provider.searchResults;
                  hasMorePages = provider.searchHasMorePages;
                } else {
                  // Otherwise, display the tv shows based on the selected tab
                  switch (_tabController.index) {
                    case 0:
                      tvShowsToDisplay = provider.popularTvShows;
                      hasMorePages = provider.popularHasMorePages;
                      break;
                    case 1:
                      tvShowsToDisplay = provider.upcomingTvShows;
                      hasMorePages = provider.upcomingHasMorePages;
                      break;
                    case 2:
                      tvShowsToDisplay = provider.topRatedTvShows;
                      hasMorePages = provider.topRatedHasMorePages;
                      break;
                    case 3:
                      tvShowsToDisplay = provider.nowPlayingTvShows;
                      hasMorePages = provider.nowPlayingHasMorePages;
                      break;
                  }
                }
              if (tvShowsToDisplay.isEmpty) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          color: AppStyles.secondaryColor,
                          size: 50,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'No Tv Shows To display',
                          style: TextStyle(
                              color: AppStyles.darkColor, fontSize: 20),
                        )
                      ]),
                );
              } else {
                return Skeletonizer(
                  enabled: provider.isLoading ,
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 1 / 1.3,
                    ),
                    itemCount: tvShowsToDisplay.length +
                        (hasMorePages && provider.isLoading ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (index >= tvShowsToDisplay.length) {
                        return Card(
                          color: AppStyles.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        );
                      }
                      final tvshow = tvShowsToDisplay[index];
                      return Card(
                        color: AppStyles.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: GestureDetector(
                          onTap: () {
                            AnimatedNavigator.pushZoomIn(context,
                                TvShowDetailScreen(tvShowId: tvshow.id!));
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
                                  'https://image.tmdb.org/t/p/w500${tvshow.posterPath}',
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 160,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.tv_rounded,
                                          size: 50, color: Colors.grey[600]),
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
                                      tvshow.title ?? "Unknown Title",
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
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTapBarText(String text) {
    return AutoSizeText(
      text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      maxLines: 1,
      minFontSize: 10,
      maxFontSize: 12,
    );
  }

}
