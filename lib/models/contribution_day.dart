/// Model for a single day's contribution data
class ContributionDay {
  final DateTime date;
  final int contributionCount;

  ContributionDay({required this.date, required this.contributionCount});

  factory ContributionDay.fromJson(Map<String, dynamic> json) {
    return ContributionDay(
      date: DateTime.parse(json['date']),
      contributionCount: json['contributionCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'contributionCount': contributionCount,
    };
  }
}
