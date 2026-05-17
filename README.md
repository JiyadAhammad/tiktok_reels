# TikTok Reels Clone (Flutter)

A fully functional, high-performance TikTok-style Reels application built with Flutter. This project demonstrates seamless vertical video scrolling, dynamic video fetching from Firebase Firestore, and advanced caching for a smooth user experience.

## 🚀 Features

- **Vertical Video Scrolling**: Smooth, TikTok-like vertical swipe interactions using `preload_page_view`.
- **Dynamic Firebase Pagination**: Videos are fetched from Cloud Firestore dynamically in batches to optimize memory and network usage.
- **Advanced Video Caching**: Utilizes `cached_video_player_plus` to cache videos locally on the device, ensuring they don't have to be re-downloaded when scrolled back to.
- **Smart Preloading**: Pre-initializes and buffers the next few videos in the background so playback is immediate when the user scrolls.
- **State Management**: Built cleanly using the `provider` package to manage application state (`ReelsProvider`) and individual video states (`VideoItemProvider`).
- **Interactive UI**: Includes mock UI elements for Likes, Comments, Shares, Profile Pictures (with `cached_network_image`), Usernames, and Captions.
- **Pagination Loader**: A floating loading indicator automatically appears at the bottom of the screen when fetching the next batch of videos.

## 📦 Tech Stack

- **Flutter / Dart**: Core framework and language.
- **Firebase Firestore**: NoSQL cloud database used to store and fetch video metadata.
- **Provider**: For scalable and predictable state management.
- **Cached Video Player Plus**: For playing and caching video files.
- **Preload Page View**: For eager-loading adjacent pages in the `PageView`.
- **Cached Network Image**: For efficiently loading and caching profile pictures.

## ⚠️ Important Note Regarding Data

To make testing easy, this application includes an `uploadVideo` method in the `ReelsProvider` that statically uploads a set of **5 sample videos** directly to Firebase Firestore. 

Because we fetch videos dynamically using Firestore's pagination cursor (`startAfterDocument`), but are only seeding the database with those 5 static videos in a loop, **you will notice the videos duplicate every 5 items as you scroll.** This is intended behavior for testing the infinite scrolling and pagination logic without needing a massive database of unique videos.

## 🛠 Setup & Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/JiyadAhammad/tiktok_reels.git
   cd tiktok_reels
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration:**
   - This project is **already connected to Firebase**. The necessary Firebase initialization code is present in `lib/main.dart` and `lib/firebase_options.dart`.

4. **Run the App:**
   ```bash
   flutter run
   ```

*(Note: If Firebase is not configured, the app will gracefully fallback to playing local mock data so the UI can still be tested immediately).*

## 📂 Project Structure

- `lib/models/` - Data models (e.g., `Video` model).
- `lib/providers/` - State management controllers (`ReelsProvider`, `VideoItemProvider`).
- `lib/screens/` - Main application screens (`ReelsScreen`).
- `lib/services/` - External API and database services (`VideoService`).
- `lib/widgets/` - Reusable UI components (`VideoPlayerItem`).
