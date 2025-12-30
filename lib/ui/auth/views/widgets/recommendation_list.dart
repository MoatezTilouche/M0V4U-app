import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/animations/animation_navigator.dart';
import 'package:app_m0v4u/ui/auth/providers/auth_provider.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/skeleton_card.dart';
import 'package:app_m0v4u/ui/movie_screen/providers/favorites_provider.dart';
import 'package:app_m0v4u/ui/movie_screen/view/movie_screen.dart';
import 'package:app_m0v4u/ui/tv_show_screen/providers/tv_favorite_provider.dart';
import 'package:app_m0v4u/ui/tv_show_screen/views/tv_show_detail_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../constants/assets.dart';

class RecommendationList extends StatelessWidget {
final String type;
final AuthProvider auth;

const RecommendationList({super.key, required this.type, required this.auth});

void _showSnackBar(BuildContext context, String message, bool isSuccess) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(message, style: const TextStyle(color: Colors.white)),
backgroundColor: isSuccess ? AppStyles.secondaryColor : Colors.redAccent,
behavior: SnackBarBehavior.floating,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
margin: const EdgeInsets.all(16),
duration: const Duration(seconds: 3),
),
);
}

@override
Widget build(BuildContext context) {
return type == 'Movies'
? Consumer<FavoriteProvider>(
builder: (context, favoriteProvider, _) {
return Skeletonizer(
enabled: favoriteProvider.isLoadingRecommendations,
child: favoriteProvider.isLoadingRecommendations
? SizedBox(
height: 260,
child: ListView.builder(
scrollDirection: Axis.horizontal,
itemCount: 5,
itemBuilder: (context, index) => const SkeletonCard(),
),
)
    : Column(
children: [
if (favoriteProvider.error != null)
Center(
child: Column(
children: [
Text(
favoriteProvider.error!,
style: const TextStyle(color: Colors.redAccent, fontSize: 16),
),
const SizedBox(height: 8),
ElevatedButton(
onPressed: () => favoriteProvider.fetchRecommendations(),
style: ElevatedButton.styleFrom(
backgroundColor: AppStyles.secondaryColor,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
child: const Text('Retry'),
),
],
),
),
if (!favoriteProvider.isLoadingRecommendations &&
favoriteProvider.error == null &&
favoriteProvider.recommendations.isEmpty)
Center(
child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ImageIcon( AssetImage(Assets.sad_person_icon)),
    const SizedBox(width: 15,),
    const AutoSizeText(
      maxLines: 2,
      maxFontSize: 16,
      'No Recommendation available for you.',
      style: TextStyle(color: AppStyles.darkColor, fontSize: 14,fontWeight: FontWeight.bold ),
    ),
  ],
),
),
if (!favoriteProvider.isLoadingRecommendations &&
favoriteProvider.error == null &&
favoriteProvider.recommendations.isNotEmpty)
SizedBox(
height: 260,
child: ListView.builder(
scrollDirection: Axis.horizontal,
itemCount: favoriteProvider.recommendations.length,
itemBuilder: (context, index) {
final movie = favoriteProvider.recommendations[index];
final isInFavorites = favoriteProvider.isInFavorites(movie['id']);
return GestureDetector(
onTap: () {
AnimatedNavigator.pushZoomIn(
context,
MovieDetailScreen(movieId: movie['id']),
);
},
child: Container(
width: 160,
margin: const EdgeInsets.only(right: 12),
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Expanded(
child: ClipRRect(
borderRadius: BorderRadius.circular(12),
child: Skeleton.replace(
replacement: Container(
color: Colors.grey[300],
child: const SizedBox.expand(),
),
child: Image.network(
'https://image.tmdb.org/t/p/w185${movie['poster_path']}',
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) => const Icon(
Icons.movie,
color: Colors.white70,
size: 50,
),
),
),
),
),
const SizedBox(height: 8),
SizedBox(
width: 160,
child: Text(
movie['title'] ?? 'Unknown Title',
maxLines: 2,
overflow: TextOverflow.ellipsis,
textAlign: TextAlign.center,
style: const TextStyle(
color: AppStyles.darkColor,
fontSize: 14,
fontWeight: FontWeight.w600,
),
),
),
const SizedBox(height: 4),
Text(
movie['release_date']?.substring(0, 4) ?? 'N/A',
textAlign: TextAlign.center,
style: const TextStyle(color: Colors.black54, fontSize: 12),
),
IconButton(
icon: Icon(
isInFavorites ? Icons.favorite : Icons.add_circle,
color: isInFavorites ? Colors.redAccent : AppStyles.secondaryColor,
size: 20,
),
onPressed: () async {
await favoriteProvider.toggleFavorite(
auth: auth,
movieId: movie['id'],
add: !isInFavorites,
);
if (favoriteProvider.error != null) {
_showSnackBar(context, favoriteProvider.error!, false);
} else {
_showSnackBar(
context,
isInFavorites ? 'Removed from favorites' : 'Added to favorites',
true,
);
}
},
),
],
),
),
);
},
),
),
],
),
);
},
)
    : Consumer<TvFavoriteProvider>(
builder: (context, tvFavoriteProvider, _) {
return Skeletonizer(
enabled: tvFavoriteProvider.isLoadingRecommendations,
child: tvFavoriteProvider.isLoadingRecommendations
? SizedBox(
height: 260,
child: ListView.builder(
scrollDirection: Axis.horizontal,
itemCount: 5,
itemBuilder: (context, index) => const SkeletonCard(),
),
)
    : Column(
children: [
if (tvFavoriteProvider.error != null)
Center(
child: Column(
children: [
Text(
tvFavoriteProvider.error!,
style: const TextStyle(color: Colors.redAccent, fontSize: 16),
),
const SizedBox(height: 8),
ElevatedButton(
onPressed: () => tvFavoriteProvider.fetchRecommendations(),
style: ElevatedButton.styleFrom(
backgroundColor: AppStyles.secondaryColor,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
child: const Text('Retry'),
),
],
),
),
if (!tvFavoriteProvider.isLoadingRecommendations &&
tvFavoriteProvider.error == null &&
tvFavoriteProvider.recommendations.isEmpty)
const Center(
child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ImageIcon( AssetImage(Assets.sad_person_icon)),
    const SizedBox(width: 15,),
    const AutoSizeText(
      maxLines: 2,
      maxFontSize: 16,
      'No Recommendation available for you.',
      style: TextStyle(color: AppStyles.darkColor, fontSize: 14,fontWeight: FontWeight.bold ),
    ),
  ],
),
),
if (!tvFavoriteProvider.isLoadingRecommendations &&
tvFavoriteProvider.error == null &&
tvFavoriteProvider.recommendations.isNotEmpty)
SizedBox(
height: 260,
child: ListView.builder(
scrollDirection: Axis.horizontal,
itemCount: tvFavoriteProvider.recommendations.length,
itemBuilder: (context, index) {
final tv = tvFavoriteProvider.recommendations[index];
final isInFavorites = tvFavoriteProvider.isInFavorites(tv['id']);
return GestureDetector(
onTap: () {
AnimatedNavigator.pushZoomIn(
context,
TvShowDetailScreen(tvShowId: tv['id']),
);
},
child: Container(
width: 160,
margin: const EdgeInsets.only(right: 12),
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Expanded(
child: ClipRRect(
borderRadius: BorderRadius.circular(12),
child: Skeleton.replace(
replacement: Container(
color: Colors.grey[300],
child: const SizedBox.expand(),
),
child: Image.network(
'https://image.tmdb.org/t/p/w185${tv['poster_path']}',
fit: BoxFit.cover,
errorBuilder: (_, __, ___) => const Icon(
Icons.tv,
color: Colors.white70,
size: 50,
),
),
),
),
),
const SizedBox(height: 8),
SizedBox(
width: 160,
child: Text(
tv['name'] ?? 'Unknown Title',
maxLines: 2,
overflow: TextOverflow.ellipsis,
textAlign: TextAlign.center,
style: const TextStyle(
color: AppStyles.darkColor,
fontSize: 14,
fontWeight: FontWeight.w600,
),
),
),
const SizedBox(height: 4),
Text(
tv['first_air_date']?.substring(0, 4) ?? 'N/A',
style: const TextStyle(color: Colors.black54, fontSize: 12),
),
IconButton(
icon: Icon(
isInFavorites ? Icons.favorite : Icons.add_circle,
color: isInFavorites ? Colors.redAccent : AppStyles.secondaryColor,
size: 20,
),
onPressed: () async {
await tvFavoriteProvider.toggleTvFavorite(
auth: auth,
tvShowId: tv['id'],
add: !isInFavorites,
);
if (tvFavoriteProvider.error != null) {
_showSnackBar(context, tvFavoriteProvider.error!, false);
} else {
_showSnackBar(
context,
isInFavorites ? 'Removed from favorites' : 'Added to favorites',
true,
);
}
},
),
],
),
),
);
},
),
),
],
),
);
},
);
}
}