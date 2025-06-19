import 'package:app_m0v4u/shared/widgets/animations/animation_navigator.dart';
import 'package:app_m0v4u/ui/trailer_screen/views/youtube_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/trailer_provider.dart';

class TrailerSelectorWidget extends StatelessWidget {
  const TrailerSelectorWidget({super.key});

  final Map<String, String> categoryLabels = const {
    'popular': 'Popular',
    'upcoming': 'Upcoming',
    'now_playing': 'Now Playing',
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<TrailerProvider>(
      builder: (context, trailerProvider, _) {
        if (trailerProvider.trailers.isEmpty) {
          trailerProvider.loadTrailers("popular");
        }
        return Skeletonizer(
          enabled: trailerProvider.isLoading,
          child: Container(
            decoration: const BoxDecoration(color: AppStyles.secondaryColor),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text(
                        'Watch Trailers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF26C6DA), Color(0xFF00C853)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: const Color(0xFFfefeff),
                            value: trailerProvider.category,
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            items: categoryLabels.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                trailerProvider.loadTrailers(value);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Trailer list
                Skeletonizer(
                  enabled: trailerProvider.isLoading,
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trailerProvider.trailers.length,
                      itemBuilder: (context, index) {
                        final trailer = trailerProvider.trailers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            width: 160,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    AnimatedNavigator.pushZoomIn(
                                      context,
                                      YouTubeScreen(
                                          videoId: trailer.videoKey,
                                          title: trailer.movieTitle),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      trailer.thumbnailUrl,
                                      width: 160,
                                      height: 140,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, _, __) =>
                                          const Icon(Icons.broken_image,
                                              size: 50, color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  trailer.movieTitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
