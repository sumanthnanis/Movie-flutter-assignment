import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'dart:io';
class MovieService {
  static const _apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZTllNTY4YTI4YWY5MzE5NzVhYTA3NDU3OTM0ZGViOCIsIm5iZiI6MTczMDkwNjM0My4wMjM4NDQsInN1YiI6IjY3MmI4ODYwMmY2NGViZThjOGU0ZWI3YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.gwkNmf7Kl29zbSaccNxgzfqgvdkJpuDv8pwUE7c70qA';
  static const _searchapi = '1e9e568a28af931975aa07457934deb8';

  static Future<List<Movie>> fetchPopularMovies() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1');
    final httpClient = HttpClient();

    try {
      final request = await httpClient.getUrl(url);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $_apiKey');

      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final jsonData = jsonDecode(responseBody);
        if (jsonData != null && jsonData['results'] is List) {
          final movies = (jsonData['results'] as List)
              .map((item) => Movie.fromJson(item))
              .toList();
          print('Response Body: $responseBody');

          return movies;
        } else {
          throw Exception(
              'Invalid data format: results not found or is not a list');
        }
      } else {
        throw Exception(
            'Error fetching popular movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    } finally {
      httpClient.close();
    }
  }

  static Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?query=$query&include_adult=false&language=en-US&page=1&api_key=$_searchapi');
    final httpClient = HttpClient();

    try {
      final request = await httpClient.getUrl(url);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final jsonData = jsonDecode(responseBody);

        // Check if 'results' exists and is a list
        if (jsonData != null && jsonData['results'] is List) {
          final movies = (jsonData['results'] as List)
              .map((item) => Movie.fromJson(item))
              .toList();
          return movies;
        } else {
          throw Exception(
              'Invalid data format: results not found or is not a list');
        }
      } else {
        throw Exception('Error searching movies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    } finally {
      httpClient.close();
    }
  }
}


