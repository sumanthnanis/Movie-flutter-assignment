import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const _apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZTllNTY4YTI4YWY5MzE5NzVhYTA3NDU3OTM0ZGViOCIsIm5iZiI6MTczMDkwNjM0My4wMjM4NDQsInN1YiI6IjY3MmI4ODYwMmY2NGViZThjOGU0ZWI3YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.gwkNmf7Kl29zbSaccNxgzfqgvdkJpuDv8pwUE7c70qA';
  static const _searchapi = '1e9e568a28af931975aa07457934deb8';
  static const _baseUrl = 'api.themoviedb.org';

  static Future<List<Movie>> fetchPopularMovies() async {
    try {
      final canReachApi = await _checkConnectivity();
      if (!canReachApi) {
        throw Exception('Cannot reach TMDB API. Please check your internet connection.');
      }

      final uri = Uri.https(_baseUrl, '/3/movie/popular', {
        'language': 'en-US',
        'page': '1',
      });

      print('Attempting to fetch from URL: ${uri.toString()}');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null && jsonData['results'] is List) {
          final movies = (jsonData['results'] as List)
              .map((item) => Movie.fromJson(item))
              .toList();
          return movies;
        } else {
          throw Exception('Invalid data format received from API');
        }
      } else {
        print('Error response body: ${response.body}');
        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('SocketException: $e');
      throw Exception('Network error: Please check your internet connection');
    } on TimeoutException catch (e) {
      print('TimeoutException: $e');
      throw Exception('Request timed out: Please try again');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to fetch movies: $e');
    }
  }

  static Future<List<Movie>> searchMovies(String query) async {
    try {
      final canReachApi = await _checkConnectivity();
      if (!canReachApi) {
        throw Exception('Cannot reach TMDB API. Please check your internet connection.');
      }

      final uri = Uri.https(_baseUrl, '/3/search/movie', {
        'query': query,
        'include_adult': 'false',
        'language': 'en-US',
        'page': '1',
        'api_key': _searchapi,
      });

      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null && jsonData['results'] is List) {
          return (jsonData['results'] as List)
              .map((item) => Movie.fromJson(item))
              .toList();
        } else {
          throw Exception('Invalid data format received from API');
        }
      } else {
        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in searchMovies: $e');
      rethrow;
    }
  }

  static Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup(_baseUrl);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (e) {
      print('Connectivity check failed: $e');
      return false;
    }
  }
}