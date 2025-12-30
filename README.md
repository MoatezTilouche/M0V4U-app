# 🎬 M0V4U - Movie & TV Shows App

A comprehensive Flutter application for movie and TV show enthusiasts. Browse, discover, and manage your favorite movies and TV shows with a modern, intuitive interface powered by The Movie Database (TMDB) API.

## ✨ Features

### 🏠 Core Features

- **Home Screen**: Discover trending, popular, and top-rated movies and TV shows
- **Movies Browser**: Explore movies by categories (Popular, Upcoming, Top Rated)
- **TV Shows**: Browse and discover TV shows with detailed information
- **Genres**: Filter movies and TV shows by genre categories
- **Actor Information**: Detailed actor profiles and filmography
- **Search**: Find movies, TV shows, and actors quickly

### 🎥 Movie & TV Show Details

- Comprehensive movie/show information (synopsis, ratings, release date)
- Cast and crew information
- Similar movie/show recommendations
- User reviews
- Trailers and video content
- YouTube player integration for trailers

### 👤 User Features

- **TMDB Authentication**: Sign in with your TMDB account
- **Watchlist**: Save movies and TV shows to watch later
- **Favorites**: Mark movies and TV shows as favorites
- **Profile Management**: View and manage your TMDB profile

### 🤖 AI Chatbot

- **B0T4U**: An intelligent movie assistant powered by Google Gemini AI
- Get personalized movie recommendations
- Ask questions about movies, actors, and genres
- Context-aware conversations about cinema

### 📱 User Experience

- Modern, dark-themed UI
- Smooth animations and page transitions
- Skeleton loading states for better UX
- Cached network images for faster loading
- Responsive design for all screen sizes
- Share functionality for movies and shows

## 📸 Screenshots

The `screenshots/` folder contains:

- Home page
- Movies browsing page
- TV shows page
- Actor details page
- Movie detail screen
- Profile page
- Chatbot interface

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.4.1)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- A TMDB API key and access token
- A Google Gemini API key

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd M0V4U-app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure API Keys**

   Open `lib/constants/constants.dart` and add your API keys:

   ```dart
   const apiKey = 'YOUR_TMDB_API_KEY';
   const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
   const String accessToken = "YOUR_TMDB_ACCESS_TOKEN";
   ```

   **Getting API Keys:**

   - **TMDB API Key**: Sign up at [The Movie Database](https://www.themoviedb.org/settings/api)
   - **TMDB Access Token**: Generate from your TMDB account settings
   - **Gemini API Key**: Get from [Google AI Studio](https://makersuite.google.com/app/apikey)

4. **Generate app icons** (optional)

   ```bash
   flutter pub run flutter_launcher_icons
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Main Dependencies

- **dio** (^5.0.0): HTTP client for API requests
- **provider** (^6.1.5): State management solution
- **flutter_gemini** (^3.0.0): Google Gemini AI integration
- **youtube_player_flutter** (^9.1.1): YouTube video playback
- **cached_network_image** (^3.4.1): Image caching and loading
- **shared_preferences** (^2.5.3): Local data persistence
- **url_launcher** (^6.3.1): Launch URLs and deep links
- **smooth_page_indicator** (^1.2.1): Page view indicators
- **animations** (^2.0.11): Smooth UI transitions
- **skeletonizer** (1.4.3): Loading skeleton screens
- **auto_size_text** (^3.0.0): Auto-sizing text widgets
- **share_plus** (^11.0.0): Share functionality
- **intl** (^0.20.2): Internationalization support

### Dev Dependencies

- **flutter_launcher_icons** (^0.14.4): App icon generation
- **flutter_lints** (^5.0.0): Linting and code quality

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── constants/                   # App-wide constants
│   ├── app_urls.dart           # API endpoints
│   ├── assets.dart             # Asset paths
│   ├── constants.dart          # API keys and configs
│   ├── enums.dart              # Enumerations
│   └── styles.dart             # Theme and styles
├── services/                    # API service layer
│   ├── auth_service.dart
│   ├── movie_detail_service.dart
│   ├── movies_service.dart
│   ├── tv_shows_service.dart
│   ├── actor_service.dart
│   ├── trailer_service.dart
│   └── user_services.dart
├── shared/                      # Shared widgets
│   └── widgets/
├── ui/                          # UI screens
│   ├── splash_screen.dart
│   ├── mainScreen/
│   ├── home_screen/
│   ├── movies/
│   ├── movie_screen/
│   ├── tv_shows_screen/
│   ├── tv_show_screen/
│   ├── actor/
│   ├── actor_screen/
│   ├── genre_screen/
│   ├── trailer_screen/
│   ├── chat_bot_screen/
│   └── auth/
```

## 🏗️ Architecture

The app follows the **Provider** pattern for state management with a clean separation of concerns:

- **UI Layer**: Screens and widgets
- **Provider Layer**: State management (ChangeNotifierProvider)
- **Service Layer**: API communication and business logic
- **Models**: Data structures for API responses

### Key Providers

- `HomeScreenProvider`: Home screen data
- `MoviesProvider`: Movies listing and filtering
- `TvShowsProvider`: TV shows data
- `MovieDetailProvider`: Movie details
- `ActorProvider`: Actor information
- `AuthProvider`: User authentication
- `WatchlistProvider` / `FavoriteProvider`: User lists
- `ChatBotProvider`: AI chatbot functionality
- `TrailerProvider` / `YouTubeProvider`: Video playback

## 🎨 Theming

The app features a modern dark theme with:

- Black scaffold background
- Red primary color scheme
- Custom styled components
- Smooth animations and transitions

## 🔐 Authentication

The app uses TMDB's authentication flow:

1. Request token generation
2. User approval via browser redirect
3. Session creation
4. Access to user-specific features (watchlist, favorites)

## 🤖 AI Chatbot (B0T4U)

Powered by Google Gemini AI, the chatbot:

- Provides movie recommendations
- Answers questions about movies, actors, and genres
- Maintains conversation context
- Only responds to movie-related queries
- Uses TMDB knowledge base

## 🌐 API Integration

The app integrates with:

- **TMDB API**: Movie, TV show, and actor data
- **Google Gemini AI**: Chatbot functionality
- **YouTube**: Trailer playback

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🛠️ Development

### Code Quality

- Follows Flutter best practices
- Uses `flutter_lints` for code analysis
- Implements proper error handling
- Includes loading states and empty states

### Running Tests

```bash
flutter test
```

### Building for Production

**Android:**

```bash
flutter build apk --release
```

**iOS:**

```bash
flutter build ios --release
```

**Web:**

```bash
flutter build web --release
```

## 📄 License

This project is a private application and is not published to pub.dev.

## 🙏 Acknowledgments

- [The Movie Database (TMDB)](https://www.themoviedb.org/) for the comprehensive movie database API
- [Google Gemini AI](https://ai.google.dev/) for AI chatbot capabilities
- Flutter community for excellent packages and support

## 📞 Support

For issues, questions, or suggestions, please open an issue in the repository.

---
## 👨‍💻 Author

<div align="center">

### **Moatez Tilouch**

_Full Stack Developer & AI Enthusiast_

[![GitHub](https://img.shields.io/badge/GitHub-MoatezTilouche-181717?style=for-the-badge&logo=github)](https://github.com/MoatezTilouche)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Moatez%20Tilouch-0A66C2?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/moatez-tilouch-a58a96284/)
[![Email](https://img.shields.io/badge/Email-moateztilouch%40gmail.com-EA4335?style=for-the-badge&logo=gmail)](mailto:moateztilouch@gmail.com)

</div>

---

**Made with ❤️ using Flutter**
