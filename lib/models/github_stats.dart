import 'contribution_day.dart';

/// Model for GitHub user statistics
class GitHubStats {
  final String username;
  final String? name;
  final int totalContributions;
  final List<ContributionDay> contributionDays;
  final int currentStreak;
  final int longestStreak;

  GitHubStats({
    required this.username,
    this.name,
    required this.totalContributions,
    required this.contributionDays,
    required this.currentStreak,
    required this.longestStreak,
  });

  factory GitHubStats.fromGraphQL(Map<String, dynamic> data, String username) {
    final user = data['user'];
    final calendar = user['contributionsCollection']['contributionCalendar'];

    // Parse contribution days
    List<ContributionDay> days = [];
    for (var week in calendar['weeks']) {
      for (var day in week['contributionDays']) {
        days.add(ContributionDay.fromJson(day));
      }
    }

    // Calculate streaks
    final streaks = _calculateStreaks(days);

    return GitHubStats(
      username: username,
      name: user['name'],
      totalContributions: calendar['totalContributions'],
      contributionDays: days,
      currentStreak: streaks['current']!,
      longestStreak: streaks['longest']!,
    );
  }

  static Map<String, int> _calculateStreaks(List<ContributionDay> days) {
    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;

    // Sort days in descending order (most recent first)
    final sortedDays = List<ContributionDay>.from(days)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Calculate current streak (from today backwards)
    final today = DateTime.now();
    bool streakBroken = false;

    for (var day in sortedDays) {
      if (day.date.isAfter(today)) continue;

      if (!streakBroken) {
        if (day.contributionCount > 0) {
          currentStreak++;
        } else {
          // Allow one day grace (today might not have contributions yet)
          final daysDiff = today.difference(day.date).inDays;
          if (daysDiff <= 1) {
            // Don't break streak for today or yesterday if it's early
            continue;
          }
          streakBroken = true;
        }
      }
    }

    // Calculate longest streak
    for (var day in days) {
      if (day.contributionCount > 0) {
        tempStreak++;
        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
      } else {
        tempStreak = 0;
      }
    }

    return {'current': currentStreak, 'longest': longestStreak};
  }
}
