import 'package:app_m0v4u/shared/widgets/animations/animation_navigator.dart';
import 'package:app_m0v4u/ui/actor/view/actor_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_m0v4u/ui/movie_screen/models/movie.dart';

class TrendingActorCard extends StatelessWidget {
  final Actor actor;
  final int position; 
  final String trendChange; 

  const TrendingActorCard({
    super.key,
    required this.actor,
    required this.position,
    required this.trendChange,
  });

  @override
  Widget build(BuildContext context) {
    final Icon trendIcon = 
        const Icon(Icons.star, size: 16, color: Colors.amber);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
             AnimatedNavigator.pushZoomIn(
          context,
          ActorScreen(actorId: actor.id)
        );
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: actor.profilePath != null
                ? NetworkImage('https://image.tmdb.org/t/p/w185${actor.profilePath}')
                : null,
            backgroundColor: Colors.grey.shade800,
            child: actor.profilePath == null
                ? const Icon(Icons.person, size: 40, color: Colors.white60)
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            const SizedBox(width: 4),
            trendIcon,
            Text(
              trendChange,
              style: TextStyle( fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          actor.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
