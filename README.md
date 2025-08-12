# 📱Market Movers

Market Movers is a Flutter-based mobile app that lets users track real-time prices, trends, and charts for their favorite cryptocurrencies. It features clean UI, onboarding, favorites, charting with `fl_chart`, and uses CoinGecko API.

## 🔗 Try it here  
[Live Demo](http://preeminent-clafoutis-d4bcd1.netlify.app)

## 🚀 Features

- Real-time crypto data
- 7-day price history chart
- Favorite coins tracking
- INR / USD toggle
- Onboarding screen with Lottie animations

## 🛠️ Tech Stack

- Flutter
- Provider (state management)
- CoinGecko API
- fl_chart
- SharedPreferences

## 🧠 How to Run

```bash
flutter pub get
flutter run


🧠 How It Works
The app fetches real-time cryptocurrency data from the CoinGecko API.
Price history for the last 7 days is visualized using fl_chart line charts.
Users can mark/unmark coins as favorites, which are stored locally using SharedPreferences.
The app supports toggling currency display between INR and USD globally.
Onboarding screens introduce the app features with animated Lottie files on first launch.
Provider handles state management for smooth UI updates.

🤝 Contributing
Contributions are welcome! To contribute:
Fork the repo
Create a new branch: git checkout -b feature-name
Commit your changes: git commit -m "Add feature"
Push to the branch: git push origin feature-name
Open a Pull Request



