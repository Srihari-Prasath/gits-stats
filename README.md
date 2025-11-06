# 🔥 GitTrack - GitHub Contribution Tracker

A beautiful Flutter app to track your GitHub contribution streak with a sleek dark theme inspired by GitHub's UI.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## ✨ Features

- 🔐 **Secure Authentication** - Login with GitHub Personal Access Token
- 🔥 **Streak Tracking** - View your current and longest contribution streak
- 📊 **Contribution Graph** - Beautiful GitHub-style contribution heatmap
- 📈 **Stats Dashboard** - Total contributions and detailed analytics
- 🎨 **Modern UI** - Dark theme with GitHub-inspired design
- 🔄 **Pull to Refresh** - Instantly update your stats

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- GitHub Personal Access Token

### Installation

1. Clone the repository:

```bash
git clone <your-repo-url>
cd my_streak
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## 🔑 Setting Up Your GitHub Token

1. Go to **GitHub Settings** → **Developer Settings**
2. Click on **Personal Access Tokens** → **Tokens (classic)**
3. Click **Generate new token (classic)**
4. Give it a name (e.g., "GitTrack Access")
5. Select the following scopes:
   - ✅ `read:user`
   - ✅ `repo` (read-only)
6. Click **Generate token**
7. Copy the token (you won't be able to see it again!)
8. **Paste it into `lib/config/app_config.dart`** replacing `your_github_token_here`

> **⚠️ Security Note**: This app stores credentials directly in the code for personal use only.
> **Do NOT commit your token to public repositories!** Add `lib/config/app_config.dart` to `.gitignore`.

## 📱 App Structure

```
lib/
├── config/
│   └── app_config.dart          # App configuration
├── models/
│   ├── contribution_day.dart    # Contribution day model
│   └── github_stats.dart        # GitHub stats model
├── screens/
│   ├── login_screen.dart        # Login/authentication screen
│   └── home_screen.dart         # Main dashboard
├── services/
│   ├── github_service.dart      # GitHub API integration
│   └── storage_service.dart     # Secure local storage
├── theme/
│   └── app_theme.dart           # App theme and colors
├── widgets/
│   ├── contribution_graph.dart  # Contribution heatmap widget
│   ├── stats_card.dart          # Stats display card
│   └── streak_card.dart         # Streak display card
└── main.dart                    # App entry point
```

## 🎨 Design Philosophy

GitTrack combines GitHub's clean aesthetic with modern mobile UI patterns:

- **Dark Theme**: Easy on the eyes with carefully chosen colors
- **GitHub Green Palette**: Familiar contribution color scheme
- **Card-Based Layout**: Clean separation of information
- **Smooth Animations**: Polished user experience
- **Responsive Design**: Works on all screen sizes

## 🔒 Security

- Tokens are stored securely using Flutter Secure Storage
- No data is sent to any third-party servers
- All communication is directly with GitHub's official API
- Tokens are encrypted at rest

## 🛠️ Technologies Used

- **Flutter & Dart** - Cross-platform mobile framework
- **GraphQL Flutter** - GitHub GraphQL API integration
- **Flutter Secure Storage** - Secure token storage
- **Intl** - Date formatting and localization

## 📊 What's Tracked

- ✅ Daily contribution counts
- ✅ Current streak (consecutive days with contributions)
- ✅ Longest streak (best streak ever)
- ✅ Total contributions (last year)
- ✅ Contribution heatmap (last 12 weeks)

## 🎯 Roadmap

- [ ] Multiple GitHub account support
- [ ] Custom date range selection
- [ ] Contribution breakdown by repository
- [ ] Weekly/monthly stats
- [ ] Dark/Light theme toggle
- [ ] Widgets for home screen
- [ ] Notifications for streak milestones

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Developer

Made with ❤️ by Hari

---

**Note**: This app uses the GitHub GraphQL API v4. Make sure your Personal Access Token has the required permissions.

Happy coding! 🚀
