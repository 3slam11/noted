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

<p float="left">
<img src="https://github.com/user-attachments/assets/d31e6a87-9f18-4e14-ae26-013d9ffbd3cb" width="30%"/>
<img src="https://github.com/user-attachments/assets/11cf5d74-6c8c-411f-ad25-2730960891f1" width="30%"/>
<img src="https://github.com/user-attachments/assets/35fc8aef-c70c-47c5-a661-f424d5d77b96" width="30%"/>
   </p>
   <p float="left">
<img src="https://github.com/user-attachments/assets/b5a85f26-9cae-433e-8724-d883de2cf3c0" width="30%"/>
<img src="https://github.com/user-attachments/assets/42e3a096-0544-4aa0-a658-aa5857a27362" width="30%"/
   </p>


## API Keys

The application uses the following APIs:
*   **RAWG API** for games data.
*   **The Movie Database (TMDB) API** for movies and TV series data.
*   **Google Books API** for books data.

**Using Custom API Keys:**
Users can provide their own API keys via the "Change API" screen in the app settings. These custom keys are stored locally using `shared_preferences` and will be used instead of the default ones if provided.
