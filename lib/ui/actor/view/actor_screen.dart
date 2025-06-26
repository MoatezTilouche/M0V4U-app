import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/shared/widgets/movie/movie_carousel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/actor_provider.dart';
import '../models/actor.dart';
import '../../home_screen/models/movie_model.dart';

class ActorScreen extends StatefulWidget {
  final int actorId;

  const ActorScreen({super.key, required this.actorId});

  @override
  State<ActorScreen> createState() => _ActorScreenState();
}

class _ActorScreenState extends State<ActorScreen> {
  bool _isBioExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActorProvider()..loadActor(widget.actorId),
      child: Scaffold(
        appBar: const CustomNavBar(),
        backgroundColor: AppStyles.primaryColor,
        body: Consumer<ActorProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final Actor? actor = provider.actor;
            final List<Movie> movies = provider.movies.take(7).toList();

            if (actor == null) {
              return const Center(child: Text('Actor not found'));
            }

            final biography = actor.biography ?? 'No biography available.';
            final isLongBio = biography.length > 300;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Skeletonizer(
                    enabled: provider.isLoading,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w300${actor.profilePath}',
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Skeletonizer(
                    enabled: provider.isLoading,
                    child: Text(
                      actor.name ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// SHARE BUTTON
                  Skeletonizer(
                    enabled: provider.isLoading,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.black),
                          onPressed: () {
                            final name = actor.name ?? 'Unknown Actor';
                            final bio = actor.biography ?? 'No biography available.';
                            final origin = actor.placeOfBirth ?? 'Unknown location';

                            final message = '''
                          Check out this actor: $name

                          Origin: $origin
                          Known for: ${actor.knownForDepartment ?? 'N/A'}
                          Popular movies: ${movies.map((m) => m.title).join(', ')}
                          
                          Bio: $bio
                          ''';
                            final params=ShareParams(
                              text: message.trim(),
                              subject:'Discover $name',

                            );

                            SharePlus.instance.share(params);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Actor Info
                  Skeletonizer(
                    enabled: provider.isLoading,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf6f6f6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Popular for', actor.knownForDepartment ?? 'N/A'),
                          _buildInfoRow('Known appearances', movies.length.toString()),
                          _buildInfoRow('Gender', actor.gender == 1 ? 'Female' : 'Male'),
                          _buildInfoRow('Birth Date', _formatDate(actor.birthday)),
                          _buildInfoRow('Origin', actor.placeOfBirth ?? 'N/A'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Biography
                  Skeletonizer(
                    enabled: provider.isLoading,
                    child: const Text(
                      'Biography',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Skeletonizer(
                    enabled: provider.isLoading,
                    child: Text(
                      biography,
                      style: const TextStyle(color: Colors.black87),
                      maxLines: _isBioExpanded ? null : 4,
                      overflow: _isBioExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                  ),
                  if (isLongBio)
                    TextButton(
                      onPressed: () {
                        setState(() => _isBioExpanded = !_isBioExpanded);
                      },
                      child: Text(
                        _isBioExpanded ? 'Less' : 'More',
                        style: const TextStyle(color: AppStyles.secondaryColor),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Famous Movies
                  if (movies.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Famous for',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Skeletonizer(
                      enabled: provider.isLoading,
                      child: MovieCarousel(movies: movies),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}
