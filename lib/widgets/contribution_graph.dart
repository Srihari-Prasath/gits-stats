import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/contribution_day.dart';
import '../theme/app_theme.dart';

/// GitHub-style contribution graph widget
class ContributionGraph extends StatelessWidget {
  final List<ContributionDay> contributionDays;

  const ContributionGraph({super.key, required this.contributionDays});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: const [
                Icon(Icons.grid_on, size: 20, color: AppTheme.textSecondary),
                SizedBox(width: 8),
                Text(
                  'Contribution Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Graph
            _buildGraph(),
            const SizedBox(height: 16),

            // Legend
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildGraph() {
    // Group by weeks
    final weeks = <List<ContributionDay>>[];
    List<ContributionDay> currentWeek = [];

    for (var day in contributionDays) {
      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
      currentWeek.add(day);
    }
    if (currentWeek.isNotEmpty) {
      weeks.add(currentWeek);
    }

    // Get last 12 weeks
    final recentWeeks = weeks.length > 12
        ? weeks.sublist(weeks.length - 12)
        : weeks;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month labels (left side)
          _buildMonthLabels(recentWeeks),
          const SizedBox(width: 8),

          // Weeks
          ...recentWeeks.map((week) => _buildWeek(week)),
        ],
      ),
    );
  }

  Widget _buildMonthLabels(List<List<ContributionDay>> weeks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 20), // Space for month labels
        ...List.generate(7, (index) {
          if (index % 2 == 1) {
            return Container(
              height: 12,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index],
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textTertiary,
                ),
              ),
            );
          }
          return const SizedBox(height: 12);
        }),
      ],
    );
  }

  Widget _buildWeek(List<ContributionDay> week) {
    String? monthLabel;
    if (week.isNotEmpty) {
      final firstDay = week.first.date;
      if (firstDay.day <= 7) {
        monthLabel = DateFormat('MMM').format(firstDay);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: Column(
        children: [
          // Month label
          SizedBox(
            height: 20,
            child: monthLabel != null
                ? Text(
                    monthLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textTertiary,
                    ),
                  )
                : null,
          ),

          // Days
          ...week.map((day) => _buildDay(day)),
        ],
      ),
    );
  }

  Widget _buildDay(ContributionDay day) {
    final color = AppTheme.getContributionColor(day.contributionCount);

    return Tooltip(
      message:
          '${day.contributionCount} contributions on ${DateFormat('MMM dd, yyyy').format(day.date)}',
      child: Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: color == AppTheme.contributionNone
                ? AppTheme.borderColor
                : Colors.transparent,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        const Text(
          'Less',
          style: TextStyle(fontSize: 11, color: AppTheme.textTertiary),
        ),
        const SizedBox(width: 8),
        _buildLegendBox(AppTheme.contributionNone),
        _buildLegendBox(AppTheme.contributionLow),
        _buildLegendBox(AppTheme.contributionMedium),
        _buildLegendBox(AppTheme.contributionHigh),
        _buildLegendBox(AppTheme.contributionVeryHigh),
        const SizedBox(width: 8),
        const Text(
          'More',
          style: TextStyle(fontSize: 11, color: AppTheme.textTertiary),
        ),
      ],
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: color == AppTheme.contributionNone
              ? AppTheme.borderColor
              : Colors.transparent,
          width: 1,
        ),
      ),
    );
  }
}
