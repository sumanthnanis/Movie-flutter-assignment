import 'package:flutter/material.dart';
import 'package:movie_app/widget/movie_card.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final _movieProvider = MovieProvider();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _movieProvider.fetchPopularMovies();
    });
  }

  void _searchMovies() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _movieProvider.searchMovies(query);
    } else {
      _movieProvider.fetchPopularMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onSubmitted: (_) => _searchMovies(),
            decoration: InputDecoration(
              hintText: 'Search movies',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => _movieProvider,
        child: Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            if (movieProvider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else if (movieProvider.errorMessage != null) {
              return Center(
                child: Text(
                  movieProvider.errorMessage!,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            } else if (movieProvider.movies.isEmpty) {
              return Center(
                child: Text(
                  'No movies found.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }
            return MovieListView(
              movies: movieProvider.movies.take(4).toList(),
            );
          },
        ),
      ),
    );
  }
}

class MovieListView extends StatelessWidget {
  final List<Movie> movies;

  const MovieListView({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: movies.length,
      itemBuilder: (context, index) => MovieCard(movie: movies[index]),
    );
  }
}