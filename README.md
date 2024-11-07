# Movie Finder

Movie Finder is a Flutter app designed to let users explore a wide array of movies. Users can browse through a list of popular movies and search for specific titles to get detailed information, enhancing their movie discovery experience.

## Features

- **Movie List**: Displays a list of popular or trending movies.
- **Search Functionality**: Allows users to search for movies by title.

## Screenshots

![Home Screen](movie_app/assets/home.png)
![Search Screen](movie_app/assets/search.png)


## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 
- [Dart SDK](https://dart.dev/get-dart)

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/sumanthnanis/Movie-flutter-assignment.git
   cd movie-app
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app on an emulator or a physical device:

   ```bash
   flutter run
   ```

### API Setup

This app fetches movie data from an external API (The Movie Database API). You need an API key to fetch movie data.

1. Create an account and get an API key from [The Movie Database](https://www.themoviedb.org/).
2. Add your API key in the appropriate file (e.g., `lib/services/movie_service.dart`):


## Project Structure

```
lib/
├── main.dart                # Main entry point of the application
├── screens/                 # UI screens such as HomeScreen, SearchScreen
│   ├── home_screen.dart
├── widgets/                 # Reusable widgets such as MovieCard 
│   ├── movie_card.dart
├── models/                  # Data models (e.g., Movie model)
│   └── movie.dart
└── services/                # API services and data fetching logic
    └── movie_service.dart
```

## Usage

1. Launch the app.
2. Browse the list of popular movies on the Home screen.
3. Use the search bar to find specific movies.

## Dependencies

- [http](https://pub.dev/packages/http) - For handling API requests.
- [provider](https://pub.dev/packages/provider) - For state management.
---

Enjoy using Movie Finder!
