import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/shared/widgets/movie/movie_carousel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
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

            if (provider.isLoading){
              return Center(child: const CircularProgressIndicator());
            }
         

            final Actor? actor = provider.actor;
            final List<Movie> movies = provider.movies.take(7).toList();

            if (actor == null) {
              return const Center(child: Text('Acteur non trouvé'));
            }

            final biography = actor.biography ?? 'Pas de biographie disponible.';
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
                  Skeletonizer(
                    enabled: provider.isLoading,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      children: const [
                        Icon(Icons.alternate_email),
                        Icon(Icons.camera_alt_outlined),
                        Icon(Icons.share),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                          _buildInfoRow('Célèbre pour', actor.knownForDepartment ?? 'N/A'),
                          _buildInfoRow('Apparitions connues', movies.length.toString()),
                          _buildInfoRow('Genre', actor.gender == 1 ? 'Femme' : 'Homme'),
                          _buildInfoRow('Date de naissance', _formatDate(actor.birthday)),
                          _buildInfoRow('Lieu de naissance', actor.placeOfBirth ?? 'N/A'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Skeletonizer(
                    enabled: provider.isLoading,
                    child: const Text(
                      'Biographie',
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
                        _isBioExpanded ? 'Réduire' : 'Lire la suite',
                        style: const TextStyle(color: AppStyles.secondaryColor),
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (movies.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Célèbre pour',
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
                      child: MovieCarousel(movies: movies)),
                  ]
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
          Text('$label: ',
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}
