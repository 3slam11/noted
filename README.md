# Noted

Noted is a Flutter application designed to help users track their entertainment across various categories like movies, TV series, books, and games. It allows users to maintain To-Do and Finished lists, search for new items, view details, and manage their viewing/reading/playing history. The app supports localization, dynamic theming, data backup/restore, and custom API key integration.

## Features

*   **Entertainment Tracking:** Manage lists of items you plan to watch/read/play (To-Do) and items you have completed (Finished).
*   **Monthly Rollover:** At the start of a new month, completed items are moved to history, and users can choose which unfinished items to carry over.
*   **Categorization:** Supports Movies, TV Series, Books, and Games.
*   **Search Functionality:** Search for items across different categories using external APIs.
*   **Detailed Information:** View comprehensive details for each item, including descriptions, release dates, ratings, posters, and more.
*   **History:** Keep a record of all completed entertainment items.
*   **Statistics:** View statistics about your consumption habits.
*   **Custom API Keys:** Option to use personal API keys.
*   **Backup & Restore:** Locally backup and restore your app data to a JSON file.
*   **Theming:**
    *   **Auto Theme:** Theme changes automatically based on the current month.
    *   **Manual Theme:** Users can select a preferred theme manually.
    *   Uses `FlexColorScheme` for rich theming capabilities.
*   **Localization:** Uses Slang package for easy to use localization.

## Screenshots

*(TODO.)*

## API Keys

The application uses the following APIs:
*   **RAWG API** for games data.
*   **The Movie Database (TMDB) API** for movies and TV series data.
*   **Google Books API** for books data.

**Using Custom API Keys:**
Users can provide their own API keys via the "Change API" screen in the app settings. These custom keys are stored locally using `shared_preferences` and will be used instead of the default ones if provided.