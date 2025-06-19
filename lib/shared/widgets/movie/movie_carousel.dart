import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/movie/movie_card.dart';
import 'package:app_m0v4u/ui/home_screen/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MovieCarousel extends StatefulWidget {
  final List<Movie> movies;

  const MovieCarousel({super.key, required this.movies});

  @override
  State<MovieCarousel> createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.7);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.movies.length,
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              final isFocused = index == _currentPage;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: isFocused ? 4 : 12, vertical: isFocused ? 0 : 20),
                transform: Matrix4.identity()..scale(isFocused ? 1.0 : 0.9),
                child: MovieCard(movie: movie),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _controller,
          count: widget.movies.length,
          effect: const ExpandingDotsEffect(
            activeDotColor: AppStyles.secondaryColor,
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
          ),
        ),
      ],
    );
  }
}
