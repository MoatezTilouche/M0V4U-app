import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/animations/animation_navigator.dart';
import 'package:app_m0v4u/ui/actor/view/actor_screen.dart';
import 'package:app_m0v4u/ui/movie_screen/models/movie.dart';
import 'package:flutter/material.dart';

class ActorCard extends StatelessWidget {
  final Actor actor;

  const ActorCard({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AnimatedNavigator.pushZoomIn(
          context,
          ActorScreen(actorId: actor.id)
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppStyles.darkColor,
         
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: actor.profilePath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w185${actor.profilePath}',
                      height: 100,
                      width: 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 80,
                      width: 50,
                      color: const Color(0xFF09122C),
                      child: const Icon(Icons.person, color: Colors.white54),
                    ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(actor.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    Text(actor.character,
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
