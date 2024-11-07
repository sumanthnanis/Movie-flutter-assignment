import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> get movies => _movies;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPopularMovies() async {
    try {
      _isLoading = true;
      notifyListeners();
      _movies = await MovieService.fetchPopularMovies();
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error fetching popular movies: $e';
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    try {
      _isLoading = true;
      notifyListeners();
      _movies = await MovieService.searchMovies(query);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error searching movies: $e';
      notifyListeners();
    }
  }
}