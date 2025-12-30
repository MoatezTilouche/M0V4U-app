import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/actor/actor_card.dart';
import 'package:app_m0v4u/ui/movie_screen/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class ActorCarousel extends StatefulWidget {
  final List<Actor> actors;

  const ActorCarousel({super.key, required this.actors});

  @override
  State<ActorCarousel> createState() => _ActorCarouselState();
}

class _ActorCarouselState extends State<ActorCarousel> {
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
  Widget build(BuildContext context) {
    if (widget.actors.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cast',
          style: TextStyle(
            color: AppStyles.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.actors.length,
            itemBuilder: (context, index) {
              return ActorCard(actor: widget.actors[index]);
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.actors.length,
            effect: const WormEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: AppStyles.secondaryColor,
              dotColor: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
