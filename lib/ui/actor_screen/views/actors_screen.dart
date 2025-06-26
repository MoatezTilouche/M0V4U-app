import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/animations/animation_navigator.dart';
import 'package:app_m0v4u/ui/actor/view/actor_screen.dart';

import '../../../shared/widgets/appbar/custom_navbar.dart';
import '../../../shared/widgets/appbar/menu_drawer.dart';
import '../../../shared/widgets/bottomBar/bottomBar.dart';
import '../../actor/models/actor.dart';
import '../providers/actor_screen_provider.dart';

class ActorsScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _ActorsScreenState createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  String searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();

    // Fetch popular actors initially
    Provider.of<ActorsProvider>(context, listen: false).fetchPopularActors();

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
      final provider = Provider.of<ActorsProvider>(context, listen: false);
      provider.resetActors(_tabController.index);
      switch (_tabController.index) {
        case 0:
          provider.fetchPopularActors();
          break;
        case 1:
          provider.searchActors(searchQuery);
          break;
      }
      _scrollController.jumpTo(0); // Reset scroll position
    }
  }

  void _onScroll() {
    final provider = Provider.of<ActorsProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !provider.isLoading &&
        provider.hasMorePages(_tabController.index)) {
      switch (_tabController.index) {
        case 0:
          provider.fetchPopularActors();
          break;
        case 1:
          provider.searchActors(searchQuery);
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
      if (_tabController.index == 1 && searchQuery.isNotEmpty) {
        Provider.of<ActorsProvider>(context, listen: false).searchActors(searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey, // Use the scaffold key here
      backgroundColor: AppStyles.primaryColor,
      appBar: CustomNavBar(),
      drawer: MenuDrawer(),
      body: Column(
        children: [
          // Search Section
          Container(
            decoration: BoxDecoration(
              color: AppStyles.secondaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: TextEditingController(text: searchQuery),
                decoration: InputDecoration(
                  hintText: 'Search actors...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        searchQuery = '';
                      });
                      Provider.of<ActorsProvider>(context, listen: false).searchActors('');
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
                Tab(text: 'Popular'),
                Tab(text: 'Search'),
              ],
            ),
          ),
          // Displaying either Search Results or Movies
          Expanded(
            child: Consumer<ActorsProvider>(builder: (context, provider, _) {
              if (provider.errorMessage != null && !provider.isLoading) {
                return Center(child: Text(provider.errorMessage!));
              }
              List<Actor> actorsToDisplay = _tabController.index == 1 && searchQuery.isNotEmpty
                  ? provider.searchResults
                  : provider.popularActors;

              return Skeletonizer(
                enabled: provider.isLoading && actorsToDisplay.isEmpty,
                child: actorsToDisplay.isEmpty && !provider.isLoading
                    ? Center(child: Text('No actors found'))
                    : GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 1 / 1.3,
                  ),
                  itemCount: actorsToDisplay.length,
                  itemBuilder: (context, index) {
                    final actor = actorsToDisplay[index];
                    return GestureDetector(
                      onTap: () {
                        AnimatedNavigator.pushZoomIn(
                          context,
                          ActorScreen(actorId: actor.id!),
                        );
                      },
                      child: Card(
                        color: AppStyles.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${actor.profilePath ?? ''}',
                                width: double.infinity,
                                height: 170,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: 160,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.person,
                                        size: 50, color: Colors.grey[600]),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: AutoSizeText(
                                maxLines: 2,
                                actor.name ?? "Unknown Actor",
                                textAlign: TextAlign.center,
                                minFontSize: 8,
                                maxFontSize: 12,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
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
      bottomNavigationBar: AppBottomAppBar(
        selectedIndex: 1, // Actors screen index
        scaffoldKey: widget._scaffoldKey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
