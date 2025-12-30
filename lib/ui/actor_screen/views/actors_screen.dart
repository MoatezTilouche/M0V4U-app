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
import '../../../shared/widgets/bottomBar/bottom_bar.dart';
import '../../actor/models/actor.dart';
import '../providers/actor_screen_provider.dart';

class ActorsScreen extends StatefulWidget {
  const ActorsScreen({super.key});

  @override
  State<ActorsScreen> createState() => _ActorsScreenState();
}

class _ActorsScreenState extends State<ActorsScreen> {
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;
  String searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActorsProvider>(context, listen: false).fetchPopularActors();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<ActorsProvider>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        !provider.isLoading &&
        provider.popularHasMorePages) {
      if (searchQuery.isEmpty) {
        provider.fetchPopularActors();
      } else {
        provider.searchActors(searchQuery);
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = query;
      });
      if (searchQuery.isEmpty) {
        context.read<ActorsProvider>().fetchPopularActors();
      } else {
        context.read<ActorsProvider>().searchActors(searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      body: Column(
        children: [
          // Search field
          Container(
            decoration: BoxDecoration(
              color: AppStyles.secondaryColor,
            ),
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Search Popular actors...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _textEditingController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                    context.read<ActorsProvider>().fetchPopularActors();
                  },
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          // Results
          Expanded(
            child: Consumer<ActorsProvider>(
              builder: (context, provider, _) {
                final actorsToDisplay = searchQuery.isEmpty
                    ? provider.popularActors
                    : provider.searchResults;

                if (provider.errorMessage != null && !provider.isLoading) {
                  return Center(child: Text(provider.errorMessage!));
                }

                return Skeletonizer(
                  enabled: provider.isLoading && actorsToDisplay.isEmpty,
                  child: actorsToDisplay.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, color: AppStyles.secondaryColor, size: 50),
                        const SizedBox(height: 25),
                        const Text(
                          'No actors found',
                          style: TextStyle(color: AppStyles.darkColor, fontSize: 20),
                        ),
                      ],
                    ),
                  )
                      : GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
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
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${actor.profilePath ?? ''}',
                                  width: double.infinity,
                                  height: 170,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.person,
                                      color: Colors.white70, size: 50),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: AutoSizeText(
                                  actor.name ?? "Unknown Actor",
                                  maxLines: 2,
                                  minFontSize: 8,
                                  maxFontSize: 12,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

