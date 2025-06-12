// import 'package:app_m0v4u/model.dart';
// import 'package:app_m0v4u/provider_expl.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MovieScreen extends StatefulWidget {
//   @override
//   State<MovieScreen> createState() => _MovieScreenState();
// }

// class _MovieScreenState extends State<MovieScreen> {
//   late final provider;

//   @override
//   void initState() {
//     provider = context.read<MovieProvider>();
//     provider.loadPopularMovies();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MovieProvider>(
//       builder: (context,movieProvider,_) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text('Popular Movies'),
//           ),
//           body: movieProvider.isLoading
//               ? Center(child: CircularProgressIndicator())
//               : movieProvider.movies.isEmpty
//                   ? Center(child: Text('No movies found.'))
//                   : ListView.builder(
//                       itemCount: movieProvider.movies.length,
//                       itemBuilder: (context, index) {
//                         Movie movie = movieProvider.movies[index];
//                         return ListTile(
//                           title: Text(movie.title),
//                           subtitle: Text(movie.overview),
//                           leading: movie.posterPath != null
//                               ? Image.network(
//                                   'https://image.tmdb.org/t/p/w500${movie.posterPath}')
//                               : null,
//                         );
//                       },
//                     ),
//         );
//       }
//     );
//   }
// }
