import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/ui/home_screen/views/actor_card_home.dart';
import 'package:app_m0v4u/ui/movie_screen/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ActorHomeCarousel extends StatefulWidget {
  final List<Actor> actors;

  const ActorHomeCarousel({super.key, required this.actors});

  @override
  State<ActorHomeCarousel> createState() => _ActorHomeCarouselState();
}

class _ActorHomeCarouselState extends State<ActorHomeCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.5);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final next = _pageController.page?.round() ?? 0;
      if (_currentPage != next) {
        setState(() => _currentPage = next);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.actors.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 200, 
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.actors.length,
            itemBuilder: (context, index) {
              final actor = widget.actors[index];
              final double popularity;
              if(actor.popularity != null){
                popularity = actor.popularity!;
                
              }
              else{
                popularity = 0.0;
              }

             String formattedPopularity=popularity.toStringAsFixed(0);
              

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TrendingActorCard(
                  actor: actor,
                  position: index + 1,
                  trendChange: formattedPopularity,
                ),
              );
            },
          ),
        ),
        
      ],
    );
  }
}
