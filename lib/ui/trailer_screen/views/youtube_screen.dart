import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../providers/youtube_provider.dart';
import '../providers/trailer_provider.dart';

class YouTubeScreen extends StatelessWidget {
  final String videoId;
  final String title;

  const YouTubeScreen({
    super.key,
    required this.videoId,
    required this.title,
  });

  void _launchYouTube(String videoId) async {
    final url = Uri.parse("https://www.youtube.com/watch?v=$videoId");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => YouTubeProvider()..initController(videoId),
      builder: (context, child) {
        final trailerProvider =
            Provider.of<TrailerProvider>(context, listen: false);
        final ytProvider = Provider.of<YouTubeProvider>(context, listen: false);

        // Setup autoplay
        ytProvider.onVideoEnded = () {
          final trailers = trailerProvider.trailers;
          final currentIndex =
              trailers.indexWhere((t) => t.videoKey == videoId);
          if (currentIndex != -1 && currentIndex < trailers.length - 1) {
            final next = trailers[currentIndex + 1];
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => YouTubeScreen(
                    videoId: next.videoKey, title: next.movieTitle),
              ),
            );
          }
        };

        return Scaffold(
          backgroundColor: AppStyles.primaryColor,
          appBar: AppBar(
            title: Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            backgroundColor: AppStyles.secondaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.open_in_new),
                tooltip: 'Watch on YouTube',
                onPressed: () => _launchYouTube(videoId),
              )
            ],
          ),
          body: Consumer2<YouTubeProvider, TrailerProvider>(
            builder: (context, yt, trailerProvider, _) {
              return Column(
                children: [
                  YoutubePlayer(
                    controller: yt.controller,
                    showVideoProgressIndicator: true,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppStyles.primaryColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: ListView.builder(
                        itemCount: trailerProvider.trailers.length,
                        itemBuilder: (context, index) {
                          final trailer = trailerProvider.trailers[index];
                          final isCurrent = trailer.videoKey == videoId;

                          return GestureDetector(
                            onTap: () {
                              if (!isCurrent) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => YouTubeScreen(
                                      videoId: trailer.videoKey,
                                      title: trailer.movieTitle,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      trailer.thumbnailUrl,
                                      height: 80,
                                      width: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trailer.movieTitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppStyles.textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          trailer.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () {
                                      // TODO: save to favorites (persist if needed)
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Saved "${trailer.movieTitle}" to favorites!'),
                                        ),
                                      );
                                    },
                                    icon: Image.asset(
                                      Assets.fullLove,
                                      height: 26.0,
                                      width: 26.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
